local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

------------------------------------------------------------
-- Ollama query (stdin-based, async)
------------------------------------------------------------
local function query_local_model(prompt, callback)
  local response = {}
  vim.system(
    { "ollama", "run", "deepseek-coder:1.3b" },
    { text = true, stdin = prompt },
    function(obj)
      if obj.code ~= 0 then
        callback({ "❌ Ollama error" })
        return
      end
      for line in obj.stdout:gmatch("[^\r\n]+") do
        local ok, json = pcall(vim.json.decode, line)
        if ok and json.response then
          table.insert(response, json.response)
        else
          table.insert(response, line)
        end
      end
      if #response == 0 then
        response = { "No response" }
      end
      callback(response)
    end
  )
end

------------------------------------------------------------
-- Format markdown with visual structure
------------------------------------------------------------
local function format_markdown(text)
  local formatted = {}
  local in_code_block = false
  local code_lang = ""
  
  for _, line in ipairs(text) do
    -- Code blocks
    if line:match("^```") then
      in_code_block = not in_code_block
      if in_code_block then
        code_lang = line:match("^```(%w*)")
        table.insert(formatted, "")
        table.insert(formatted, "┌─── " .. (code_lang ~= "" and code_lang or "code") .. " ───")
      else
        table.insert(formatted, "└────────")
        table.insert(formatted, "")
      end
    elseif in_code_block then
      table.insert(formatted, "│ " .. line)
    -- Headers
    elseif line:match("^###### (.+)") then
      local title = line:match("^###### (.+)")
      table.insert(formatted, "")
      table.insert(formatted, "▸ " .. title)
    elseif line:match("^##### (.+)") then
      local title = line:match("^##### (.+)")
      table.insert(formatted, "")
      table.insert(formatted, "▹ " .. title)
    elseif line:match("^#### (.+)") then
      local title = line:match("^#### (.+)")
      table.insert(formatted, "")
      table.insert(formatted, "● " .. title:upper())
      table.insert(formatted, "  " .. string.rep("─", #title))
    elseif line:match("^### (.+)") then
      local title = line:match("^### (.+)")
      table.insert(formatted, "")
      table.insert(formatted, "━━ " .. title:upper() .. " ━━")
    elseif line:match("^## (.+)") then
      local title = line:match("^## (.+)")
      table.insert(formatted, "")
      table.insert(formatted, "╔═══ " .. title:upper() .. " ═══╗")
      table.insert(formatted, "")
    elseif line:match("^# (.+)") then
      local title = line:match("^# (.+)")
      table.insert(formatted, "")
      table.insert(formatted, "╔" .. string.rep("═", #title + 4) .. "╗")
      table.insert(formatted, "║ " .. title:upper() .. " ║")
      table.insert(formatted, "╚" .. string.rep("═", #title + 4) .. "╝")
      table.insert(formatted, "")
    -- Lists
    elseif line:match("^%s*%- (.+)") or line:match("^%s*%* (.+)") then
      local content = line:match("^%s*[%-%*] (.+)")
      local indent = #line - #line:match("^%s*(.-)$")
      table.insert(formatted, string.rep("  ", math.floor(indent / 2)) .. "• " .. content)
    elseif line:match("^%s*%d+%. (.+)") then
      local num, content = line:match("^%s*(%d+)%. (.+)")
      local indent = #line - #line:match("^%s*(.-)$")
      table.insert(formatted, string.rep("  ", math.floor(indent / 2)) .. num .. ". " .. content)
    -- Bold and italic (simple version)
    else
      local formatted_line = line
      -- **bold** -> bold text (just remove markers for now)
      formatted_line = formatted_line:gsub("%*%*(.-)%*%*", "『%1』")
      -- *italic* -> italic text
      formatted_line = formatted_line:gsub("%*(.-)%*", "⟨%1⟩")
      -- `code` -> inline code
      formatted_line = formatted_line:gsub("`([^`]+)`", "⟪%1⟫")
      
      table.insert(formatted, formatted_line)
    end
  end
  
  return formatted
end

------------------------------------------------------------
-- Text wrapping (chat-like)
------------------------------------------------------------
local function wrap_text(lines, width)
  local wrapped = {}
  for _, line in ipairs(lines) do
    -- Preserve formatted lines (boxes, separators, etc.)
    if line:match("^[│┌└╔╚═━▸▹●]") or line:match("^%s*[│┌└]") then
      table.insert(wrapped, line)
    elseif line == "" then
      table.insert(wrapped, "")
    else
      local current = ""
      for word in line:gmatch("%S+") do
        if #current + #word + 1 > width then
          table.insert(wrapped, current)
          current = word
        else
          current = current == "" and word or (current .. " " .. word)
        end
      end
      if current ~= "" then
        table.insert(wrapped, current)
      end
    end
  end
  return wrapped
end

------------------------------------------------------------
-- Telescope inline AI chat
------------------------------------------------------------
function M.telescope_inline()
  local picker
  picker = pickers.new({}, {
    prompt_title = "💬 Local AI Chat",
    finder = finders.new_table({
      results = {
        "╭─────────────────────────────╮",
        "│ Type your prompt above ↑    │",
        "│ Press <Enter> to send       │",
        "╰─────────────────────────────╯",
      },
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local prompt = action_state.get_current_line()
        if not prompt or prompt == "" then
          return
        end
        
        -- Loading state
        picker:refresh(
          finders.new_table({
            results = { 
              "╭────────────╮",
              "│ 💭 Thinking... │",
              "╰────────────╯"
            },
          }),
          { reset_prompt = false }
        )
        
        query_local_model(prompt, function(lines)
          vim.schedule(function()
            local width = math.floor(vim.o.columns * 0.6)
            
            -- Combine all response lines into single text
            local full_text = table.concat(lines, "\n")
            local text_lines = {}
            for line in full_text:gmatch("[^\r\n]+") do
              table.insert(text_lines, line)
            end
            
            -- Format markdown
            local formatted = format_markdown(text_lines)
            
            -- Wrap text
            local wrapped = wrap_text(formatted, width)
            
            picker:refresh(
              finders.new_table({ results = wrapped }),
              { reset_prompt = true }
            )
            vim.cmd("stopinsert")
          end)
        end)
      end)
      return true
    end,
  })
  picker:find()
end

return M

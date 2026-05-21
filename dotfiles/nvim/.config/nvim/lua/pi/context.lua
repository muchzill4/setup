local M = {}

local function relpath(path)
  if path == "" then
    return "[No file]"
  end
  local cwd = vim.fn.getcwd()
  local rel = vim.fn.fnamemodify(path, ":.")
  if vim.startswith(path, cwd) then
    return rel
  end
  return path
end

local function current_buffer_info()
  local path = vim.api.nvim_buf_get_name(0)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  return {
    cwd = vim.fn.getcwd(),
    path = path,
    relpath = relpath(path),
    cursor_line = line,
    filetype = vim.bo.filetype,
    modified = vim.bo.modified,
  }
end

local function xml_escape_attr(value)
  return tostring(value):gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

local function editor_state_open(info)
  return string.format(
    '<editor_state cwd="%s" current_file="%s" cursor_line="%d" filetype="%s" modified="%s">',
    xml_escape_attr(info.cwd),
    xml_escape_attr(info.relpath),
    info.cursor_line,
    xml_escape_attr(info.filetype ~= "" and info.filetype or "unknown"),
    tostring(info.modified)
  )
end

function M.current_file()
  return table.concat({ editor_state_open(current_buffer_info()), "</editor_state>" }, "\n") .. "\n"
end

local function visual_positions()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    return mode, vim.fn.getpos "v", vim.fn.getpos "."
  end

  return vim.fn.visualmode(), vim.fn.getpos "'<", vim.fn.getpos "'>"
end

local function selection_info()
  local mode, start_pos, end_pos = visual_positions()
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    return { text = "" }
  end

  if mode ~= "V" then
    if #lines == 1 then
      lines[1] = string.sub(lines[1], start_col, end_col)
    else
      lines[1] = string.sub(lines[1], start_col)
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
  end

  return {
    text = table.concat(lines, "\n"),
    start_line = start_line,
    end_line = end_line,
    mode = mode,
  }
end

function M.selection_context()
  local selection = selection_info()
  if selection.text == "" then
    return ""
  end

  local buffer = current_buffer_info()
  local language = buffer.filetype ~= "" and buffer.filetype or "text"
  local path = xml_escape_attr(buffer.relpath)
  local escaped_language = xml_escape_attr(language)
  local selection_block = string.format(
    '<selection path="%s" start_line="%d" end_line="%d" filetype="%s">\n```%s\n%s\n```\n</selection>',
    path,
    selection.start_line,
    selection.end_line,
    escaped_language,
    language,
    selection.text
  )
  return table.concat({ editor_state_open(buffer), selection_block, "</editor_state>" }, "\n")
    .. "\n"
end

function M.with_prompt(prompt, extra)
  local parts = {}
  if extra and extra ~= "" then
    table.insert(parts, extra)
  else
    table.insert(parts, M.current_file())
  end
  table.insert(parts, "")
  table.insert(parts, prompt)
  return table.concat(parts, "\n")
end

return M

-- Pandoc Lua filter to add section numbering to headings.
-- Detects the APPENDIX_MARKER sentinel (inserted by preprocessing)
-- and switches top-level numbering from digits to letters (A, B, C...).

local counters = {0, 0, 0, 0, 0, 0}
local in_appendix = false
local appendix_counter = 0

local function num_to_letter(n)
  -- 1=A, 2=B, ..., 26=Z
  return string.char(64 + n)
end

function Header(el)
  -- Detect the APPENDIX_MARKER sentinel heading
  if el.level == 1 and pandoc.utils.stringify(el) == "APPENDIX_MARKER" then
    in_appendix = true
    appendix_counter = 0
    -- Reset all counters
    for i = 1, #counters do counters[i] = 0 end
    -- Remove this sentinel heading from output
    return {}
  end

  local level = el.level

  -- Increment counter at this level
  counters[level] = counters[level] + 1

  -- Reset all deeper counters
  for i = level + 1, #counters do
    counters[i] = 0
  end

  -- Build the number string
  local parts = {}
  for i = 1, level do
    if i == 1 and in_appendix then
      parts[#parts + 1] = num_to_letter(counters[1])
    else
      parts[#parts + 1] = tostring(counters[i])
    end
  end
  local number = table.concat(parts, ".")

  -- Prepend number to heading content
  table.insert(el.content, 1, pandoc.Space())
  table.insert(el.content, 1, pandoc.Str(number))

  return el
end

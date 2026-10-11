-- Replaces the first letter of the first paragraph after each heading with
-- an illustrated initial (images/initials/<letter>.png, plus a dark-theme
-- version in images/initials/dark/), when one exists.

local available = { b=true, d=true, e=true, i=true, m=true, z=true }

local function dropcap(para)
  local first = para.content[1]
  if not first or first.t ~= 'Str' then return end
  local letter = first.text:sub(1, 1)
  if not available[letter:lower()] then return end
  local l = letter:lower()
  local html = '<span class="dc"><img class="light" src="images/initials/' .. l ..
               '.png" alt="' .. letter .. '"><img class="dark" src="images/initials/dark/' ..
               l .. '.png" alt="" aria-hidden="true"></span>'
  para.content[1] = pandoc.Str(first.text:sub(2))
  para.content:insert(1, pandoc.RawInline('html', html))
end

function Pandoc(doc)
  local after_heading = false
  for _, block in ipairs(doc.blocks) do
    if block.t == 'Header' and block.level <= 3 then
      after_heading = true
    elseif block.t == 'Para' and after_heading then
      dropcap(block)
      after_heading = false
    end
  end
  return doc
end

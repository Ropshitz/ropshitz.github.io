-- Replaces the first letter of the first paragraph after each heading with
-- an illustrated initial. The light and dark themes have their own sets:
-- images/initials/<letter>.png and images/initials/dark/<letter>.png.
-- In a theme that has no drawing for that letter, the plain letter is shown.

local light = { b=true, d=true, e=true, i=true, z=true }
local dark  = { m=true, z=true }

local function dropcap(para)
  local first = para.content[1]
  if not first or first.t ~= 'Str' then return end
  local letter = first.text:sub(1, 1)
  local l = letter:lower()
  if not (light[l] or dark[l]) then return end

  local imgs = ''
  local classes = 'dc'
  if light[l] then
    classes = classes .. ' has-light'
    imgs = imgs .. '<img class="light" src="images/initials/' .. l ..
           '.png" alt="' .. letter .. '">'
  end
  if dark[l] then
    classes = classes .. ' has-dark'
    imgs = imgs .. '<img class="dark" src="images/initials/dark/' .. l ..
           '.png" alt="' .. letter .. '">'
  end
  local html = '<span class="' .. classes .. '">' .. imgs .. '</span>' ..
               '<span class="dc-letter">' .. letter .. '</span>'
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

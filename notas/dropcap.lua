-- Wraps the first letter of the first paragraph after each heading in
-- layered spans for the EB Garamond ornamented initials (see main.css).
-- Only letters that have an ornamented glyph in the font are wrapped.

local ornamented = { A=true, D=true, F=true, G=true, L=true, N=true,
                     O=true, Q=true, T=true, X=true }

local function dropcap(para)
  local first = para.content[1]
  if not first or first.t ~= 'Str' then return end
  local letter = first.text:sub(1, 1)
  if not ornamented[letter] then return end
  local html = '<span class="dc"><span class="bg" aria-hidden="true">' .. letter ..
               '</span><span class="fg">' .. letter .. '</span></span>'
  para.content:remove(1)
  para.content:insert(1, pandoc.Str(first.text:sub(2)))
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

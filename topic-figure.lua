-- topic-figure.lua
-- Pages with `figure:` (and optional `figure-caption:`) in YAML get a figure
-- block prepended to the body, so each topic page automatically shows its
-- figure without per-page markdown. Pages without `figure:` are untouched.

function Pandoc(doc)
  local figureMeta = doc.meta.figure
  if figureMeta == nil then return doc end

  local src = pandoc.utils.stringify(figureMeta)
  if src == nil or src == "" then return doc end

  local caption = ""
  if doc.meta["figure-caption"] then
    caption = pandoc.utils.stringify(doc.meta["figure-caption"])
  end

  -- Build the figure via markdown so we get a real <figure>/<figcaption> pair.
  local md = "![" .. caption .. "](" .. src .. ")"
  local parsed = pandoc.read(md, "markdown").blocks

  for i = #parsed, 1, -1 do
    table.insert(doc.blocks, 1, parsed[i])
  end

  return doc
end

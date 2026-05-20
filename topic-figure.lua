-- topic-figure.lua
-- Pages with `figure:` (and optional `figure-caption:`) in YAML get a figure
-- block inserted into the body, so each topic page automatically shows its
-- figure without per-page markdown. Pages without `figure:` are untouched.
--
-- Two optional YAML fields control placement and size:
--   figure-placement: top | bottom | left | right   (default: top)
--   figure-size:      number in [0, 1]              (default: 1.0)
--                     fraction of the content-area width the figure occupies.
--
-- For left/right placement, the figure floats and following text wraps around
-- it. A clearfix div is appended at the end of the body so floats don't bleed
-- into the page footer.

local VALID_PLACEMENTS = { top = true, bottom = true, left = true, right = true }

function Pandoc(doc)
  local figureMeta = doc.meta.figure
  if figureMeta == nil then return doc end

  local src = pandoc.utils.stringify(figureMeta)
  if src == nil or src == "" then return doc end

  local caption = ""
  if doc.meta["figure-caption"] then
    caption = pandoc.utils.stringify(doc.meta["figure-caption"])
  end

  local placement = "top"
  if doc.meta["figure-placement"] then
    local raw = pandoc.utils.stringify(doc.meta["figure-placement"])
    if VALID_PLACEMENTS[raw] then
      placement = raw
    end
  end

  local size = 1.0
  if doc.meta["figure-size"] then
    local raw = tonumber(pandoc.utils.stringify(doc.meta["figure-size"]))
    if raw then
      size = math.max(0, math.min(1, raw))
    end
  end

  -- Build the figure via markdown so we get a real <figure>/<figcaption> pair.
  local md = "![" .. caption .. "](" .. src .. ")"
  local parsed = pandoc.read(md, "markdown").blocks

  local widthPct = math.floor(size * 100 + 0.5)
  local attrs = pandoc.Attr(
    "",
    { "topic-figure", "topic-figure-" .. placement },
    { { "style", "width: " .. widthPct .. "%;" } }
  )
  local wrapped = pandoc.Div(parsed, attrs)

  if placement == "bottom" then
    table.insert(doc.blocks, wrapped)
  else
    table.insert(doc.blocks, 1, wrapped)
  end

  if placement == "left" or placement == "right" then
    local clearfix = pandoc.Div(
      {},
      pandoc.Attr("", { "topic-figure-clearfix" }, {})
    )
    table.insert(doc.blocks, clearfix)
  end

  return doc
end

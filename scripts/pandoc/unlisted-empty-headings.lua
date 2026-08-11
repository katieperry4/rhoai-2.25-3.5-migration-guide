-- The source document (a Google Docs export) contains a number of headings
-- with no visible text. They still carry ids that other links point at, so we
-- keep them in the document but mark them "unlisted" to exclude them from the
-- generated table of contents.
function Header(el)
  if #el.content == 0 then
    el.classes:insert("unlisted")
    return el
  end
end

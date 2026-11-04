# swift-pdf

Use this package when you want to generate PDF files from Swift, with content written as HTML views or Markdown. Start from `PDF.Document`. If you only need the HTML-to-PDF renderer, use swift-pdf-html-render. If you lay out pages with `PDF.View` and don't need to write files, use swift-pdf-render.

## Laws

- `PDF.Document` renders its content when it's created, so `pages` is already complete by the time you write the file.
- A document has an `outline` only if `generateOutline` is true and the content has at least one heading. Otherwise `outline` is nil.
- Headings count toward the outline however they're written: as HTML views, in Markdown, or nested inside a container such as a header.
- Text is encoded as WinAnsi, with symbols ZapfDingbats can encode set in that font. Any other character goes through a small fallback map, and anything still unmapped becomes `?`. Text in Cyrillic, Chinese and similar scripts therefore comes out as question marks, and no error is thrown.

import PDF
import Testing

enum `PDF.Debug.Crash Tests` {}

extension `PDF.Debug.Crash Tests` {
    @Suite struct DebugCrashInvestigation {

        @Test func `font copy destroy cycle`() {
            var font = PDF.Font.helvetica
            for _ in 0..<100 {
                font = font.bold
                font = font.italic
                font = font.regular
            }
            #expect(font.weight == .regular)
        }

        @Test func `nested inout font assignment`() {
            struct Inner { var font: PDF.Font = .helvetica }
            struct Middle { var style: Inner = .init() }
            struct Outer { var pdf: Middle = .init() }
            var context = Outer()
            context.pdf.style.font = context.pdf.style.font.bold
            #expect(context.pdf.style.font.weight == .bold)
        }

        #if HTML
            @Test func `markdown plain`() {
                let doc = PDF.Document(info: .init(title: "T", author: "T")) {
                    p { "Hello" }
                }
                #expect(doc.pages.count >= 1)
            }
        #endif

        #if Markdown
            @Test func `markdown heading`() {
                let doc = PDF.Document(info: .init(title: "T", author: "T")) {
                    Markdown { "# Heading" }
                }
                #expect(doc.pages.count >= 1)
            }
        #endif
    }
}

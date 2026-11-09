import Byte
import PDF
import Test_Snapshot_Primitives

extension Test.Snapshot.Strategy where Value == PDF.Document, Format == [UInt8] {
    static var pdf: Self {
        Test.Snapshot.Strategy<[UInt8], [UInt8]>(pathExtension: "pdf", diffing: .data)
            .pullback { (doc: PDF.Document) -> [UInt8] in
                do throws(PDF.Writer.Error) {
                    return try [Byte](doc).map(\.bitPattern)
                } catch {
                    fatalError("PDF document could not be written: \(error)")
                }
            }
    }
}

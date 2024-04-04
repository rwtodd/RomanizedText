import XCTest
import RomanizedText

final class RomanizedGreekTests: XCTestCase {
    
    func testBasics() throws {
        XCTAssertEqual(unromanizeGreek("A"), "\u{3b1}")
        XCTAssertEqual(unromanizeGreek("A*A"), "\u{03b1}\u{0391}")
        XCTAssertEqual(unromanizeGreek("B*B"), "\u{03b2}\u{0392}")
        XCTAssertEqual(unromanizeGreek("G*G"), "\u{03b3}\u{0393}")
        XCTAssertEqual(unromanizeGreek("ABG"), "αβγ")
    }
    
    func testAutoFinals() throws {
        XCTAssertEqual(unromanizeGreek("BAS SAS"), "βας σας")
        XCTAssertEqual(unromanizeGreek("BAS *S*A*S"), "βας ΣΑΣ")
    }

    func testAccents() throws {
        XCTAssertEqual(unromanizeGreek("*)B?A"), "\u{0392}\u{0313}\u{0323}\u{03b1}")
    }
}

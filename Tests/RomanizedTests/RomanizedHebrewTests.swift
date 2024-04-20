import XCTest
import RomanizedText

final class RomanizedHebrewTests: XCTestCase {
    
    func testBasics() throws {
        XCTAssertEqual(unromanizeHebrew("A"), "\u{5d0}")
        XCTAssertEqual(unromanizeHebrew("B"), "\u{5d1}")
        XCTAssertEqual(unromanizeHebrew("G"), "\u{5d2}")
        XCTAssertEqual(unromanizeHebrew("ABG"), "\u{5d0}\u{5d1}\u{5d2}")
        XCTAssertEqual(unromanizeHebrew("Shr"), "\u{05e9}\u{05c1}")
    }
    
    func testAutoFinals() throws {
        XCTAssertEqual(unromanizeHebrew("AN BNM"), "אן בנם")
        XCTAssertEqual(unromanizeHebrew("ANf BNiMf"), "אן בנם")
        // XCTAssertEqual(unromanizeHebrew("Th*1Pi;A3R3Th"), unromanizeHebrew("Th*1P;A3R3Th")) // the Peh should not be finalized
    }

    func testNiqqod() throws {
        XCTAssertEqual(unromanizeHebrew("B3AM"), "\u{5d1}\u{5b6}\u{5d0}\u{5dd}")
    }
}

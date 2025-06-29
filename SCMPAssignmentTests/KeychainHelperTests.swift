import XCTest
@testable import SCMPAssignment

final class KeychainHelperTests: XCTestCase {
    func testSaveAndRead() {
        let key = "testKey"
        let value = "testValue"
        KeychainHelper.shared.save(value, forKey: key)
        let readValue = KeychainHelper.shared.read(forKey: key)
        XCTAssertEqual(readValue, value)
        KeychainHelper.shared.delete(forKey: key)
    }

    func testDelete() {
        let key = "testKey"
        KeychainHelper.shared.save("value", forKey: key)
        KeychainHelper.shared.delete(forKey: key)
        let readValue = KeychainHelper.shared.read(forKey: key)
        XCTAssertNil(readValue)
    }
} 
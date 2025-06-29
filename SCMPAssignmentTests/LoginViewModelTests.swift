import XCTest
@testable import SCMPAssignment

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }

    func testEmailValidation() {
        viewModel.email = "invalid"
        XCTAssertEqual(viewModel.emailError, "Please enter a valid email address.")

        viewModel.email = "test@example.com"
        XCTAssertNil(viewModel.emailError)
    }

    func testPasswordValidation() {
        viewModel.password = "123"
        XCTAssertEqual(viewModel.passwordError, "Password must be 6-10 letters or numbers.")

        viewModel.password = "abc123"
        XCTAssertNil(viewModel.passwordError)
    }

    func testCanSignIn() {
        viewModel.email = "test@example.com"
        viewModel.password = "abc123"
        XCTAssertTrue(viewModel.canSignIn)

        viewModel.email = "bad"
        XCTAssertFalse(viewModel.canSignIn)
    }

    func testLoginFailure() {
        let expectation = self.expectation(description: "Login fails")
        viewModel.email = "fail@example.com"
        viewModel.password = "abc123"
        viewModel.login { success in
            XCTAssertFalse(success)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
} 

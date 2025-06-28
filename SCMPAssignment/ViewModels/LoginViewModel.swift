import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet { validateEmail() }
    }
    @Published var password: String = "" {
        didSet { validatePassword() }
    }
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    
    // MARK: - Validation
    private func validateEmail() {
        if email.isEmpty || isValidEmail(email) {
            emailError = nil
        } else {
            emailError = "Please enter a valid email address."
        }
    }
    
    private func validatePassword() {
        if password.isEmpty || isValidPassword(password) {
            passwordError = nil
        } else {
            passwordError = "Password must be 6-10 letters or numbers."
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^[A-Za-z0-9]{6,10}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    // MARK: - Login
    func login(completion: @escaping (Bool) -> Void) {
        guard emailError == nil, passwordError == nil, !email.isEmpty, !password.isEmpty else {
            completion(false)
            return
        }
        isLoading = true
        errorMessage = nil
        APIManager.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - UI State
    var canSignIn: Bool {
        !isLoading && emailError == nil && passwordError == nil && !email.isEmpty && !password.isEmpty
    }
} 
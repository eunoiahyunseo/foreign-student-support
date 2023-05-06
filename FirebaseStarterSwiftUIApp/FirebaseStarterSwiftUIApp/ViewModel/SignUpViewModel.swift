//
//  SignUpViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/9/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    @Published var isValid: Bool = false

    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    // AUthAPI
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
        
        $email
            .combineLatest($password, $confirmPassword)
            .map {
                !($0.isEmpty || $1.isEmpty || $2.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    func signUp() {
        guard passwordMatch() == true else {
            self.statusViewModel = StatusViewModel.passwordMatchErrorStatus
            initField(email: false, password: true, confirmPassword: true)
            return
        }
        
        authAPI.signUp(email: email, password: password)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension SignUpViewModel {
    
    func initField(email: Bool, password: Bool, confirmPassword: Bool) {
        if email == true {
            self.email = ""
        }
        if password == true {
            self.password = ""
        }
        
        if confirmPassword == true {
            self.confirmPassword = ""
        }
    }
    
    private func passwordMatch() -> Bool{
        guard password == confirmPassword else {
            return false
        }
        return true
    }
    
    private func resultMapper(with user: User?) -> StatusViewModel {
        if user != nil {
            state.currentUser = user
            return StatusViewModel.signUpSuccessStatus
        } else {
            return StatusViewModel.errorStatus
        }
    }
}

//
//  SignInViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import Firebase
import GoogleSignIn

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var isValid: Bool = false
    
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
        
        $email
            .combineLatest($password)
            .map {
                !($0.isEmpty || $1.isEmpty)
            }
            .assign(to: &$isValid)
    }
}

extension SignInViewModel {
    func initField(email: Bool, password: Bool) {
        if email == true {
            self.email = ""
        }
        if password == true {
            self.password = ""
        }
    }
    
    private func resultMapper(with user: User?) -> StatusViewModel {
        // User가 nil이 아니라면 state.currentUser를 로그인에 성공한 user로 설정한다.
        if user != nil {
            state.currentUser = user
            return StatusViewModel.logInSuccessStatus
        } else {
            return StatusViewModel.errorStatus
        }
    }
    
    
    func login() {
        authAPI.login(email: email, password: password)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func googleLogin() async -> Void {
        let user = await authAPI.loginWithGoogle()
        DispatchQueue.main.async {
            if user != nil {
                self.statusViewModel = StatusViewModel.logInSuccessStatus
                self.state.currentUser = user
            }
        }
    }
}

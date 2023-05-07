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

// MARK: - Private helper function
extension SignInViewModel {
    // 옵셔널 바인딩
    private func resultMapper(with user: User?) -> StatusViewModel {
        // User가 nil이 아니라면 state.currentUser를 로그인에 성공한 user로 설정한다.
        if user != nil {
            state.currentUser = user
            return StatusViewModel.logInSuccessStatus
        } else {
            return StatusViewModel.errorStatus
        }
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
    
    
    func login() {
        authAPI.login(email: email, password: password)
            .receive(on: RunLoop.main) // 메인쓰레드의 RunLoop
            .map(resultMapper) // upstream publisher의 모든 요소를 변환함
            .replaceError(with: StatusViewModel.errorStatus) // 에러를 replace한다.
            .assign(to: \.statusViewModel, on: self) // publisher로부터 받은 값을 Property에 할당
            .store(in: &cancellableBag)
    }
    
    // MARK: - Google-Sign-In
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

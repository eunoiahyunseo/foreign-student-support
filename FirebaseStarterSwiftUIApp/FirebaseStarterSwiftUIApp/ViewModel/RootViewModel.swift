//
//  RootViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/19.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

class RootViewModel: ObservableObject {
    @Published var signUpViewModel: SignUpViewModel
    @Published var signInViewModel: SignInViewModel
    @Published var homeViewModel: HomeViewModel
    @Published var userConfigViewModel: UserConfigViewModel
    
    // AppState를 root에서 주입해주게끔 바꾼다.
    @Published var state: AppState
    
    // Service Controller
    let authAPI: AuthAPI
    let boardAPI: BoardAPI
    let userAPI: UserAPI
    
    init() {
        let initialState = AppState()
        let authAPI = AuthService()
        let boardAPI = BoardService()
        let userAPI = UserService()

        self.signUpViewModel = SignUpViewModel(authAPI: authAPI, state: initialState)
        self.signInViewModel = SignInViewModel(authAPI: authAPI, state: initialState)
        self.homeViewModel = HomeViewModel(boardAPI: boardAPI, state: initialState)
        self.userConfigViewModel = UserConfigViewModel(
            boardAPI: boardAPI, userAPI: userAPI, state: initialState)
        
        self.state = initialState
        self.authAPI = authAPI
        self.boardAPI = boardAPI
        self.userAPI = userAPI
    }
}


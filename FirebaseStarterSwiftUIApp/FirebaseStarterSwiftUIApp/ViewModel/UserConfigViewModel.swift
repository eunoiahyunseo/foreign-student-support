//
//  UserConfigViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/19.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

class UserConfigViewModel: ObservableObject {
    @Published var country = ""
    @Published var region = ""
    @Published var language = "영어"
    @Published var age = ""
    @Published var nickname = ""
    @Published var school = "경북대학교"
    
    @Published var isValidFirstStep: Bool = false
    @Published var isValidSecondStep: Bool = false
    
    @Published var isSettedOnce: Bool = false
    
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState

    
    public var boardAPI: BoardAPI
    
    init(boardAPI: BoardAPI, state: AppState) {
        self.boardAPI = boardAPI
        self.state = state
        
        $country
            .combineLatest($region, $language)
            .map {
                !($0.isEmpty || $1.isEmpty || $2.isEmpty)
            }
            .assign(to: &$isValidFirstStep)
        
        $age
            .combineLatest($nickname)
            .map {
                !($0.isEmpty || $1.isEmpty)
            }
            .assign(to: &$isValidSecondStep)
    }
    
    // 이제 유저 정보를 실제 유저 데이터에 등록하면 된다.
    func createConfiguredUserInfo(user: User) {
        boardAPI.createUser(user: user) { error in
            if let error = error {
                self.statusViewModel = .userConfigurationFailureStatus
            } else {
                self.statusViewModel = .userConfigurationSuccessStatus
            }
        }
    }
}



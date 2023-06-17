//
//  AuthService.swift
//
//  Created by Hyunseo Lee
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

    public var userAPI: UserAPI
    public var boardAPI: BoardAPI
    
    
    
    init(boardAPI: BoardAPI, userAPI: UserAPI, state: AppState) {
        self.userAPI = userAPI
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
    
    func initField() {
        self.country = ""
        self.region = ""
        self.language = "영어"
        self.age = ""
        self.nickname = ""
        self.school = "경북대학교"
    }
    
    // 이제 유저 정보를 실제 유저 데이터에 등록하면 된다.
    func createConfiguredUserInfo(user: User) {
        userAPI.createUser(user: user) { error in
            if let error = error {
                print("Error creating userInfo: \(error)")
                self.statusViewModel = .userConfigurationFailureStatus
            } else {
                // 성공했다면, currentUser를 user로 바꾸어 준다.
                self.state.currentUser = user
                self.statusViewModel = .userConfigurationSuccessStatus
            }
        }
    }
    
    func updateUserInfo(user: User) {
        userAPI.updateUser(uid: user.id!, user: user) { error in
            if let error = error {
                print("Error updating user: \(error)")
                self.statusViewModel = .userConfigurationFailureStatus
            } else {
                print("Successfully updated user")
                self.state.currentUser = user
                self.statusViewModel = .userConfigurationSuccessStatus
            }
        }
    }
}



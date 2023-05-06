//
//  StatusViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation

class StatusViewModel: Identifiable, ObservableObject {
    
    var title: String
    var message: String
    
    init(title: String = "", message: String = "") {
        self.title = title
        self.message = message
    }
    
    static var signUpSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "회원가입이 정상적으로 이루어졌습니다.")
    }
    
    static var logInSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "로그인이 정상적으로 이루어졌습니다.")
    }
    
    static var errorStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "이메일, 비밀번호를 확인 후 재시도 부탁드립니다.")
    }
    
    static var passwordMatchErrorStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "비밀번호가 같은지 다시한번 확인해 주세요.")
    }
}

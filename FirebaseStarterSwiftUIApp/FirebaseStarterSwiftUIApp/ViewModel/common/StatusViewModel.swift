//
//  AuthService.swift
//
//  Created by Hyunseo Lee
//
import Foundation

class StatusViewModel: Identifiable, ObservableObject, Equatable {
    static func == (lhs: StatusViewModel, rhs: StatusViewModel) -> Bool {
        lhs.title == rhs.title && lhs.message == rhs.message && lhs.id == rhs.id
    }
    
    var id: UUID = UUID()
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
    
    static var userConfigurationSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "유저 정보가 성공적으로 등록되었습니다.")
    }
    
    static var userConfigurationFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "유저 정보에 문제가 발생하였습니다.")
    }
    
    static var postCreationSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "게시글이 성공적으로 등록되었습니다.")
    }
    
    static var postCreationFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "게시글 등록에 실패하였습니다. 정보를 확인해주세요.")
    }
    
    static var commentCreationSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "댓글이 성공적으로 등록되었습니다.")
    }
    
    static var commentCreationFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "댓글의 등록에 실패하였습니다. 정보를 확인해주세요.")
    }
    
    static var likeSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "이 글을 좋아합니다.")
    }
    
    static var likeFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "좋아요에 실패하였습니다.")
    }
    
    static var alreadylikedFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "이미 좋아요를 누른 글입니다.")
    }
    
    static var pinAddSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "게시판 즐겨찾기를 성공했습니다.")
    }
    
    static var pinDeletedSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "게시판 즐겨찾기를 성공적으로 해제했습니다.")
    }
    
    
    static var pinnedFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "게시판 즐겨찾기에 실패하였습니다.")
    }
    
    static var commentDeletedSuccessStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: "댓글 삭제에 성공하였습니다.")
    }
    
    static var commentDeletedFailureStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: "댓글 삭제에 실패하였습니다.")
    }
}

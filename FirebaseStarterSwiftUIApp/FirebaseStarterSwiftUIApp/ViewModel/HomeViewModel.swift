//
//  HomeViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/11.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var state: AppState
    
    public var boardAPI: BoardAPI
    
    
    init(boardAPI: BoardAPI, state: AppState) {
        self.boardAPI = boardAPI
        self.state = state
    }
    
    func addPost(title: String, content: String) -> String {
        return (boardAPI.savePost(post: Post(postedBy: (state.user?.id)!, title: title, content: content)))!
    }
}

extension HomeViewModel {
    
}

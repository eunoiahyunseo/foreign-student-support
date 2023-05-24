//
//  BoardConfigViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/24.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore


class BoardConfigViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    
    @Published var state: AppState
    @Published var statusViewModel: StatusViewModel?
    @Published var isValid: Bool = false


    public var userAPI: UserAPI
    public var boardAPI: BoardAPI
    
    @Published var posts: [Post]?
    @Published var isLoading = false
    
    init(boardAPI: BoardAPI, userAPI: UserAPI, state: AppState) {
        self.userAPI = userAPI
        self.boardAPI = boardAPI
        self.state = state
        
        $title
            .combineLatest($content)
            .map {
                !($0.isEmpty || $1.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    func initField() {
        self.title = ""
        self.content = ""
    }
    
    func createPost() {
        let post: Post = Post(
            postedBy: (self.state.currentUser?.id)!,
            postedUser: (self.state.currentUser?.nickname)!,
            title: self.title,
            content: self.content,
            comments: [],
            timestamp: Date(),
            likes: []
        )
        
        boardAPI.createPost(post: post) { error in
            if let error = error {
                print("Error creating post: \(error)")
                self.statusViewModel = .postCreationFailureStatus
            } else {
                // 성공했다면
                self.statusViewModel = .postCreationSuccessStatus
            }
        }
    }
    
    func fetchAllPosts() {
        isLoading = true
        boardAPI.getAllPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    print("posts: \(posts)")
                    self?.posts = posts
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
                
                self?.isLoading = false
            }
        }
    }
}

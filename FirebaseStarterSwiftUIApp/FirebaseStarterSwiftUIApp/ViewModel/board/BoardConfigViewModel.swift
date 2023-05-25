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
    
    // 댓글을 달기 위해 CurrentBoard의 ID가 필요하다.
    @Published var selectedPost: Post?
    @Published var comment = ""
    
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
    
    func initComment() {
        self.comment = ""
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
    
    func addCommentToPost() {
        let comment: Comment = Comment(
            commentedBy: (self.state.currentUser?.id)!,
            commentedUser: (self.state.currentUser?.nickname)!,
            content: self.comment,
            timestamp: Date()
        )
        boardAPI.addCommentToPost(postId: (selectedPost?.id)!, comment: comment) { error in
            if let error = error {
                print("Error creating comment to post: \(error)")
                self.statusViewModel = .commentCreationFailureStatus
            } else {
                self.statusViewModel = .commentCreationSuccessStatus
            }
        }
        
    }
    
    func fetchAllCommentsRelatedWithCurrentPost() {
        isLoading = true
        boardAPI.getPostWithComments(postId: (selectedPost?.id)!) { [weak self] result in
            DispatchQueue.main.async {
                sleep(1)
                switch result {
                case .success(var post):
                    
                    if let comments = post.comments {
                        post.comments = comments.sorted(by: { $0.timestamp < $1.timestamp })
                    }
                    self?.selectedPost = post
                case .failure(let error):
                    print("Error fetching post: \(error)")
                }
                self?.isLoading = false
            }
        }
    }
    
}

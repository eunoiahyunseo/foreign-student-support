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
    @Published var selectedPost: PostDTO?
    // 이건 선택된 Board정보
    @Published var selectedBoard: Board?
    
    @Published var comment = ""
    
    @Published var state: AppState
    @Published var statusViewModel: StatusViewModel?
    @Published var isValid: Bool = false

    public var userAPI: UserAPI
    public var boardAPI: BoardAPI
    
    // booard에 속한 posts들의 목록
    @Published var posts: [PostDTO]?
    
    // 로딩?
    @Published var isLoading = false
    
    // board들의 목록
    @Published var boards: [Board]?
    
    @Published var topRatedPosts: [PostDTO]?
    
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
            title: self.title,
            content: self.content,
            board: (self.selectedBoard)!, // 그냥 boardId말고 board를 넘기는게 트래픽 관점에서 좋을듯,,?
            boardId: (self.selectedBoard?.id)!,
            timestamp: Date()
        )
        
        boardAPI.createPost(post: post) { error in
            if let error = error {
                self.statusViewModel = .postCreationFailureStatus
                print("error: \(error)")
            } else {
                print("success!")
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
    
    func fetchAllPostsInBoard() {
        isLoading = true
        boardAPI.getPostsInBoard(boardId: (selectedBoard?.id)!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    print("posts: \(posts)")
                    self.posts = posts
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
                self.isLoading = false
            }
        }
    }
    
    func addCommentToPost() {
        let comment: Comment = Comment(
            commentedBy: (self.state.currentUser?.id)!,
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
    
    func addLikeToPost() {
        if let currentUser = state.currentUser {
            let like: Like = Like(
                likedBy: currentUser.id!,
                timestamp: Date()
            )
            
            if let selectedPost = selectedPost {
                
                if let likes = selectedPost.likes, likes.contains(where: { $0.likedBy == currentUser.id }) {
                    print("The user already liked this post")
                    self.statusViewModel = .alreadylikedFailureStatus
                    return
                }
                
                boardAPI.addLikeToPost(postId: selectedPost.id!, like: like) { error in
                    if let error = error {
                        print("Error creating like to post: \(error)")
                        self.statusViewModel = .likeFailureStatus
                    } else {
                        self.statusViewModel = .likeSuccessStatus
                    }
                }
            }
        }
    }
    
    func fetchAllCommentsAndLikesRelatedWithCurrentPost() {
        isLoading = true
        boardAPI.getPostWithCommentsAndLikesDTO(postId: (selectedPost?.id)!) { [weak self] result in
            DispatchQueue.main.async {
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
    
    func getAllBoards() {
        isLoading = true
        boardAPI.getAllBoards { result in
            switch result {
            case .success(let boards):
                print("Fetched \(boards.count) boards.")
                self.boards = boards
            case .failure(let error):
                print("Error fetching boards: \(error)")
            }
            self.isLoading = false
        }
    }
    
    // 갱신되는 실시간 인기글을 조회해온다.
    func getTopPosts() {
        isLoading = true
        boardAPI.fetchTopPosts { result in
            switch result {
            case .success(let posts):
                self.topRatedPosts = posts
            case .failure(let error):
                print("error: \(error)")
            }
            self.isLoading = false
        }
    }
}

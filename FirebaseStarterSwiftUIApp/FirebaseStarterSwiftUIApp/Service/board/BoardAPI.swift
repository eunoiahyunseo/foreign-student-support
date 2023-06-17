//
//  BoardAPI.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/10.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol BoardAPI {
    var db: Firestore { get }
    
    func createPost(post: Post, completion: @escaping (Error?) -> Void)
    func addCommentToPost(postId: String, comment: Comment, completion: @escaping (Error?) -> Void)
    func addLikeToPost(postId: String, like: Like, completion: @escaping (Error?) -> Void)
    func getAllPosts(completion: @escaping (Result<[PostDTO], Error>) -> Void)
    func getPostWithCommentsAndLikesDTO(postId: String, completion: @escaping (Result<PostDTO, Error>) -> Void)
    func getAllBoards(completion: @escaping (Result<[Board], Error>) -> Void)
    func getPostsInBoard(boardId: String, completion: @escaping (Result<[PostDTO], Error>) -> Void)
    func fetchTopPosts(completion: @escaping (Result<[PostDTO], Error>) -> Void)
    func addPinToBoard(userId: String, boardId: String, completion: @escaping (Error?) -> Void)
    func removePinFromBoard(userId: String, boardId: String, completion: @escaping (Error?) -> Void)
    func getPinnedAndOtherBoards(userId: String, completion: @escaping ([BoardDTO]?, Error?) -> Void)
    func getMyPosts(pid: String?, completion: @escaping (Result<[PostDTO], Error>) -> Void)
    func deleteComments(postId: String, commentId: String, completion: @escaping (Error?) -> Void)
}

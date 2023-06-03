//
//  BoardService.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/10.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class BoardService: BoardAPI {
    let db: Firestore = RootAPI.inst.db

    func createPost(post: Post, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try db.collection(Post.collection_name).addDocument(from: post) { error in
                completion(error)
            }
            
        } catch let error {
            completion(error)
        }
    }

    func addCommentToPost(postId: String, comment: Comment, completion: @escaping (Error?) -> Void) {
        do {
            // postId로 해당 post를 가져온다.
            let postRef = db.collection(Post.collection_name).document(postId)
            
            // Add a new comment document to the post's comments sub-collection
            _ = try postRef.collection(Comment.collection_name).addDocument(from: comment) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    func addLikeToPost(postId: String, like: Like, completion: @escaping (Error?) -> Void) {
        do {
            let postRef = db.collection(Post.collection_name).document(postId)
            
            try postRef.collection(Like.collection_name).addDocument(from: like) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
        
    }
    
    
    
    /**
        DispatchGroup: 이건 여러개의 비동기 작업을 그룹화하고. 모든 작업이 완료되었음을 알 수 있게 도와주는 기능
            
        DispatchGroup().enter(): 를 통해 그룹에 작업을 추가
        DispatchGroup().leave(): 를 통해 작업이 끝났음을 알린다.
        DispatchGroup().notify(queue: .main): 는 그룹 내의 모든 작업이 완료되었을 때 호출되는 콜백함수이다.
     */
    func getAllPosts(completion: @escaping (Result<[PostDTO], Error>) -> Void) {
        db.collection(Post.collection_name).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let querySnapshot = querySnapshot {
                var posts: [PostDTO] = []
                // DispatchGroup은 모든 비동기 작업이 완료될때까지 기다린 후 완료 callback을 실행한다.
                let dispatchGroup = DispatchGroup()
                for document in querySnapshot.documents {
                    if let post = try? document.data(as: Post.self), let postId = post.id {
                        dispatchGroup.enter()
                        
                        self.getPostWithCommentsAndLikes(postId: postId) { result in
                            // 현재 비동기 작업이 어떻게 끝날지에 대한 정의
                            defer { dispatchGroup.leave() }
                            switch result {
                            case .success(let postDTO):
                                posts.append(postDTO)
                            case .failure(let error):
                                completion(.failure(error))
                                return
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(posts))
                }
            }
        }
    }
    
    func getPostsInBoard(boardId: String, completion: @escaping (Result<[PostDTO], Error>) -> Void) {
        db.collection(Post.collection_name)
          .whereField("boardId", isEqualTo: boardId)
          .getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let querySnapshot = querySnapshot {
                var posts: [PostDTO] = []
                let dispatchGroup = DispatchGroup()
                for document in querySnapshot.documents {
                    if let post = try? document.data(as: Post.self), let postId = post.id {
                        dispatchGroup.enter()
                        self.getPostWithCommentsAndLikes(postId: postId) { result in
                            defer { dispatchGroup.leave() }
                            switch result {
                            case .success(let postDTO):
                                posts.append(postDTO)
                            case .failure(let error):
                                completion(.failure(error))
                                return
                            }
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(posts))
                }
            }
        }
    }
    
    func getAllBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        db.collection(Board.collection_name).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let querySnapshot = querySnapshot {
                let boards: [Board] = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Board.self)
                }
                completion(.success(boards))
            }
        }
    }

    func getPostWithCommentsAndLikes(postId: String, completion: @escaping (Result<PostDTO, Error>) -> Void) {
        let postRef = db.collection(Post.collection_name).document(postId)
        postRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists,
                      let post = try? document.data(as: Post.self) {

                // Post to PostDTO conversion
                var postDTO = Post.convertPostToPostDTO(post: post)

                // DispatchGroup은 모든 비동기 작업이 완료될때까지 기다린 후 완료 callback을 실행한다.
                let dispatchGroup = DispatchGroup()

                dispatchGroup.enter()
                postRef.collection(Comment.collection_name).getDocuments { (querySnapshot, error) in
                    defer { dispatchGroup.leave() }
                    if let error = error {
                        completion(.failure(error))
                    } else if let querySnapshot = querySnapshot {
                        postDTO.comments = querySnapshot.documents.compactMap { try? $0.data(as: Comment.self) }
                    }
                }

                dispatchGroup.enter()
                postRef.collection(Like.collection_name).getDocuments { (querySnapshot, error) in
                    defer { dispatchGroup.leave() }
                    if let error = error {
                        completion(.failure(error))
                    } else if let querySnapshot = querySnapshot {
                        postDTO.likes = querySnapshot.documents.compactMap { try? $0.data(as: Like.self) }
                    }
                }

                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(postDTO))
                }
                
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])))
            }
        }
    }
    
}

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
import FirebaseFirestoreSwift
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
                        
                        self.getPostWithCommentsAndLikesDTO(postId: postId) { result in
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
                        self.getPostWithCommentsAndLikesDTO(postId: postId) { result in
                            defer { dispatchGroup.leave() }
                            switch result {
                            case .success(let postDTO):
                                print("sucess!!!!!: \(postDTO)")
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
    
    func getPostWithCommentsAndLikesDTO(postId: String, completion: @escaping (Result<PostDTO, Error>) -> Void) {
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
                self.db.collection(User.collection_name).document(post.postedBy).getDocument { (userSnapshot, error) in
                    defer { dispatchGroup.leave() }
                    postDTO.user =  try? userSnapshot?.data(as: User.self)
                }

                // 서브컬렉션들에 대해 순회를 돌아야 한다.
                let commentFetchGroup = DispatchGroup()
                dispatchGroup.enter() // move it here
                postRef.collection(Comment.collection_name).getDocuments { (querySnapshot, error) in

                    if let error = error {
                        completion(.failure(error))
                    } else if let querySnapshot = querySnapshot {
                        var commentDTOs: [CommentDTO] = []
                        for document in querySnapshot.documents {

                            // comment를 가져온다음에 이를 commentDTO로 변환하는게 최종 목표
                            guard let comment = try? document.data(as: Comment.self) else {
                                continue
                            }
                            var commentDTO = Comment.convertCommentToCommentDTO(comment: comment)
                            commentFetchGroup.enter()
                            // comment.commentedBy를 통해 user를 조회해온다.
                            self.db.collection(User.collection_name).document(comment.commentedBy).getDocument { (userDocument, error) in
                                defer { commentFetchGroup.leave() }
                                if let error = error {
                                    completion(.failure(error))
                                } else if let userDocument = userDocument,
                                          let user = try? userDocument.data(as: User.self) {
                                    commentDTO.user = user
                                    commentDTOs.append(commentDTO)
                                }
                            }
                        }
                        commentFetchGroup.notify(queue: .main) {
                            postDTO.comments = commentDTOs
                            dispatchGroup.leave() // move it here
                        }
                    } else {
                        dispatchGroup.leave() // if querySnapshot is nil, leave the group
                    }
                }

                let likeFetchGroup = DispatchGroup()
                dispatchGroup.enter() // move it here
                postRef.collection(Like.collection_name).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let querySnapshot = querySnapshot {
                        var likeDTOs: [LikeDTO] = []
                        for document in querySnapshot.documents {
                            guard let like = try? document.data(as: Like.self) else {
                                continue
                            }
                            var likeDTO = Like.convertLikeToLikeDTO(like: like)
                            likeFetchGroup.enter()
                            self.db.collection(User.collection_name).document(like.likedBy)
                                .getDocument { (userDocument, error) in
                                    defer { likeFetchGroup.leave() }
                                    if let error = error {
                                        completion(.failure(error))
                                    } else if let userDocument = userDocument,
                                              let user = try? userDocument.data(as: User.self) {
                                        likeDTO.user = user
                                        likeDTOs.append(likeDTO)
                                    }
                                }
                        }
                        likeFetchGroup.notify(queue: .main) {
                            postDTO.likes = likeDTOs
                            dispatchGroup.leave() // move it here
                        }
                    } else {
                        dispatchGroup.leave() // if querySnapshot is nil, leave the group
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

    func fetchTopPosts(completion: @escaping (Result<[PostDTO], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("topPosts").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let querySnapshot = querySnapshot {
                var boards: [PostDTO] = querySnapshot.documents.compactMap { document in
                    try? document.data(as: PostDTO.self)
                }
                boards = boards.sorted { $0.score > $1.score }

                completion(.success(boards))
            }
        }
    }
    
    
    // User의 pin 서브 컬렉션에 게시판 추가
    func addPinToBoard(userId: String, boardId: String, completion: @escaping (Error?) -> Void) {
        let boardRef = db.collection(Board.collection_name).document(boardId)
           boardRef.getDocument { (document, error) in
               if let document = document, document.exists {
                   do {
                       let board = try document.data(as: Board.self)
                       // Pin the fetched board to user
                       let pinRef = self.db.collection(User.collection_name).document(userId).collection("pins").document(boardId)
                       try pinRef.setData(from: board) { error in
                           completion(error)
                       }
                   } catch let error {
                       completion(error)
                   }
               } else {
                   completion(error)
               }
           }
    }
    
    
    // User의 pin 서브 컬렉션에서 게시판 제거
    func removePinFromBoard(userId: String, boardId: String, completion: @escaping (Error?) -> Void) {
        let pinRef = db.collection(User.collection_name).document(userId).collection("pins").document(boardId)
        pinRef.delete() { error in
            completion(error)
        }
    }
    
    func getPinnedAndOtherBoards(userId: String, completion: @escaping ([BoardDTO]?, Error?) -> Void) {
        // User DB에 있는, pins된 정보를 다 가져온다.
        let pinnedRef = db.collection(User.collection_name).document(userId).collection("pins")
        pinnedRef.getDocuments { (pinnedSnapshot, error) in
            guard let pinnedDocs = pinnedSnapshot?.documents else {
                completion(nil, error)
                return
            }
            
            // user의 pin 서브컬렉션에 있는 내용을 Board객체 형태로 가져오고 nil인거는 다 지워버린다.
            var pinnedBoards = pinnedDocs.compactMap {
                try? Board.convertBoardToBoardDTO(board: $0.data(as: Board.self), pin: true)}
            
            // Board배열에 있는, 모든 정보들을 그리고 가져온다.
            let boardsRef = self.db.collection(Board.collection_name)
            boardsRef.getDocuments { (boardsSnapshot, error) in
                guard let boardDocs = boardsSnapshot?.documents else {
                    completion(nil, error)
                    return
                }
                var allBoards = boardDocs.compactMap {
                    try? Board.convertBoardToBoardDTO(board: $0.data(as: Board.self), pin: false) }
                
                // 그리고 위에서 pin한 정보들을 지워버린다.
                allBoards.removeAll(where: { board in
                    pinnedBoards.contains(where: { $0.id == board.id })
                })
                
                // 나머지 핀 안된걸 최종적으로 추가한ㄷ
                pinnedBoards.append(contentsOf: allBoards)
                
                completion(pinnedBoards, nil)
            }
        }
    }
}

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
            let newPostRef = try db.collection(Post.collection_name).addDocument(from: post)
            newPostRef.collection(Comment.collection_name).document().setData([:]) { error in
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
    
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection(Post.collection_name).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let posts = querySnapshot.documents.compactMap { try? $0.data(as: Post.self) }
                completion(.success(posts))
            }
        }
    }
    
    func getPostWithComments(postId: String, completion: @escaping (Result<Post, Error>) -> Void) {
        let db = Firestore.firestore()
        
        // Fetch the post
        let postRef = db.collection(Post.collection_name).document(postId)
        postRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists,
                      var post = try? document.data(as: Post.self) {
                // Fetch the comments
                postRef.collection(Comment.collection_name).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let querySnapshot = querySnapshot {
                        let comments = querySnapshot.documents.compactMap { try? $0.data(as: Comment.self) }
                        post.comments = comments
                        completion(.success(post))
                    }
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])))
            }
        }
    }
}

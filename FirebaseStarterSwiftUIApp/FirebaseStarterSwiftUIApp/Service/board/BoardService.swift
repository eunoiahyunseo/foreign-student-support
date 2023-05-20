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
            
            // Initialize an empty comments sub-collection for the new post
            newPostRef.collection(Comment.collection_name).document().setData([:]) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }

    func addCommentToPost(postId: String, comment: Comment, completion: @escaping (Error?) -> Void) {
        do {
            let postRef = db.collection(Post.collection_name).document(postId)
            
            // Add a new comment document to the post's comments sub-collection
            _ = try postRef.collection(Comment.collection_name).addDocument(from: comment) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    func readPostWithComments(postId: String, completion: @escaping (Post?, [Comment]?, Error?) -> Void) {
        let postRef = db.collection(Post.collection_name).document(postId)
        // First retrieve the post
        postRef.getDocument { (postDocument, error) in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            // Then retreve its comments sub-collection
            postRef.collection(Comment.collection_name).getDocuments() {
                (querySnapshot, error) in
                if let error = error {
                    completion(nil, nil, error)
                    return
                }
                
                if let postDocument = postDocument, postDocument.exists {
                    let post = try? postDocument.data(as: Post.self)
                    
                    if let documents = querySnapshot?.documents {
                        let comments = documents.compactMap {
                            try? $0.data(as: Comment.self) }
                        completion(post, comments, nil)
                    }
                }
            }
        }
    }
}

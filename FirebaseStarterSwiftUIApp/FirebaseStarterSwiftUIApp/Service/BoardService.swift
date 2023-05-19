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

enum UserAPIError: Error {
    case documentNotFound
    case documentUpdateError
    case generalError(Error)
}

let userCollection = "users"

// 현재 접속해 있는
class BoardService: BoardAPI {
    // singleton firestore db instance
    var db = FireStoreAPI.inst.db
    
    func createUser(user: User, completion: @escaping (Error?) -> Void) {
        checkIfEmailExists(email: user.email!) { emailExists in
            if !emailExists {
                do {
                    try self.db.collection(userCollection).addDocument(from: user)
                    completion(nil)

                } catch let error {
                    completion(error)
                }
            } else {
                self.updateUser(email: user.email!, user: user, completion: completion)
            }
        }
    }
    
    
    func updateUser(email: String, user: User, completion: @escaping (Error?) -> Void) {
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { (querySnapshot, error) in
                // 조회하는데 에러가 발생한 경우
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(error)
                } else if let querySnapshot = querySnapshot, let document = querySnapshot.documents.first {
                    self.db.collection("users").document(document.documentID).updateData([
                        "name": user.nickname!,
                        "country": user.country!,
                        "region": user.region!,
                        "language": user.language!,
                        "age": user.age!,
                        "nickname": user.nickname!
                    ]) { error in
                        if let error = error {
                            // 업데이트 하다가 에러가 발생한 경우
                            print("Error updating document: \(error)")
                            completion(error)
                        } else {
                            // 성공적으로 조회하고 업데이트 된 경우
                            print("Document successfully updated")
                            completion(nil)
                        }
                    }
                } else {
                    // 이메일을 찾을 수 없는 경우
                    print("No document found with provided email")
                    completion(nil)
                }
            }
    }
        
    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(false)
                } else if let querySnapshot = querySnapshot {
                    if querySnapshot.documents.count > 0 {
                        // 이미 이메일이 있는 경우
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
    }
   
    
    
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

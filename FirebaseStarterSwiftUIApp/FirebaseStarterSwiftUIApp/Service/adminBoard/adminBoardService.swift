//
//  adminBoardService.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AdminBoardService : adminBoardAPI{
    let db: Firestore = RootAPI.inst.db
    
    func createPost(post: AdminBoard, completion: @escaping (Error?) -> Void){
        do {
            let _ = try db.collection(AdminBoard.collection_name).addDocument(from: post) { error in
                completion(error)
            }
            
        } catch let error {
            completion(error)
        }
    }

    func getAllPosts(completion: @escaping (Result<[AdminBoard], Error>) -> Void){
        db.collection(AdminBoard.collection_name).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let querySnapshot = querySnapshot {
                let boards: [AdminBoard] = querySnapshot.documents.compactMap { document in
                    try? document.data(as: AdminBoard.self)
                }
                completion(.success(boards))
            }
        }
    }
    
    func updatePost(id : String, post: AdminBoard, completion: @escaping (Error?) -> Void) {
        db.collection(AdminBoard.collection_name).document(id).updateData([
            "title" : post.title,
            "content" : post.content,
            "timestamp" : Date()
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(error)
            } else {
                print("Document successfully updated")
                completion(nil)
            }
        }
    }
    
    func deletePost(id: String, completion: @escaping (Error?) -> Void) {
        db.collection(AdminBoard.collection_name).document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(err)
            } else {
                print("Document successfully removed!")
                completion(nil)
            }
        }
    }
}

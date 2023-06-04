//
//  UserService.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/19.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

enum UserAPIError: Error {
    case documentNotFound
    case documentUpdateError
    case generalError(Error)
}

let userCollection = "users"

class UserService: UserAPI {
    let db: Firestore = RootAPI.inst.db

    func createUser(user: User, completion: @escaping (Error?) -> Void) {
        if let currentUserUID = Auth.auth().currentUser?.uid {
            db.collection(userCollection).document(currentUserUID).getDocument {
                (document, error) in
                if let error = error {
                    completion(error)
                } else if let document = document, document.exists {
                    self.updateUser(uid: currentUserUID, user: user, completion: completion)
                } else {
                    do {
                        try self.db.collection(userCollection).document(currentUserUID).setData(from: user)
                        completion(nil)
                    } catch let error {
                        completion(error)
                    }
                }
            }
        } else {
            print("No user is signed in.")
            completion(UserAPIError.documentNotFound)
        }
    }

    func updateUser(uid: String, user: User, completion: @escaping (Error?) -> Void) {
        self.db.collection("users").document(uid).updateData([
            "name": user.nickname!,
            "country": user.country!,
            "region": user.region!,
            "language": user.language!,
            "age": user.age!,
            "nickname": user.nickname!
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
    
    func getUser(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection(userCollection).document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists,
                      let user = try? document.data(as: User.self) {
                completion(.success(user))
            } else {
                completion(.failure(UserAPIError.documentNotFound))
            }
        }
    }
    
}

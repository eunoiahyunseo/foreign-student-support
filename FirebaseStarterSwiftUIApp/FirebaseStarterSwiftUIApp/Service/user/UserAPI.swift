//
//  UserAPI.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/19.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol UserAPI {
    var db: Firestore { get }

    func createUser(user: User, completion: @escaping (Error?) -> Void)
    func updateUser(uid: String, user: User, completion: @escaping (Error?) -> Void)
}

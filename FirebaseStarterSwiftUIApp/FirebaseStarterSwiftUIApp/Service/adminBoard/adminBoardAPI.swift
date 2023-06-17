//
//  adminBoardAPI.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol adminBoardAPI {
    var db: Firestore { get }
    
    func createPost(post: AdminBoard, completion: @escaping (Error?) -> Void)
    func getAllPosts(completion: @escaping (Result<[AdminBoard], Error>) -> Void)
    func updatePost(id : String, post : AdminBoard, completion: @escaping (Error?) -> Void)
    func deletePost(id : String, completion: @escaping (Error?) -> Void)
}

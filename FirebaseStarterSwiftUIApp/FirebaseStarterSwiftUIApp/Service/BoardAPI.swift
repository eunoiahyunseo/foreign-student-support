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

    func savePost(post: Post) -> String?
    func saveUser(user: User) -> Void
    func saveCommentByPostId(postId: String, comment: Comment) -> Void
}

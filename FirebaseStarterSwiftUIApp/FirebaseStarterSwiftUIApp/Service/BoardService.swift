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

// 현재 접속해 있는
class BoardService: BoardAPI {
    // singleton firestore db instance
    var db = FireStoreAPI.inst.db
    
    func saveUser(user: User) {
        db.collection(type(of: user).collection_name)
            .document(user.id!)
            .setData([
                "name": user.name ?? "annonymous",
                "email": user.email!,
            ])
    }
    
    /**
     사용자가 게시물을 하나 등록하는 API
     */
    func savePost(post: Post) -> String? {
        // Cloud Firestore에서 자동으로 ID를 생성하도록 하는 것이다.
        let postCollection = db.collection("posts")
        
        // post/(userid)/ -> (subcollection)comments/1
        do {
            let postRef = try postCollection.addDocument(from: post)
            return postRef.documentID
        }
        catch {
            print(error)
            return nil
        }
    }
    
    /**
     사용자가 게시물에 댓글을 다는 API
     */
    func saveCommentByPostId(postId: String, comment: Comment) {
        let postCollection = db.collection("posts").document(postId)
        let commentCollection = postCollection.collection("comments")
        
        do {
           try commentCollection.addDocument(from: comment)
        } catch {
            print(error)
        }
    }
}

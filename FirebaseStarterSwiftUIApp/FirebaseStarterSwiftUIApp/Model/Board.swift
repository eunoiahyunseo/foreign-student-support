//
//  Board.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/10.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore


struct Post: Codable, Identifiable {
    static var collection_name: String = "posts"

    @DocumentID var id: String? // 
    var postedBy: String // 글을 쓴 사람
    var title: String // 게시글의 제목
    var content: String // 게시글의 내용
    
    var comments: [Comment]? // 서브 컬렉션
}

struct Comment: Codable, Identifiable {
    static var collection_name: String = "comments"

    @DocumentID var id: String?
    var commentedBy: String
    var content: String
}

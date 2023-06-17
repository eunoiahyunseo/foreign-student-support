//
//  AdminBoard.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift


struct AdminBoard : Codable, Identifiable {
    static var collection_name: String = "adminBoard"
    @DocumentID var id : String?
    
    var postedBy: String // 이를 통해 User fetch
    var title: String
    var content: String
    var timestamp: Date
}

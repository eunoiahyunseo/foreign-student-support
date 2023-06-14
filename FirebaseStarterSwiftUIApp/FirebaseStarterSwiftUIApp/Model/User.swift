//
//  User.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/17/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift


struct User: Codable, Identifiable {
    static var collection_name: String = "users"
    @DocumentID var id : String?
    
    var email: String?
    
    var country: String?
    var region: String?
    var language: String?
    var age: String?
    var nickname: String?
    var school: String?
    var isInitialInfoSet: Bool = false // Added new field
    //var isAdmin: Bool = true
}

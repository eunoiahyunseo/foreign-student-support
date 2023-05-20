//
//  rootService.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/20.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class RootAPI {
    static let inst: RootAPI = RootAPI()
    
    let db : Firestore
    
    private init() {
        db = Firestore.firestore()
    }
}

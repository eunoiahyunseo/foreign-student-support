//
//  CollectionScheme.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/05/07.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

protocol CollectionScheme : Codable {
    static var collection_name : String { get }
    var id : String? {get} //@DocumentID
}

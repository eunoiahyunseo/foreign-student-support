//
//  HomeViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/11.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var state: AppState
    @Published var isInitialInfoSet: Bool = false
    
    public var boardAPI: BoardAPI
    
    
    init(boardAPI: BoardAPI, state: AppState) {
        self.boardAPI = boardAPI
        self.state = state
    }
    
    public func fetchUserInitialInfo() {
        guard let userID = state.currentUser?.id else { return }
            
        let docRef = Firestore.firestore().collection(User.collection_name).document(userID)
            
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.isInitialInfoSet = user.isInitialInfoSet
                    }
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
            } else {
                print("Document does not exist in database")
            }
        }
    }
}

extension HomeViewModel {
    
}

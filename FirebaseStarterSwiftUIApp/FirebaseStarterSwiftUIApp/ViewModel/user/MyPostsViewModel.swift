//
//  BoardConfigViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/24.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore


class MyPostsViewModel: ObservableObject {
    
    
    
    @Published var state: AppState

    
    public var userAPI: UserAPI
    public var allPostsService: AllPostsService
    // booard에 속한 posts들의 목록
    @Published var posts: [PostDTO]?
    
    // 로딩?
    @Published var isLoading = false
    
    
    init(userAPI: UserAPI, allPostsService: AllPostsService, state: AppState) {
        self.userAPI = userAPI
        self.state = state
        self.allPostsService = allPostsService
        
    }
    
    
    func fetchMyPosts(id: String?) {
        isLoading = true
        allPostsService.getMyPosts(Pid: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    print("posts: \(posts)")
                    
                    self?.posts = posts
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
                
                self?.isLoading = false
            }
        }
    }
    
}

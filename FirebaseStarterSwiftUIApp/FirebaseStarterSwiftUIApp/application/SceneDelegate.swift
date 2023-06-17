//
//  SceneDelegate.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/8/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let initialState = AppState()
        let authAPI = AuthService()
        let boardAPI = BoardService()
        let userAPI = UserService()
        
        // MARK: environmentObject에 rootViewModel로 Dependency Injection을 하려 했으나,
        // MARK: Nested @Observable 이슈로 하나하나 다 따로 주입해서 싱글톤을 유지하게 끔 해야함.
        let rootView = SplashView()
            .environmentObject(SignUpViewModel(authAPI: authAPI, state: initialState))
            .environmentObject(SignInViewModel(authAPI: authAPI, state: initialState))
            .environmentObject(UserConfigViewModel(
                boardAPI: boardAPI, userAPI: userAPI, state: initialState))
            .environmentObject(BoardConfigViewModel(
                boardAPI: boardAPI, userAPI: userAPI, state: initialState))
            .environmentObject(MyPostsViewModel(
                userAPI: userAPI, boardAPI: boardAPI, state: initialState))
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    private func configureAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
          .foregroundColor: UIColor(named: "peach")!
        ]
        UINavigationBar.appearance().titleTextAttributes = [
          .foregroundColor: UIColor(named: "peach")!
        ]
        UITableView.appearance().backgroundColor = .clear
        UISlider.appearance().thumbTintColor = UIColor(named: "peach")
      }
}


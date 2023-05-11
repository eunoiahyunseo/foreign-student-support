//
//  AuthService.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService: AuthAPI {
    func loginWithGoogle() async -> User? {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return nil
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no root view controller")
            return nil
        }

        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                return nil
            }

            let accessToken = user.accessToken

            // firebase로 부터 인증을 하기 위한 credential 정보를 받아온다.
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)


            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("firebaesUser: \(firebaseUser)")
            let resUser = User(id: firebaseUser.uid, email: firebaseUser.email!)
            return resUser
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    

    // 여기서 실질적으로 Firebase의 login api를 호출함
    func login(email: String, password: String) -> Future<User?, Never> {
        return Future<User?, Never> { promise in
            Auth.auth().signIn(withEmail: email, password: password) {(authResult, _) in
                // authResult.user.providerID, email이 있어야 한다. 
                guard let id = authResult?.user.providerID,
                    let email = authResult?.user.email else {
                        promise(.success(nil))
                        return
                }
                let user = User(id: id, email: email)
                promise(.success(user))
            }
        }
    }
    
    func signUp(email: String, password: String) -> Future<User?, Never> {
        return Future<User?, Never> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, _) in
                guard let id = authResult?.user.providerID,
                    let email = authResult?.user.email else {
                        promise(.success(nil))
                        return
                }
                let user = User(id: id, email: email)
                promise(.success(user))
            }
        }
    }
}

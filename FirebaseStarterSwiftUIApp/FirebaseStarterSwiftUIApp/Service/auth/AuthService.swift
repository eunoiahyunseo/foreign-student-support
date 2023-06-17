//
//  AuthService.swift
//
//  Created by Hyunseo Lee
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore


class AuthService: AuthAPI {
    let db: Firestore = RootAPI.inst.db

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
    func login(email: String, password: String) -> Future<User?, Error> {

        return Future<User?, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) {(authResult, _) in
                guard let id = authResult?.user.uid,
                    let email = authResult?.user.email else {
                        promise(.success(nil))
                        return
                }
                
                let docRef = self.db.collection(userCollection).document(id)

                docRef.getDocument { (document, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else if let document = document, document.exists {
                        do {
                            print("document ---> \(document)")
                            let user = try document.data(as: User.self)
                            print("user ---> \(user)")
                            promise(.success(user))
                        } catch let error {
                            promise(.failure(error))
                        }
                    } else {
                        promise(.success(User(id: id, email: email)))
                    }
                }
            }
        }
    }
    
    func signUp(email: String, password: String) -> Future<User?, Never> {
        return Future<User?, Never> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, _) in
                guard let id = authResult?.user.uid,
                    let email = authResult?.user.email else {
                        promise(.success(nil))
                        return
                }
                let user = User(id: id, email: email)
                print("user-->\(user)")
                promise(.success(user))
            }
        }
    }
    
    // 이미 있는 이메일인지 확인하는 API가 필요하다.
    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                print("Failed to check if email exists: \(error)")
                completion(false)
                return
            }
            
            if let signInMethods = signInMethods, !signInMethods.isEmpty {
                // Email exists
                completion(true)
            } else {
                // Email does not exist
                completion(false)
            }
        }
    }
}

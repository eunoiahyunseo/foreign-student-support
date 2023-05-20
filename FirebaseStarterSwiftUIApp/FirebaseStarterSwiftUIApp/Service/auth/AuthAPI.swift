//
//  AuthService.swift
//
//  Created by Hyunseo Lee
//
import Foundation
import Combine
import FirebaseAuth

/**
 Future는 Publisher프로토콜을 Conform하고 있다.
 Swift에서는 asynchronous프로그래밍을 위해 callback기반 completion handler를 사용했는데, (Rx을 쓰지 않는다면)
 이제 Future로 간단히 구현할 수 있다.
 */
protocol AuthAPI {
    func login(email: String, password: String) -> Future<User?, Error>
    func signUp(email: String, password: String) -> Future<User?, Never>
    func loginWithGoogle() async -> User?
}

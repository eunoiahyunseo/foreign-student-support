//
//  FireStoreAPI.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/05/07.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

//싱글톤으로 작성된 FireStore API 클래스
//CollectionScheme 이라는 프로토콜을 준수하고 있는 구조체를 대상으로 Firestore 저장소에 CRUD를 수행할 수 있다
class FireStoreAPI {
    static let inst : FireStoreAPI = FireStoreAPI()
    let db : Firestore
    
    private init() {
        //FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    //주어진 document를 Firestore의 지정된 collection에 삽입한다
    func CreateDocument(doc : CollectionScheme){
        // Add a new document with a generated ID
        let collectionRef = db.collection(type(of: doc).collection_name)
        do {
          let newDocReference = try collectionRef.addDocument(from: doc)
          print("data inserted with new document reference: \(newDocReference)")
        }
        catch {
          print("error occured while creating new document")
          print(error)
        }
    }
    
    //주어진 doc.uid를 가진 개체를 구조체에 저장된 데이터로 업데이트한다.
    //Read함수로 원하는 document를 가져온후 목적에 맞게 수정한후 update 하면 된다
    func UpdateDocument(doc : CollectionScheme){
        if let id = doc.id {
            let docRef = db.collection(type(of: doc).collection_name).document(id)
          do {
            try docRef.setData(from: doc)
          }
          catch {
            print("error occured while creating new document")
            print(error)
          }
        }
    }
    
    //해당 collection의 모든 document를 가져온다
    //where문을 포함하는 쿼리가 필요하다면 아래 링크를 참조합니다
    //https://firebase.google.com/docs/firestore/quickstart?hl=ko#swift_3
    func ReadDocuments<T : CollectionScheme>(completionHandler : @escaping ([T]) -> Void) {
        var items : [T] = []
        
        db.collection(T.collection_name).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error reading documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do{
                        var item = try document.data(as: T.self)
                        items.append(item)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            
            completionHandler(items)
        }
    }
    
    //uid를 통해 단일 객체를 가져와 handler 콜백을 통해 조작할 수 있다
    func ReadDocument<T : CollectionScheme>(_uid : String, completionHandler : @escaping (T) -> Void) {
        let docRef = db.collection(T.collection_name).document(_uid)

        docRef.getDocument(as: T.self) { result in
          switch result {
              case .success(let it):
                completionHandler(it)
              case .failure(let error):
                // A Book value could not be initialized from the DocumentSnapshot.
                print("Error decoding document: \(error.localizedDescription)")
              }
        }
    }
    
    //uid를 통해 단일 객체 삭제
    func DeleteDocument(_uid : String, collection_name : String) {
        let docRef = db.collection(collection_name).document(_uid)

        docRef.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

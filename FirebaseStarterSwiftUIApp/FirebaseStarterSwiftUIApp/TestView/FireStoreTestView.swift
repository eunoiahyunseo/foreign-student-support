//
//  FireStoreTestView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/05/07.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI


struct FireStoreTestView: View {
    @State var users : [User] = []
    
    var body: some View {
        VStack {
            //신규 유저 struct를 db에 집어넣음
            Button("create a user2", action: {
                var user : User = User()
                user.email = "wns7756@naver.com"
                
                FireStoreAPI.inst.CreateDocument(doc: user)
            })
            
            //유저 리스트 리프레시
            Button("Refresh", action: {
                Task(){
                    FireStoreAPI.inst.ReadDocuments { users in
                        self.users = users
                    }
                }
            })
            
            //유저 리스트를 가져옴
            List(users) { user in
                VStack {
                    Text("\(user.id!) : \(user.email!)")
                    
                    //해당 유저의 이메일을 fix@naver.com 으로 바꿈
                    Button(action : {
                        FireStoreAPI.inst.ReadDocument(_uid: user.id!) { (user : User) in
                            var user = user
                            user.email = "fix@naver.com"
                            FireStoreAPI.inst.UpdateDocument(doc : user)
                        }
                    }, label : { Text("Update")} )
                    .buttonStyle(.borderedProminent)
                    
                    //해당 유저를 삭제
                    Button("Delete"){
                        FireStoreAPI.inst.ReadDocument(_uid: user.id!) { (user : User) in
                            FireStoreAPI.inst.DeleteDocument(_uid: user.id!, collection_name: User.collection_name)
                        }
                    }
                }
            }
            .task {
                //generic type은 completion handler를 통해 추측되어 들어감
                //completion handler는 비동기 작업이 끝난 후 실행될 함수임
                FireStoreAPI.inst.ReadDocuments { (users : [User]) in
                    self.users = users
                    self.users.forEach { us in
                        print(us.id!)
                    }
                }
            }
        }
    }
}

//struct FireStoreTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        FireStoreTestView()
//    }
//}

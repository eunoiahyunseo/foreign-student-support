//
//  LinkCollection.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/05/18.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct LinkCollectionView: View {
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack{
                LinkButtonView(link: "https://www.knu.ac.kr/wbbs/wbbs/main/main.action",
                               iconname: "homekit", text: "홈 페이지")
                LinkButtonView(link: "https://international.knu.ac.kr",
                               iconname: "airplane", text: "국제 교류처")
                LinkButtonView(link: "https://knucube.knu.ac.kr/site/main/main003",
                               iconname: "square.stack.3d.down.right", text: "CUBE")
                LinkButtonView(link: "https://www.knu.ac.kr/wbbs//wbbs/bbs/btin/stdList.action?btin.page=57&btin.search_type=&btin.search_text=&popupDeco=&menu_idx=42",
                               iconname: "speaker", text: "학사 공지")
                LinkButtonView(link: "https://knu.ac.kr/wbbs/wbbs/user/yearSchedule/index.action?menu_idx=43",
                               iconname: "calendar", text: "학사 일정")
                LinkButtonView(link: "https://kudos.knu.ac.kr/pages/index.htm",
                               iconname: "book", text: "도서관")
                LinkButtonView(link: "https://mail.knu.ac.kr/member/login",
                               iconname: "paperplane", text: "웹 메일")
                
            }
        }
    }
}

struct LinkButtonView : View {
    var link : String
    var iconname : String
    var text : String
    
    var body : some View {
        VStack{
            Link(destination: URL(string : link)!,
            label: {
                Image(systemName : iconname)
            })
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8.0)
            .padding()
            
            Text(text)
        }
    }
}

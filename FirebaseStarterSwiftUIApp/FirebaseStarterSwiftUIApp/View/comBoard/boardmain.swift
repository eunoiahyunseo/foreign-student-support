//
//  boardmain.swift
//  SwiftProject-Team6
//
//  Created by 정원준 on 2023/05/03.
//

import SwiftUI

struct boardmain: View {
    var body: some View {
//        List{
//            ForEach(1...10, id: \.self){
//                Text("mylist\($0)")
//            }
//        }
        NavigationView{
            List(contentSamples){ content in
                ZStack {
                    NavigationLink(destination: ContentDetail(content: content)){
                        //ContentRow(content: content)
                        EmptyView()
                    }
                    .opacity(0)
                    
                    HStack{
                        ContentRow(content: content)
                    }
                } //네비게이션링크 화살표를 없애기 위해
            }
            .listStyle(PlainListStyle())
            .navigationTitle("자유게시판")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                //뒤로가기 버튼액션
            }, label: {
                Image(systemName: "arrow.left")})
                .foregroundColor(.black))
            .navigationBarItems(trailing: Button(action: {
                //설정 버튼액션
            }, label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))})
                .foregroundColor(.black))
            .navigationBarItems(trailing: Button(action: {
                //검색 버튼액션
            }, label: {
                Image(systemName: "magnifyingglass")
            })
                .foregroundColor(.black))
        }
    }
}
//Image(systemName: "magnifyingglass")

struct boardmain_Previews: PreviewProvider {
    static var previews: some View {
        boardmain()
    }
}

//
//  ReplyRowView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 한의진 on 2023/06/17.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct ReplyRowView: View {
    var body: some View {
        VStack(alignment: .leading) { // 왼쪽 정렬을 위해 alignment 파라미터를 .leading으로 설정합니다.
            HStack{
                Image("man")
                    .resizable()
                    .frame(width: 17, height: 17)
                Text("익명1").bold()
                Spacer()
                
            }.padding(.bottom, 5)
            Text("테스트 글입니다.")
                .padding(.bottom, 4)
            Text("날짜/시간")
                .font(.system(size: 14)) // 약간 작은 글씨를 위해 font size를 작게 설정합니다.
                .foregroundColor(.gray) // 회색 텍스트를 위해 foregroundColor를 .gray로 설정합니다.
        }
    }
}
struct ReplyRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyRowView()
    }
}

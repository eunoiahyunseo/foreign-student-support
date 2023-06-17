//
//  SendMsgView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 정원준 on 2023/06/01.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct SendMsgView: View {
    enum Field: Hashable {
        case title, content
    }

    //@EnvironmentObject var userConfigViewModel: UserConfigViewModel
    //@EnvironmentObject var boardConfigViewModel: BoardConfigViewModel
    @State private var content: String = ""
    @FocusState private var focusField: Field?
    @Binding var sendMsg: Bool
    @Binding var name: String
    @State var finsend = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    sendMsg = false
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("쪽지 보내기")
                    .font(.headline)
                    .fontWeight(.bold)
                    .offset(x: 10)
                Spacer()
                Button(action: {
                    self.finsend.toggle()
                }) {
                    Text("전송")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .background(.red)
                }
                .cornerRadius(20)
                .shadow(color: .primary.opacity(0.33), radius: 1.4, x: 1, y: 1)
                .alert("전송 완료", isPresented: $finsend) {
                    Button("Ok") {
                        self.sendMsg = false
                    }
                } message: {
                    Text("\(self.name)에게 쪽지를 전송하였습니다.")
                }
            }
            .padding([.leading, .top, .trailing])
            .padding(.bottom, 5)


            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .opacity(content.isEmpty ? 0.25 : 1)
                    .background(Color.clear)
                    .focused($focusField, equals: .content)
                    .submitLabel(.return)
                    .onTapGesture {
                        //hideKeyboard()
                    }
                if content.isEmpty {
                    Text("내용을 입력해주세요")
                        .foregroundColor(.gray)
                        .padding(.all, 8)
                        .onTapGesture {
                            focusField = .content
                        }
                }
            }
            .padding()

        }
    }
}

struct SendMsgView_Previews: PreviewProvider {
    static var previews: some View {
        @State var tmpnotice = true
        @State var fname = "친구1"
        SendMsgView(sendMsg: $tmpnotice, name: $fname)
    }
}


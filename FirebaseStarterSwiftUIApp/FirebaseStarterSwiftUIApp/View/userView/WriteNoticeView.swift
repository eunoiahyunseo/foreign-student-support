//
//  WriteNoticeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 정원준 on 2023/05/26.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct WriteNoticeView: View {
    enum Field: Hashable {
        case title, content
    }
    
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @Binding var isShownTxtFeild: Bool
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var btnEnabled: Bool = false
    @FocusState private var focusField: Field?
    
    init(isShownTxtFeild: Binding<Bool>) {
            _isShownTxtFeild = isShownTxtFeild
    }
    
    var body: some View {
        VStack{
            HStack {
                Text("공지사항 쓰기")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    isShownTxtFeild = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            TextField("제목", text: $title)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                .focused($focusField, equals: .title)
                .submitLabel(.next)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                    .focused($focusField, equals: .content)
                    .submitLabel(.return)
                    .onTapGesture {
                        if title.isEmpty{
                            focusField = .title
                        }else if !content.isEmpty{
                            hideKeyboard()
                        }
                    }
                if content.isEmpty{
                    Text("내용을 입력해주세요")
                        .font(.body)
                        .lineSpacing(10)
                        .foregroundColor(Color.primary.opacity(0.3))
                        .padding(.leading, 35)
                        .padding(.top, 40)
                        .onTapGesture {
                            if title.isEmpty{
                                focusField = .title
                            }else if !title.isEmpty{
                                focusField = .content
                            }else if !content.isEmpty{
                                hideKeyboard()
                            }
                        }
                }
            }
            
            Button(action: {
                //
            }) {
                Text("공지사항 등록하기")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .disabled(content.isEmpty || title.isEmpty)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(Color(UIConfiguration.tintColor))
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onSubmit {
            if focusField == .title{
                focusField = .content
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
} // 키보드 숨기는 코드
//
//struct WriteNoticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var tmpnotice = true
//        WriteNoticeView(isShownTxtFeild: $tmpnotice)
//    }
//}

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
    
    @State private var showingAlert = false
    
    private var adminBoardService : AdminBoardService = AdminBoardService()
    @Binding var postBefore : AdminBoard?

    init(isShownTxtFeild: Binding<Bool>, postBefore : Binding<AdminBoard?>?) {
        _isShownTxtFeild = isShownTxtFeild
        if(postBefore != nil){
            _postBefore = postBefore!
        }
        else{
            _postBefore = Binding.constant(nil)
        }
        showingAlert = false
    }
    
    var body: some View {
        VStack{
            HStack {
                if(postBefore != nil){
                    Text("공지사항 쓰기")
                        .font(.title)
                        .fontWeight(.bold)
                }
                else{
                    Text("공지사항 수정")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
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
                let currentUser: User = userConfigViewModel.state.currentUser!
                
                if(postBefore == nil){
                    let post = AdminBoard(postedBy: currentUser.nickname!, title: title, content: content, timestamp: Date())
                    
                    adminBoardService.createPost(post: post) { error in
                        if let error = error {
                            print("error: \(error)")
                        } else {
                            print("success!")
                        }
                    }
                }
                else{
                    let post = AdminBoard(postedBy: postBefore!.postedBy, title: title, content: content, timestamp: Date())
                    
                    adminBoardService.updatePost(id: postBefore!.id!, post: post, completion: { error in
                        if(error != nil){
                            print("error occured! \(error)")
                        }
                    })
                }

                showingAlert = true
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
        .onAppear{
            if(postBefore != nil){
                title = postBefore!.title
                content = postBefore!.content
            }
            else{
                title = ""
                content = ""
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("완료"),
                  message: Text("글이 등록되었습니다."),
                  dismissButton: .default(Text("OK"), action: {
                    isShownTxtFeild = false
            }))
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

struct WriteNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        WriteNoticeView(isShownTxtFeild: .constant(true), postBefore: Binding.constant(nil))
    }
}

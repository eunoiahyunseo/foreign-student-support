//
//  UserDetailView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/19.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    @State var isShownSheet = false
    @State var isShownFullScreenCover = false
    @State var isShownTxtFeild: Bool = false
    var body: some View {
        let currentUser: User = userConfigViewModel.state.currentUser!
        
        VStack() {
            HStack(spacing: 10) {
                Image(systemName: "person.crop.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 3) {
                    
                    Text(currentUser.nickname ?? "")
                        .font(.headline)
                    
                    Group {
                        HStack(spacing: 2) {
                            Text(currentUser.school ?? "")
                                .font(.subheadline)
                            Text("/")
                            Text(currentUser.email ?? "")
                                .font(.subheadline)
                        }
                        HStack(spacing: 2) {
                            Text(currentUser.region ?? "")
                                .font(.subheadline)
                            Text("/")
                            Text(currentUser.country ?? "")
                                .font(.subheadline)
                        }
                    }.foregroundColor(Color.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal, 10)
            
            // MARK: 계정과 관련된 기능
            VStack(alignment: .leading, spacing: 10) {
                
                VStack(spacing: 20) {
                    Text("계정")
                        .font(.system(size: 20))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("닉네임 설정")
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            self.isShownFullScreenCover.toggle()
                        }
                        .fullScreenCover(isPresented: $isShownFullScreenCover) {
                            NickNameModifyingCover(isShownFullScreenCover: $isShownFullScreenCover,
                                                   initialNickname: (userConfigViewModel.state.currentUser?.nickname)!)
                        }
                }
                
                
                VStack(spacing: 20) {
                    Text("로그아웃")
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            self.userConfigViewModel.state.isLogoutProcessing = true
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                

            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.top, 10)
            .padding(.horizontal, 10)
            
            //noticeIf(currentUser.isAdmin, notice)
            
            Text("next setting")
            
            Spacer()
        }
        .navigationTitle("내 정보")
    }
    
    var notice: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("공지사항")
                .font(.system(size: 20))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.padding(15)
            Text("공지사항 글쓰기")
                .font(.system(size: 17))
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    self.isShownTxtFeild.toggle()
                }
                .fullScreenCover(isPresented: $isShownTxtFeild) {
                    WriteNoticeView(isShownTxtFeild: $isShownTxtFeild)
                }
            Text("내가 쓴글")
                .font(.system(size: 17))
                .frame(maxWidth: .infinity, alignment: .leading)
//            HStack {
//                Text("공지사항 글쓰기")
//                    .font(.body)
//                    .fontWeight(.light)
//                Spacer()
//            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct NickNameModifyingCover: View {
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @Binding var isShownFullScreenCover: Bool
    @State private var nickname: String
    
    init(isShownFullScreenCover: Binding<Bool>, initialNickname: String) {
            _isShownFullScreenCover = isShownFullScreenCover
            _nickname = State(initialValue: initialNickname)
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("닉네임 설정")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    isShownFullScreenCover = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            TextField("", text: $nickname)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding()
            
            Button(action: {
                if let currentUser = userConfigViewModel.state.currentUser {
                    var updatedUser = currentUser
                    updatedUser.nickname = nickname
                    userConfigViewModel.updateUserInfo(user: updatedUser)
                }
            }) {
                Text("설정 정보 등록하기")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .disabled(nickname.isEmpty)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(Color(UIConfiguration.tintColor))
            .padding()
            Spacer() // This will push the content to the top
        }
        .alert(item: $userConfigViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                if status.title == "Successful" {
                    isShownFullScreenCover = false
                }
            }))
        }
    }
}

let mockUser = User(
    id: "123123123", email: "heart20021010@gmail.com",
    country: "Korea", region: "Seoul", language: "Korean",
    age: "21", nickname: "hyunseo", school: "경북대학교", isInitialInfoSet: true)


struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser
        
        return UserDetailView()
            .environmentObject(UserConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
        
    }
}

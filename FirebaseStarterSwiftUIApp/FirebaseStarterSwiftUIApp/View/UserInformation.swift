//
//  UserInformation.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/19.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct UserInformationForm: View {
    @Binding var showingModal: Bool
    @ObservedObject var userConfigViewModel: UserConfigViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @State var isNextUserConfigActive = false
    
    let languages = ["영어", "한국어"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("사는 나라")) {
                        TextField("사는 나라를 입력해주세요", text: $userConfigViewModel.country)
                    }
                    Section(header: Text("지역")) {
                        TextField("사는 나라의(지역)을 입력해주세요", text: $userConfigViewModel.region)
                    }
                    Section(header: Text("언어")) {
                        Picker("언어를 선택해주세요", selection: $userConfigViewModel.language) {
                            ForEach(languages, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                .navigationTitle("유저 정보 설정하기")
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    trailing: Text("1단계")
                        .foregroundColor(.red)
                        .fontWeight(.bold))
                
                Spacer()

                
                Button(action: {
                    if userConfigViewModel.isValidFirstStep {
                            self.isNextUserConfigActive = true
                        }
                    } ) {
                        Text("다음 단계로 넘어가기")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!userConfigViewModel.isValidFirstStep)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(UIConfiguration.tintColor))
                    .padding()
                    .background(
                        NavigationLink(
                            destination: SecondFormView(
                                showingModal: $showingModal,
                                userConfigViewModel: userConfigViewModel,
                                homeViewModel: homeViewModel
                            )
                            , isActive: $isNextUserConfigActive) {
                            EmptyView()
                        }
                    )
            }
        }
    }
}

struct SecondFormView: View {
    @Binding var showingModal: Bool
    @ObservedObject var userConfigViewModel: UserConfigViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    let numberFormatter = NumberFormatter()
    
    let schools = ["경북대학교", "경북대학교(상주캠퍼스)"]

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("나이")) {
                    TextField("나이를 입력해주세요",
                              text: $userConfigViewModel.age)
                    .keyboardType(.numberPad)
                }
                Section(header: Text("이름")) {
                    TextField("이름을 입력해주세요", text: $userConfigViewModel.nickname)
                }
                
                Section(header: Text("학교")) {
                    Picker("학교를 선택해주세요", selection: $userConfigViewModel.school) {
                        ForEach(schools, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
            }
            .navigationBarItems(
                trailing: Text("2단계")
                    .foregroundColor(.red)
                    .fontWeight(.bold))
            
            Button(action: {
                if userConfigViewModel.isValidSecondStep {
                    let configuredUserInfo = User(
                        email: userConfigViewModel.state.currentUser?.email,
                        country: userConfigViewModel.country,
                        region: userConfigViewModel.region,
                        language: userConfigViewModel.language,
                        age: userConfigViewModel.age,
                        nickname: userConfigViewModel.nickname,
                        school: userConfigViewModel.school,
                        isInitialInfoSet: true)

                    userConfigViewModel.createConfiguredUserInfo(user: configuredUserInfo)
                    
                }
            }) {
                Text("설정 정보 등록하기")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .disabled(!userConfigViewModel.isValidSecondStep)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(Color(UIConfiguration.tintColor))
            .padding()
        }
        .alert(item: $userConfigViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                if status.title == "Successful" {
                    // 만약 유저 정보 등록에 성공하였다면
                    showingModal = false
                    // 정상 로그인이 되었다면 isInitialInfoSet을 true로 만들어 준다.
                    homeViewModel.isInitialInfoSet = true
                }
            }))
        }
        .navigationBarTitle("유저 정보 설정하기", displayMode: .inline)
        .listStyle(.plain)
        .padding()
    }
}


struct UserInformation_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationForm(showingModal: .constant(true), userConfigViewModel: UserConfigViewModel(boardAPI: BoardService(), state: AppState()),
        homeViewModel: HomeViewModel(boardAPI: BoardService(), state: AppState()))
    }
}

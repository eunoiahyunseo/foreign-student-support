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
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    @State var isNextUserConfigActive = false
        
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
                                showingModal: $showingModal),
                            isActive: $isNextUserConfigActive) {
                            EmptyView()
                        }
                    )
            }
        }
    }
}

struct SecondFormView: View {
    @Binding var showingModal: Bool
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel
    let numberFormatter = NumberFormatter()

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
                        id: userConfigViewModel.state.currentUser?.id,
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
                    showingModal = false
                    userConfigViewModel.initField()
                }
            }))
        }
        .navigationBarTitle("유저 정보 설정하기", displayMode: .inline)
        .listStyle(.plain)
    }
}

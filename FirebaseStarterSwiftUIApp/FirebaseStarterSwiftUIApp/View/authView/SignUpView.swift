//
//  SignUpView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI
import Combine

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct SignUpView: View {
    @State var pushActive = false
    @FocusState private var focus: FocusableField?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    @Binding var index: Int

    init(index: Binding<Int>) {
        _index = index
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: HomeView(),
                           isActive: self.$pushActive) {
              EmptyView()
            }.hidden()
            
            Image("SignUp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("회원가입")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $signUpViewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $signUpViewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Confirm password", text: $signUpViewModel.confirmPassword)
                  .focused($focus, equals: .confirmPassword)
                  .submitLabel(.go)
                  .onSubmit {
                    
                  }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            
            Button(action: signUpViewModel.signUp ) {
                Text("가입")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .disabled(!signUpViewModel.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(Color(UIConfiguration.tintColor))
            
            HStack {
                Text("이미 계정이 있으신가요?")
                Button(action: {
                    // 4의 의미는 돌아갈 때 Login으로 가기 위함임
                    self.index = 4
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                Text("로그인")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(UIConfiguration.tintColor))
                }
            }
            .padding([.top, .bottom], 50)

            
        }.alert(item: $signUpViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                message: Text(status.message),
                dismissButton: .default(Text("OK"), action: {
                    if(status.title == "Successful") {
                        signUpViewModel.initField(email: true, password: true, confirmPassword: true)
                        self.pushActive = true
                    }
                }
            ))
        }
        .listStyle(.plain)
        .padding()
    }
}

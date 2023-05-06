//
//  SignUpView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/8/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseAuth

private enum FocusableField: Hashable {
  case email
  case password
}

struct SignInView: View {
    @State var pushActive = false
    @ObservedObject private var viewModel: SignInViewModel
    
    @FocusState private var focus: FocusableField?

    init(state: AppState) {
        self.viewModel = SignInViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: HomeView(state: viewModel.state),
                           isActive: self.$pushActive) {
              EmptyView()
            }.hidden()
            
            VStack(alignment: .leading, spacing: 30) {
                // login image
                Image("Login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxHeight: 400)
                
                Text("로그인")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        HStack {
                            Image(systemName: "at")
                            TextField("Email", text: $viewModel.email)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .focused($focus, equals: .email)
                                .submitLabel(.next)
                                .onSubmit {
                                    self.focus = .password
                                }
                        }
                        
                        HStack {
                               Image(systemName: "lock")
                               SecureField("Password", text: $viewModel.password)
                                 .focused($focus, equals: .password)
                                 .submitLabel(.go)
                                 .onSubmit {
                                     self.viewModel.login()
                                 }
                             }
                             .padding(.vertical, 6)
                             .background(Divider(), alignment: .bottom)
                             .padding(.bottom, 8)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center) {
                        Button(action: { self.viewModel.login() }) {
                            Text("로그인")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!viewModel.isValid)
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        
                        
                        HStack {
                            VStack { Divider() }
                            Text("OR")
                            VStack { Divider() }
                        }
                   
                        Button(action: {
                            Task {
                                await self.viewModel.googleLogin()
                            }
                        }) {
                            Text("구글 로그인")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(alignment: .leading) {
                                    Image("Google")
                                        .frame(width: 30, alignment: .center)
                                }
                        }
                        .foregroundColor(.black)
                        .buttonStyle(.bordered)
                    }
                    
                    HStack {
                            Text("아직 계정이 없으신가요?")
                            Button(action: { pushActive = true }) {
                              Text("회원가입")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            }
                    }.padding([.top, .bottom], 50)
                }
            }
            
        }.alert(item: self.$viewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                    if status.title == "Successful" {
                        self.pushActive = true
                    }
            }))
        }
        .listStyle(.plain)
        .padding()
    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                         color: backgroundColor,
                                         textColor: .white,
                                         width: 275,
                                         height: 55))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(state: AppState())
    }
}

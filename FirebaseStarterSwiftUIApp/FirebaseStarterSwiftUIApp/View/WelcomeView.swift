//
//  WelcomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @State private var index = 1
    @State private var pushActive = false
    
    @ObservedObject var state: AppState = AppState()
    
    var body: some View {
        NavigationView {
            VStack {
                // isActive가 true가 되면 연결된 뷰로 이동한다. -> Binding
                NavigationLink(destination: destinationView(),
                               isActive: self.$pushActive) {
                                EmptyView()
                }
                .navigationBarTitle("홈")
                .navigationBarHidden(true)
                
                VStack(spacing: 40) {
                    Image("knu")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                        .padding(.top, 100)
                    
                    Text("환영합니다!")
                        .modifier(TextModifier(font: UIConfiguration.titleFont,
                                               color: UIConfiguration.tintColor))
                    
                    Text("아래 로그인 혹은 회원가입 버튼을 눌러 앱을 시작해 보세요")
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont))
                        .padding(.horizontal, 60)
                    
                    // CustomModifier를 사용해서 Button을 손쉽게 스타일링 한다.
                    VStack(spacing: 25) {
                        Button(action: {
                            self.index = 1
                            self.pushActive = true
                        }) {
                            Text("로그인")
                                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                                         color: UIConfiguration.tintColor,
                                                         textColor: .white,
                                                         width: 275,
                                                         height: 55))
                        }
                        
                        Button(action: {
                            self.index = 2
                            self.pushActive = true
                        }) {
                            Text("회원가입")
                                .modifier(TextModifier(font: UIConfiguration.buttonFont,
                                                       color: .black))
                                .frame(width: 275, height: 55)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                print("appear \(self.index)")
                if self.index == 3 || self.index == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.index = 5 - self.index
                        self.pushActive = true
                    }
                }
            }
        }
        
    }
    
    // index에 따라 login, signup창을 네비게이션 뷰의 목적지로 설정한다.
    private func destinationView() -> some View {
        switch index {
        case 1:
            return AnyView(SignInView(state: state, index: $index))
            
        default:
            return AnyView(SignUpView(state: state, index: $index))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

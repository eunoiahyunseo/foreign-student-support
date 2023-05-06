//
//  SplashView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//
import SwiftUI


struct SplashView: View {
    @State var isActive:Bool = false
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack {
            if self.isActive {
                WelcomeView(state: state)
            } else {
                ZStack {
                    Color(UIConfiguration.tintColor)
                        .edgesIgnoringSafeArea(.all)
                    Image("logo")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                }
            }
        }
        .onAppear {
            // 2초 뒤에 메인 페이지가 실행될 수 있게끔 GCD를 사용해준다.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

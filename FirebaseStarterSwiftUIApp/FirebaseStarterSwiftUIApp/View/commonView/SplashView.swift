//
//  SplashView.swift
//
//  Created by Hyunseo Lee
//

import SwiftUI


struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                WelcomeView()
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

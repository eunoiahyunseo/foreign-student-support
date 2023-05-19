//
//  TapBar.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/18.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI


struct GeneralHomeTemplate<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
     
    var body: some View {
        VStack {
            TabView {
                content
            }
            
        }
    }
}

struct TapBar_Previews: PreviewProvider {
    static var previews: some View {
        GeneralHomeTemplate {
            HomeView.GTabView(text: "Home", image: "house", tag: 1)
            HomeView.GTabView(text: "Bar", image: "house", tag: 2)
        }
    }
}

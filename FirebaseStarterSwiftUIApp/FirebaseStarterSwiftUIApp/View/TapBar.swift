//
//  TapBar.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 이현서 on 2023/05/18.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct TapBar: View {
    @State var selectedTab = 0
    
    
    var body: some View {
        VStack {
            Spcaer()
            
            switch selectedTab {
            case 0:
                Text("Home")
            case 1:
                Text("Profile")
            case 2:
                Text("Settings")
            default:
                Text("Home")
            }
            
            Spacer()
            
            HStack {
               TabBarItem(icon: "house", title: "Home", isSelected: $selectedTab, index: 0)
               Spacer()
               TabBarItem(icon: "person", title: "Profile", isSelected: $selectedTab, index: 1)
               Spacer()
               TabBarItem(icon: "gear", title: "Settings", isSelected: $selectedTab, index: 2)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            .padding(.horizontal)
            .animation(.easeInOut)
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    @Binding var isSelected: Int
    let index: Int

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .foregroundColor(isSelected == index ? .blue : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected == index ? .blue : .gray)
        }
        .padding(.vertical, 10)
        .onTapGesture {
            isSelected = index
        }
    }
}


struct TapBar_Previews: PreviewProvider {
    static var previews: some View {
        TapBar()
    }
}

//
//  AdLinkCollectionView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/05/18.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

struct AdLinkCollectionView: View {
    var body: some View {
        List{
            ImageSlider()
                .frame(height: 300)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        }
    }
    
    struct ImageSlider: View {
        
        // 1
        private let images = ["knu", "knu", "knu", "knu"]
        
        @State var ad_link_infos : [AdLinkInfo] = []
        
        var body: some View {
            TabView {
                ForEach(ad_link_infos, id: \.self) { item in
                    VStack{
                        ZStack {
                            AsyncImage(url: URL(string: item.imgurl!), scale: 2) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: { ProgressView().progressViewStyle(.circular) }
                                        }
    
                        Text(item.describe!)
                            .padding()
    
                        HStack{
                            Spacer()
                            Link(destination: URL(string : item.linkurl!)!,
                            label: {
                                Text("지금 보러가기")
                            })
                            Spacer()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.red, lineWidth: 2)
                        )
                        .padding([.leading, .trailing, .bottom], 20)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .task {
                FireStoreAPI.inst.ReadDocuments { (infos : [AdLinkInfo]) in
                    self.ad_link_infos = infos
                }
            }
        }
    }
}

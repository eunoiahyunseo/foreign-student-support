//
//  ContentRow.swift
//  SwiftProject-Team6
//
//  Created by 정원준 on 2023/05/04.
//

import SwiftUI

struct ContentRow: View {
    let content: Content2
    var body: some View {
        VStack(alignment: .leading){
            Text(content.title)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.bottom, 3)
            Text(content.content)
                .font(.footnote)
                .foregroundColor(.secondary)
            footView
        }
        .padding(.leading, 15)
        .padding([.top, .trailing])
        .padding(.bottom, 7)
        //.border(Color.gray)
//        .overlay(
//            VStack {
//                Rectangle()
//                    .frame(height: 1)
//                    .foregroundColor(Color.gray)
//                Spacer()
//                Rectangle()
//                    .frame(height: 1)
//                    .foregroundColor(Color.gray)
//            }
//        )
        .frame(height: 130)
    }
}

private extension ContentRow{
    var footView: some View{
        HStack{
            Image(systemName: "hand.thumbsup")
                .imageScale(.small)
                .foregroundColor(.red)
                .frame(width: 18, height: 18)
                .padding(.trailing, -5)
            Text(String(content.isGood))
                .font(.footnote)
                .foregroundColor(.red)
            Image(systemName: "bubble.left")
                .imageScale(.small)
                .foregroundColor(.blue)
                .frame(width: 18, height: 18)
                .padding(.leading, 5)
                .padding(.trailing, -5)
            Text(String(content.comment))
                .font(.footnote)
                .foregroundColor(.blue)
        }
        .padding(.bottom, 5)
    }
}

struct ContentRow_Previews: PreviewProvider {
    static var previews: some View {
        ContentRow(content: contentSamples[0])
    }
}

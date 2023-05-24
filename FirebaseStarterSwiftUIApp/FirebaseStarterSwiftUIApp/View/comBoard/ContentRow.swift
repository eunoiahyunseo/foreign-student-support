//
//  ContentRow.swift
//  SwiftProject-Team6
//
//  Created by 정원준 on 2023/05/04.
//

import SwiftUI

struct ContentRow: View {
    var content: Post
    @EnvironmentObject var userConfigViewModel: UserConfigViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(content.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.bottom, 3)
                Text(content.content)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                footView
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 15)
        .padding([.top, .trailing])
        .padding(.bottom, 7)
        .frame(height: 130)

    }
}

extension ContentRow{
    var footView: some View{
        HStack{
            Image(systemName: "hand.thumbsup")
                .imageScale(.small)
                .foregroundColor(.red)
                .frame(width: 18, height: 18)
                .padding(.trailing, -5)
            Text(String(content.likes.count))
                .font(.footnote)
                .foregroundColor(.red)
            Image(systemName: "bubble.left")
                .imageScale(.small)
                .foregroundColor(.blue)
                .frame(width: 18, height: 18)
                .padding(.leading, 5)
                .padding(.trailing, -5)
            Text(String((content.comments?.count)!))
                .font(.footnote)
                .foregroundColor(.blue)
            
            Group {
                Text(content.postedUser)
                Text("|")
                Text(timeAgoDisplay(timestamp: content.timestamp))
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(.bottom, 5)
    }
    
    func timeAgoDisplay(timestamp: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: timestamp, to: now)
        
        if let day = components.day, day >= 1 {
            return "\(day)일 전"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        }
        
        return "방금"
    }
}

struct ContentRow_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.currentUser = mockUser
        
        return ContentRow(content: mockPosts[0])
            .environmentObject(UserConfigViewModel(
                boardAPI: BoardService(), userAPI: UserService(), state: state))
    }
}

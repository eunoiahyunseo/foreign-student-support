//
//  ContentView.swift
//  TranslateModule
//
//  Created by 한의진 on 2023/05/03.
//

import SwiftUI

struct ContentView: View {
    @State var Result = "초기값"
    @State var KORTOENG = "초기값"
    @State var ENGTOKOR = "초기값2"

    var body: some View {
       
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Translate to English").onTapGesture {
                TranslateKORtoENG(OriginalText: "오늘은 7일입니다."){
                    translated in
                    if let text = translated{
                        print(text)
                        KORTOENG = text
                    }else {
                        print("fail")
                    }
                }
                
                
                
                
            }
            Text("Translate to Korean").onTapGesture {
                TranslateENGtoKOR(OriginalText: "Wow! Don't hesitate challenge"){
                    translated in
                    if let text = translated{
                        print(text)
                        ENGTOKOR = text
                    }else {
                        print("fail")
                    }
                }
            }
            
            Text(verbatim: KORTOENG)
            Text(verbatim: ENGTOKOR)
        }
        .padding()
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

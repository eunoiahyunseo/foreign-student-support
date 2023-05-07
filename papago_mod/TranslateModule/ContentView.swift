//
//  ContentView.swift
//  TranslateModule
//
//  Created by 한의진 on 2023/05/03.
//

import SwiftUI

struct ContentView: View {
    @State var Result = "초기값"
    @State var cap = "초기값"
    var body: some View {
       
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Translate to English").onTapGesture {
                Result = exec(SendText: "오늘은 7일입니다."){
                    translated in
                    if let text = translated{
                        print(text)
                        cap = text
                    }else {
                        print("fail")
                    }
                }
                
                
                
                
            }
            Text("Translate to Korean")
            
            Text(verbatim: cap)
        }
        .padding()
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

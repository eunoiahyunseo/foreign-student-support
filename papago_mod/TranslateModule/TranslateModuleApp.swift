//
//  TranslateModuleApp.swift
//  TranslateModule
//
//  Created by 한의진 on 2023/05/03.
//

import SwiftUI

@main

struct TranslateModuleApp: App {
    var body: some Scene {
        var Result = ""
        WindowGroup {
            
            ContentView().onAppear() {
                Result = exec(SendText: "오늘은 7일입니다.")
                

            }
            VStack{
                Text(Result)
            }
        }

    }
}

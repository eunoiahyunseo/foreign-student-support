//
//  IntentsModule.swift
//  TranslateModule
//
//  Created by 한의진 on 2023/05/11.
//

import Foundation
import AppIntents
import SwiftUI

var rtext = "Initial Value"
struct IntentProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        
        return [AppShortcut(intent: ShowNotiIntent(), phrases: ["Show Notification"]),
                AppShortcut(intent: TranslateIntent(), phrases: ["Translate"])
        ]
    }
    
}


struct ShowNotiIntent: AppIntent {
    
    static var title: LocalizedStringResource = "View Notification for foreign students."
    static var description =  IntentDescription("Showing Notification provided by Foreign Students Application.")
    
    @Parameter(title: "Phrase")
    var phrase: String?
    
    func perform() async throws -> some ProvidesDialog {
        guard let providedPhrase = phrase else {
            throw $phrase.needsValueError("Error")
            
        }
        
        return .result(dialog: IntentDialog(stringLiteral: providedPhrase))
        
    }
}

struct TranslateIntent: AppIntent {
    static var ENGTOKOR:String = "Init"
    static var title: LocalizedStringResource = "Translate"
    static var description =  IntentDescription("Showing Notification provided by Foreign Students Application.")

    @Parameter(title: "Phrase")
    var phrase: String?
    
    @Parameter(title: "Language")
    var lang: String?
    
    func perform() async throws -> some ProvidesDialog {
        guard let providedPhrase = phrase else {
            throw $phrase.needsValueError("Error")
            
        }
        
        guard let providedTRLang = phrase else {
            throw $phrase.needsValueError("Error")
        }
        
        
        TranslateENGtoKOR(OriginalText: providedPhrase){
            //translated
            translated in
            if let text = translated{
                print(text)
                TranslateIntent.ENGTOKOR = text
                
            }else {
                print("fail")
            }
        }
        

        
        return .result(dialog: IntentDialog(stringLiteral: "\(TranslateIntent.ENGTOKOR)\nTranslated Text: \(providedTRLang)"))
        
    }
}

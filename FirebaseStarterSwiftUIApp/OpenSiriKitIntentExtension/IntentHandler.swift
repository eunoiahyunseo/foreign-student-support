//
//  IntentHandler.swift
//  OpenSiriKitIntentExtension
//
//  Created by 한의진 on 2023/05/24.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Intents
import UIKit
import SwiftUI


class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        guard intent is OpenSiriKitIntentAIntent else {
            fatalError("Unhandled Intent Error: \(intent)")
        }
                    
        return OpenSiriKitIntentHandler()
          //åreturn IntentViewController()
    }
    
}

class OpenSiriKitIntentHandler: NSString, OpenSiriKitIntentAIntentHandling {
    var Answ: String = "N"

    static var test = ""
    func resolveThingsToAsk(for intent: OpenSiriKitIntentAIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let Question = intent.ThingsToAsk else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: Question))
    }
    
    
    func handle(intent: OpenSiriKitIntentAIntent, completion: @escaping (OpenSiriKitIntentAIntentResponse) -> Void) {
        if let question = intent.ThingsToAsk {
            self.Answ = question
            let Answer = getAnswer(question: question)
//            if let userDefaults = UserDefaults(suiteName: "group.com.simform.temp") {            userDefaults.set(Answer, forKey: "openaians")
//            }
            //print(UserDefaults.standard.string(forKey: "openaians"))
                            //IntentHandler.Answer_s = question
            //IntentViewController.Answer = question
            //IntentViewController.Answ = Answer
            print(Answer)
            completion(OpenSiriKitIntentAIntentResponse.success(answer: NSString(string: Answer) as String))
        }
    }
    
    func confirm(intent: OpenSiriKitIntentAIntent, completion: @escaping (OpenSiriKitIntentAIntentResponse) -> Void) {
        let response = OpenSiriKitIntentAIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
    func getAnswer(question: String)->String {
        self.Answ = question
        let Answera = "OpenAI SAYS THIS. The question is \(question)"
        UserDefaults.standard.set(Answera, forKey: "asr")

        return Answera
    }
}


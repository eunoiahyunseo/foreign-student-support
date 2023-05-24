//
//  IntentHandler.swift
//  OpenSiriKitIntentExtension
//
//  Created by 한의진 on 2023/05/24.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        guard intent is OpenSiriKitIntentAIntent else {
            fatalError("Unhandled Intent Error: \(intent)")
        }
                    
        return OpenSiriKitIntentHandler()
                    
    }
    
}

class OpenSiriKitIntentHandler: NSString, OpenSiriKitIntentAIntentHandling {
    func resolveThingsToAsk(for intent: OpenSiriKitIntentAIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let Question = intent.ThingsToAsk else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: Question))
    }
    
    
    func handle(intent: OpenSiriKitIntentAIntent, completion: @escaping (OpenSiriKitIntentAIntentResponse) -> Void) {
        if let question = intent.ThingsToAsk {
            let Answer = "OpenAI SAYS THIS. The question is \(question)"
            completion(OpenSiriKitIntentAIntentResponse.success(answer: NSString(string: Answer) as String))
        }
    }
    
}

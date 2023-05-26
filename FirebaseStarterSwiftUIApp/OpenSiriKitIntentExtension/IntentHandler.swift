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




import Foundation

struct Message: Codable{
    let role: String
    let content: String
}

extension Array where Element == Message{
    var contentCount: Int{reduce(0, {$0 + $1.content.count})}
}

struct Request: Codable{
    let model: String
    let temperature: Double
    let messages: [Message]
    let stream: Bool
}

struct ErrorRootResponse: Decodable{
    let error: ErrorResponse
}

struct ErrorResponse: Decodable{
    let message: String
    let type: String?
}

struct StreamCompletionResponse: Decodable{
    let choices: [StreamChoice]
}

struct CompletionResponse: Decodable{
    let choices: [Choice]
    let usage: Usage?
}

struct Usage: Decodable{
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}

struct Choice: Decodable{
    let message: Message
    let finishReason: String?
}

struct StreamChoice: Decodable{
    let finishReason: String?
    let delta: StreamMessage
}

struct StreamMessage: Decodable{
    let role: String?
    let content: String?
}



class ChatGPTAPI: @unchecked Sendable{
    private let systemMessage: Message
    private let temperature: Double
    private let model: String
    
    private let apiKey: String
    private var historyList = [Message]()
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest{
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        headers.forEach{ urlRequest.setValue($1, forHTTPHeaderField: $0)}
        return urlRequest
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
//    private var basePrompt: String{
//        "You are ChatGPT, a large language model trained by OpenAI. Respond conversationally. Do not answer as the user. Current date: \(dateFormatter.string(from: Date()))" + "\n\n" + "User: Hello\n" + "ChatGPT: Hello! How can I help you today? <|im_end|>\n\n\n"
//    }
    
    private var headers: [String: String]{
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
    
//    private var historyListText: String{
//        historyList.joined()
//    }
    
    init(apiKey: String, model: String = "gpt-3.5-turbo", systemPrompt: String = "You are a helpful assistant", temperature: Double = 0.5){
        self.apiKey = apiKey
        self.model = model
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.temperature = temperature
    }
    
    private func generateMessages(from text: String) -> [Message]{
        var messages = [systemMessage] + historyList + [Message(role: "user", content: text)]
        if messages.contentCount > (4000 * 4){
            _ = historyList.dropFirst()
            messages = generateMessages(from: text)
        }
        return messages
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data{
        let request = Request(model: model, temperature: temperature, messages: generateMessages(from: text), stream: stream)
        return try JSONEncoder().encode(request)
    }
    
    private func appendToHistoryList(userText: String, responseText: String){
        self.historyList.append(.init(role: "user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }
    
//    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error>{
//        var urlRequest = self.urlRequest
//        urlRequest.httpBody = try jsonBody(text: text)
//
//        let (result, response) = try await urlSession.bytes(for: urlRequest)
//
//        guard let httpResponse = response as? HTTPURLResponse else{
//            throw "Invalid response"
//        }
//
//        guard 200...299 ~= httpResponse.statusCode else{
//            var errorText = ""
//            for try await line in result.lines{
//                errorText += line
//            }
//
//            if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error{
//                errorText = "\n\(errorResponse.message)"
//            }
//
//            throw "Bad Response: \(httpResponse.statusCode), \(errorText)"
//        }
//
//        return AsyncThrowingStream<String, Error> { continuation in
//            Task(priority: .userInitiated){ [weak self] in
//                guard let self else {return}
//                do{
//                    var responseText = ""
//                    for try await line in result.lines{
//                        if line.hasPrefix("data: "),
//                           let data = line.dropFirst(6).data(using: .utf8),
//                           let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
//                           let text = response.choices.first?.delta.content{
//                            responseText += text
//                            continuation.yield(text)
//                        }
//                    }
//                    self.appendToHistoryList(userText: text, responseText: responseText)
//                    continuation.finish()
//                }catch{
//                    continuation.finish(throwing: error)
//                }
//            }
//        }
//    }
    
    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else{
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else{
            var error = "Bad Response: \(httpResponse.statusCode)"
            if let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error{
                error.append("\n\(errorResponse.message)")
            }
            throw error
        }
        
        do {
            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.message.content ?? ""
            self.appendToHistoryList(userText: text, responseText: responseText)
            return responseText
        }catch{
            throw error
        }
    }
}

extension String: CustomNSError{
    public var errorUserInfo: [String : Any]{
        [
            NSLocalizedDescriptionKey: self //일반 문자열을 throw 했을때 에러를 피하기 위해
        ]
    }
}

















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
    var Answ: String? = "N"

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
            //Answer = ""
            
            Task{
                
                self.Answ = try? await getAnswer(question: question)

                completion(OpenSiriKitIntentAIntentResponse.success(answer: NSString(string: self.Answ ?? "nr") as String))
            }
            
//            if let userDefaults = UserDefaults(suiteName: "group.com.simform.temp") {            userDefaults.set(Answer, forKey: "openaians")
//            }
            //print(UserDefaults.standard.string(forKey: "openaians"))
                            //IntentHandler.Answer_s = question
            //IntentViewController.Answer = question
            //IntentViewController.Answ = Answer
            //print(Answer)
           
        }
    }
    
    func confirm(intent: OpenSiriKitIntentAIntent, completion: @escaping (OpenSiriKitIntentAIntentResponse) -> Void) {
        let response = OpenSiriKitIntentAIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
    func getAnswer(question: String) async->String {
        //self.Answ = question
        let ChatAPI = ChatGPTAPI(apiKey: "//API 키를 여기에 넣으세요.")
       //키 입력부(Github에 올리지 마시오)
        
        do{
            self.Answ = try? await ChatAPI.sendMessage(question)
            
            let Answera = "OpenAI SAYS THIS. The question is \(self.Answ)"
            UserDefaults.standard.set(Answera, forKey: "asr")
            
            return Answera
        } catch {
            return "An error occured."
        }
        
    
    }
}




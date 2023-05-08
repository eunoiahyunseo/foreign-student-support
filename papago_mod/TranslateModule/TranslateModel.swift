//
//  TranslateModel.swift
//  TranslateModule
//
//  Created by 한의진 on 2023/05/03.
//
import Alamofire
import AlamofireObjectMapper
import Foundation


func TranslateKORtoENG(OriginalText: String, completion: @escaping (String?) -> Void) -> Void {
    //네이버 파파고 API
    let url = "https://openapi.naver.com/v1/papago/n2mt"
    var TranslatedClosureReturn: String?
    let params: Parameters = [
        "source":"ko",
        "target":"en",
        "text": OriginalText
    ]
    
    let POSTHeader: HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
        //이 앱의 클라이언트 ID: 앱 통합 시 변경될 수 있습니다.
        "X-Naver-Client-Id":"utq2O9PRJiRFuaINttfG",
        //이 부분도 앱이 통합될 경우 통합된 앱에 맞게 수정해주세요.
        "X-Naver-Client-Secret":"UrSs9sdNOE"
    ]
    
    let alamo = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: POSTHeader)
    alamo.responseObject {(response:DataResponse<PAPAGO_RESULT>) ->Void in
        switch response.result
            {
            //번역 텍스트 받아오기에 성공한 경우
            case .success(let value):
                let TranslatedText = (value.message?.result?.translatedText)!
                TranslatedClosureReturn = TranslatedText
                completion(TranslatedClosureReturn)
            //텍스트 수신 실패
            case .failure(let error):
                completion(nil)
            }
    }
    
}

func TranslateENGtoKOR(OriginalText: String, completion: @escaping (String?) -> Void) -> Void {
    //네이버 파파고 API
    let url = "https://openapi.naver.com/v1/papago/n2mt"
    var TranslatedClosureReturn: String?
    let params: Parameters = [
        "source":"en",
        "target":"ko",
        "text": OriginalText
    ]
    
    let POSTHeader: HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
        //이 앱의 클라이언트 ID: 앱 통합 시 변경될 수 있습니다.
        "X-Naver-Client-Id":"utq2O9PRJiRFuaINttfG",
        //이 부분도 앱이 통합될 경우 통합된 앱에 맞게 수정해주세요.
        "X-Naver-Client-Secret":"UrSs9sdNOE"
    ]
    
    let alamo = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: POSTHeader)
    alamo.responseObject {(response:DataResponse<PAPAGO_RESULT>) ->Void in
        switch response.result
            {
            //번역 텍스트 받아오기에 성공한 경우
            case .success(let value):
                let TranslatedText = (value.message?.result?.translatedText)!
                TranslatedClosureReturn = TranslatedText
                completion(TranslatedClosureReturn)
            //텍스트 수신 실패
            case .failure(let error):
                completion(nil)
            }
    }
    
}

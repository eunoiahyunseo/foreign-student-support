//
//  TranslateModel.swift
//  TranslateModule
//
//  Created by 한의진 on 2023/05/03.
//
import Alamofire
import AlamofireObjectMapper
import Foundation


func exec(SendText: String) -> String {
    //API URL
    let url = "https://openapi.naver.com/v1/papago/n2mt"
    var Trans_Res = ""
    //파라미터
    let params: Parameters = [
        //번역 전 언어(한국어)
        "source":"ko",
        
        //번역 후 언어(영어)
        "target":"en",
        
        //번역요청 텍스트
        "text": SendText
    ]
    
    //헤더정보
    let header: HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
        
        //Client-Id(꼭 본인 값으로 변경해서 사용해주세요.)
        "X-Naver-Client-Id":"utq2O9PRJiRFuaINttfG",
        
        //Client-Secret(꼭 본인 값으로 변경해서 사용해주세요.)
        "X-Naver-Client-Secret":"UrSs9sdNOE"
    ]
    
    //Alamofire 요청
    let alamo = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header)
    
    alamo.responseObject {(response:DataResponse<PAPAGO_RESULT>) in


        switch response.result
            {
            //통신성공
            case .success(let value):
                let TRANS_TEXT = (value.message?.result?.translatedText)!
                print("번역 텍스트는 '\(TRANS_TEXT)' 입니다.")
            Trans_Res = TRANS_TEXT
                
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.localizedDescription))")
            }
        

    }
    return Trans_Res
    
}

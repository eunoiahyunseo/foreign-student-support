import ObjectMapper

//1단계
class PAPAGO_RESULT: Mappable{
    var message: MESSAGE?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
    }
    
    //2단계
    class MESSAGE: Mappable {
        var result: RESULT?
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            result <- map["result"]
        }
        
        //3단계
        class RESULT: Mappable{
            var translatedText: String?
            
            required init?(map: Map) {
            }
            func mapping(map: Map) {
                translatedText <- map["translatedText"]
            }
        }
    }
}

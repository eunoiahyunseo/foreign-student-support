//
//  Content.swift
//  SwiftProject-Team6
//
//  Created by 정원준 on 2023/05/03.
//

import Foundation

struct Content2 {
    let id: UUID = UUID()
    let title: String
    let content: String
    //let price: Int
    //let description: String
    var isGood: Int
    var comment: Int
    var isFavorite: Bool = false
}

let contentSamples = [
    Content2(title: "출튀준비완료", content: "교수가 잘 가르쳤으면....나도 이러지 않았어..이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ, 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ, 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ, 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 0, comment: 2),
    Content2(title: "기아 삼성", content: "이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 3, comment: 1),
    Content2(title: "학헬 벤치", content: "이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 0, comment: 0),
    Content2(title: "군대에 있으면", content: "이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 4, comment: 3),
    Content2(title: "출튀준비완료...", content: "교수가 잘 가르쳤으면....나도 이러지 않았어..이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ, 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ, 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ, 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 0, comment: 2),
    Content2(title: "기아 삼성", content: "이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ 이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 3, comment: 1),
    Content2(title: "학헬 벤치", content: "이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 0, comment: 0),
    Content2(title: "군대에 있으면", content: "이러쿵 저러쿵 하면서 뭐라뭐라 하면서 이랬다가 저랬다가 하넼ㅋㅋㅋ", isGood: 4, comment: 3),
]

extension Content2: Decodable{}
extension Content2: Identifiable{}

//
//  AdLinkInfo.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by junha on 2023/05/18.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

//공모전, 광고등의 탭뷰 공간에 쓰일 정보를 저장하는 구조체. Hashable을 추가로 구현한 것은
//TabView 내에서 Foreach로 순회하며 뷰를 형성하기 위함임
struct AdLinkInfo : CollectionScheme, Identifiable, Hashable {
    static var collection_name: String = "ad_link_info"
    @DocumentID var id : String?
    
    var linkurl : String?   //클릭했을때 이동할 웹 링크주소
    var imgurl : String?    //이미지를 가져올 곳
    var describe : String?  //이미지 아래에 표시될 상세 설명
}

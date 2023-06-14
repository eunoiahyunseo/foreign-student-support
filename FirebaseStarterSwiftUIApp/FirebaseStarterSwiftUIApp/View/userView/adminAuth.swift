//
//  adminAuth.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 정원준 on 2023/05/25.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import SwiftUI

extension View{
    @ViewBuilder public func noticeIf<T: View>(
        _ condition: Bool,
        _ content: T
    ) -> some View{
        if condition{
            content
        }else{
            EmptyView()
        }
    }
}

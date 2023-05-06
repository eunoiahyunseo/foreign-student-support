//
//  CustomModifier.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI

struct TextModifier: ViewModifier {
    private let font: UIFont
    private let color: UIColor
    
    init(font: UIFont, color: UIColor = .black) {
        self.font = font
        self.color = color
    }
    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .font(.custom(font.fontName, size: font.pointSize))
            .foregroundColor(Color(color))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
    }
}

struct ShadowModifier: ViewModifier {
    let color: UIColor
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(color), radius: 5.0, x: 3, y: 3)
    }
}

/**
 버튼을 수식하는 Custom Button Modifier이다.
 Font, Color, textColor, width, height를 지정해 줄 수 있다.
 */
struct ButtonModifier: ViewModifier {
    private let font: UIFont
    private let color: UIColor
    private let textColor: UIColor
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(font: UIFont,
         color: UIColor,
         textColor: UIColor = .white,
         width: CGFloat? = nil,
         height: CGFloat? = nil) {
        self.font = font
        self.color = color
        self.textColor = textColor
        self.width = width
        self.height = height
    }
    
    // Modifier는 항상 다른 View를 반환해주어야 한다.
    func body(content: Content) -> some View {
        content
            .modifier(TextModifier(font: font,
                                      color: textColor))
            .padding()
            .frame(width: width, height: height)
            .background(Color(color))
            .cornerRadius(25.0)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 25,
                                 style: .continuous)
                    .stroke(Color.gray, lineWidth: 1)
        )
    }
}

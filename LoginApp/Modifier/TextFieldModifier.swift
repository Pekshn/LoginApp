//
//  TextFieldModifier.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import SwiftUI

//MARK: - TextField modifier
struct TextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2))
            .padding(.horizontal, 20)
            .accentColor(.white)
    }
}

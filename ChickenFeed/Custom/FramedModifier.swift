//
//  GrayFrameBackground.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 24.06.2025.
//

import SwiftUI

extension View {
    func muchDarkFramed(isBordered: Bool = false) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(.backgroundAccent)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.lightAccent, lineWidth: isBordered ? 1 : 0)
            }
    }
    func darkFramed(isBordered: Bool = false) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(.darkAccent)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.lightAccent, lineWidth: isBordered ? 1 : 0)
            }
    }
    func lightFramed() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(.lightAccent)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .darkFramed()

}

//
//struct GrayFrameBackground: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(.grayAccent)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//}


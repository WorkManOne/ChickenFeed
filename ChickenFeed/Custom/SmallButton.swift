//
//  SmallButtonView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct SmallButton: View {
    let image: Image
    let title: String
    var description: String = ""
    var isStyle: Bool = false

    var body: some View {

        VStack (alignment: isStyle ? .leading : .center){
            image
                .resizable()
                .scaledToFit()
                .foregroundStyle(.yellowAccent)
                .padding(isStyle ? 0 : 12)
                .frame(width: isStyle ? 20 : 40, height: isStyle ? 20 : 40)
                .background(
                    Circle()
                        .fill(.darkAccent)
                        .opacity(isStyle ? 0 : 1)
                )
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: isStyle ? 16 : 12, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.top, isStyle ? 10 : 5)
                .padding(.bottom, isStyle ? 1 : 5)
            if isStyle {
                Text(description)
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: isStyle ? .leading : .center)
        .lightFramed()

    }
}

#Preview {
    SmallButton(image: Image(systemName: "plus"), title: "Add Feeding", description: "Calculate nutritional needs", isStyle: true)
    HStack {
        SmallButton(image: Image(systemName: "plus"), title: "Add Feeding")
        SmallButton(image: Image(systemName: "waterbottle.fill"), title: "Add Feeding")
    }
}

//
//  CardboardView.swift
//  BoxButler
//
//  Created by 64014784 on 3/14/24.
//

import SwiftUI

struct CardboardView: View {
    var body: some View {
        Image("cardboard")
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(180))
            .ignoresSafeArea()
        Spacer()
    }
}

#Preview {
    CardboardView()
}

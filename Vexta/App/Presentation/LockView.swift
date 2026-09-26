//
//  LockView.swift
//  Vexta
//
//  Created by MaxAdmin on 19.09.2026.
//

import SwiftUI

struct LockView: View {

    let reason: String

    var body: some View {
        VStack {
            Text("Lock screen")
            Text(reason)
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LockView(reason: "Preview reason")
}

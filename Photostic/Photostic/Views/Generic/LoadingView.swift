//
//  LoadingView.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-09.
//

import SwiftUI

// Used as reusable loader in multiple places
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(0.2)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(2)
            
        }
    }
}

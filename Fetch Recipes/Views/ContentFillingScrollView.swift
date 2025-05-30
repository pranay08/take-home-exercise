//
//  ContentFillingScrollView.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import SwiftUI

struct ContentFillingScrollView<Content: View>: View {
    private let contentBuilder: () -> Content
    
    init(@ViewBuilder contentBuilder: @escaping () -> Content) {
        self.contentBuilder = contentBuilder
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                contentBuilder()
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
            }
        }
    }
}

#Preview {
    ContentFillingScrollView {
        VStack(spacing: 16) {
            Text("Center content")
        }
    }
}

#Preview {
    ContentFillingScrollView {
        ForEach(0..<100, id: \.self) { i in
            Text("Row \(i)")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

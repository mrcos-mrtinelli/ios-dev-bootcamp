//
//  InfoView.swift
//  SwiftUIBusinessCard
//
//  Created by Marcos Martinelli on 3/7/21.
//

import SwiftUI

struct InfoView: View {
    let text: String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.white)
            .frame(height: 40.0)
            .overlay(
                HStack {
                    Image(systemName: imageName)
                        .foregroundColor(.green)
                    Text(text)
                })
            .padding()
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "88888888", imageName: "phone.fill")
            .previewLayout(.sizeThatFits)
    }
}

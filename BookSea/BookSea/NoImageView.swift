//
//  NoImageView.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import SwiftUI

struct NoImageView: View {
    var title: String
    
    var body: some View {
        
        VStack {
            Image(systemName: "book")
                .padding()
                .shadow(color: .gray, radius: 10, x: 4, y: 4)
                .font(.system(size: 72))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.body)
            
        }
    }
}

struct NoImageView_Previews: PreviewProvider {
    static var previews: some View {
        NoImageView(title: "Some book title")
            .previewLayout(.sizeThatFits)
    }
}

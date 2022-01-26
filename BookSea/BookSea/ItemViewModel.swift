//
//  ItemViewModel.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import Foundation

struct ItemViewModel: Identifiable, Hashable {
    let id: String
    
    var imageUrlString: String?
    var imageURL: URL? {
        
        guard let urlString = imageUrlString else {
            return nil
        }
        
        return URL(string: urlString)
    }
    
    var text: String
    var subText: String
}



//
//  APIService.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import Foundation

protocol APIService {
    func searchBookWithTerm(term: String, completion: @escaping ([ItemViewModel], Error?) -> Void)
}

enum AppError: Error {
    case iDunnoError
    case decodeError
}

struct BooksAPI: APIService {
    func searchBookWithTerm(term: String, completion: @escaping ([ItemViewModel], Error?) -> Void) {
        let queryItems = [
            URLQueryItem(name: "q", value: term),
            URLQueryItem(name: "projection", value: "lite")
        ]
        
        var urlComps = URLComponents(string: "https://www.googleapis.com/books/v1/volumes")!
        urlComps.queryItems = queryItems
        
        //Guard here so if url is not valid it should return
        guard let url = urlComps.url else {
            completion([], AppError.iDunnoError)
            return
        }
        

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            guard let bookVolumes = try? JSONDecoder().decode(BookVolumes.self, from: data) else {
                //if decode fails it should return and complete with error
                completion([], AppError.decodeError)
                return
            }
            
            //Map Model `Book` to viewModel `Item View Model`
            let itemVMs = bookVolumes.items.map {
                ItemViewModel(
                    id: $0.id,
                    imageUrlString: $0.volumeInfo.imageLinks?.smallThumbnail,
                    text: $0.volumeInfo.title,
                    subText: $0.volumeInfo.subtitle ?? "")
                
            }
            
            completion(itemVMs, nil)
        }

        task.resume()
    }
    
    
}

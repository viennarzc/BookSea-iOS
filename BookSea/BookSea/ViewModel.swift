//
//  ViewModel.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import SwiftUI

struct ViewModel {
    
    private var api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    func searchBookWith(term: String, completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.searchBookWithTerm(term: term) { items, error in

            //early return if error is encountered
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(items))
        }
    }

}

//
//  ContentView.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    
    let data = (1...50).map { "Hello \($0)" }
    
    @State private var items: [ItemViewModel] = []
    
    private let columns = [
        GridItem(.adaptive(minimum: 90)),
        GridItem(.adaptive(minimum: 90))
    ]
    
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate func searchBook() {
        viewModel.searchBookWith(term: searchText) { result in
            
            switch result {
                
            case .success(let items):
                self.items = items
                
            case .failure(let error):
                //TODO: Add show error
                print("error \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            
                            if let url = item.imageURL {
                                AsyncImage(url: url)
                                    .frame(width: 100, height: 200, alignment: .center)
                                    .shadow(color: .gray, radius: 10, x: 4, y: 4)
                                
                            } else {
                                Image(systemName: "book")
                                    .padding()
                                    .shadow(color: .gray, radius: 10, x: 4, y: 4)
                                
                            }
                            Text(item.text)
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                        }

                    }
                    
                }
                .searchable(text: $searchText) {
                    
                }
                .onSubmit(of: .search) {
                    searchBook()
                    print("submit")
                }
                .navigationTitle("Book Search")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel(api: BooksAPI()))
    }
}

protocol APIService {
    func searchBookWithTerm(term: String, completion: @escaping ([ItemViewModel], Error?) -> Void)
}

enum AppError: Error {
    case iDunnoError
    case decodeError
}

struct BooksAPI: APIService {
    func searchBookWithTerm(term: String, completion: @escaping ([ItemViewModel], Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: term)]
        
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
                    imageUrlString: $0.volumeInfo.imageLinks.smallThumbnail,
                    text: $0.volumeInfo.title,
                    subText: $0.volumeInfo.subtitle ?? "")
                
            }
            
            completion(itemVMs, nil)
        }

        task.resume()
    }
    
    
}

struct BookVolumes: Decodable {
    let items: [Book]
}

struct Book: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let imageLinks: ImageLinks
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}

struct ItemViewModel: Identifiable, Hashable {
    let id: String
    
    var imageUrlString: String
    var imageURL: URL? {
        return URL(string: imageUrlString)
    }
    
    var text: String
    var subText: String
}


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

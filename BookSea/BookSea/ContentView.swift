//
//  ContentView.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""

    @State var items: [ItemViewModel] = []
    
    private let columns = [
        GridItem(.adaptive(minimum: 150)),
        GridItem(.adaptive(minimum: 150))
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
                    ForEach(items) { item in
                        VStack(alignment: .center) {
                            
                            if let url = item.imageURL {
                                AsyncImage(url: url)
                                    .frame(width: 150, height: 200, alignment: .center)
                                    .shadow(color: .gray, radius: 10, x: 4, y: 4)
                                
                                //shows a default / no image view if book has no image url
                            } else {
                                NoImageView(title: item.text)
                                    .frame(width: 150, height: 200, alignment: .center)
                                    .background(Color.gray.opacity(0.5))
                            }
                            
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



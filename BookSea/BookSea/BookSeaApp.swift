//
//  BookSeaApp.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import SwiftUI

@main
struct BookSeaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel(api: BooksAPI()))
        }
    }
}

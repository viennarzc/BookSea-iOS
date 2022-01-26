//
//  Book.swift
//  BookSea
//
//  Created by Viennarz Curtiz on 1/26/22.
//

import Foundation

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
    let authors: [String]?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}

//
//  NewsItem.swift
//  News feed
//
//  Created by Ivan Solohub on 22.10.2024.
//
import Foundation

struct NewsItem: Encodable, Decodable {
    let title: String
    let imageUrl: String
    let sourceName: String
    let datePublished: Date
    let sourceLink: String
}

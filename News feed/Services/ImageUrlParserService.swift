//
//  ImageUrlParserService.swift
//  News feed
//
//  Created by Ivan Solohub on 06.12.2024.
//


import Foundation

class ImageUrlParserService {
    
    static func extractImageUrlFromDescription(_ description: String) -> String? {
        let pattern = #"img src="([^"]+)""#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        let range = NSRange(location: 0, length: description.utf16.count)

        guard let match = regex.firstMatch(in: description, options: [], range: range),
              let imageUrlRange = Range(match.range(at: 1), in: description) else { return nil }

        var imageUrl = String(description[imageUrlRange])
        imageUrl = imageUrl.replacingOccurrences(of: "&amp;", with: "&")

        return URL(string: imageUrl) != nil ? imageUrl : nil
    }
}

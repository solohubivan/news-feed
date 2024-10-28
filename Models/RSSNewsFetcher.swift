//
//  RSSNewsFetcher.swift
//  News feed
//
//  Created by Ivan Solohub on 22.10.2024.
//
import Foundation

class RSSNewsFetcher: NSObject, XMLParserDelegate {
    
    var newsItems: [NewsItem] = []
    
    private var currentElement = ""
    private var currentTitle = ""
    private var currentImageUrl = ""
    private var currentDescription = ""

    private var parserCompletionHandler: (() -> Void)?

    func fetchNews(completionHandler: @escaping () -> Void) {
        self.parserCompletionHandler = completionHandler
        
        let urlString = "https://www.reddit.com/.rss"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "media:thumbnail" {
            if let url = attributeDict["url"] {
                currentImageUrl = url
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "content":
            currentDescription += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            let newsItem = NewsItem(title: currentTitle, imageUrl: currentImageUrl)
            newsItems.append(newsItem)
            currentTitle = ""
            currentImageUrl = ""
            currentDescription = ""
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?()
    }
}

//
//  APIFetcher.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 04/06/22.
//

import Foundation

struct RemoteNote: Codable {
    var id: String
    var title: String
    var body: String
    var time: String
    var image: String?
}
enum FetcherError: Error {
    case invalidURL
}
    
struct APIFetcher {
    static func fetchNotes() async throws -> [RemoteNote] {
        guard let url = URL(string: "https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/posts") else {
                throw FetcherError.invalidURL
            }

            let (data, _) = try await URLSession.shared.data(from: url)

            let iTunesResult = try JSONDecoder().decode([RemoteNote].self, from: data)
            return iTunesResult
        
    }
}

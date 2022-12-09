//
//  APICaller.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 12/7/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {
    }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    public func search(with query: String, completion: @escaping (Result<SearchResults, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/search?limit=10&type=track&q=+\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(SearchResults.self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?, type:HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        }
    }

}

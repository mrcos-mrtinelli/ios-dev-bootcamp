//
//  NetworkManager.swift
//  HackerNewsReader
//
//  Created by Marcos Martinelli on 3/9/21.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetch() {
        let stringURL = "https://hn.algolia.com/api/v1/search?tags=front_page"
        
        if let url = URL(string: stringURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("data issues")
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let results = try decoder.decode(Results.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.posts = results.hits
                    }
                    
                } catch {
                    print("error: \(error)")
                }
            }
            task.resume()
        }
    }
}

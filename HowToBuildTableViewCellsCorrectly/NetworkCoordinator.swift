//
//  NetworkCoordinator.swift
//  HowToBuildTableViewCellsCorrectly
//
//  Created by Eric Dockery on 6/2/18.
//  Copyright © 2018 Eric Dockery. All rights reserved.
//

import Foundation

enum Results {
    case Success(Bool)
    case Failure(Error)
}

enum Method:String {
    case RecentPhotos = "flickr.photos.getRecent"
}

class NetworkCoordinator {
    static let shared = NetworkCoordinator()
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    private static let baseURLString = "https://api.flickr.com/services/rest"

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    private static func recentPhotosURL() -> URL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }

    private static func flickrURL( method: Method, parameters:[String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]

        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }

        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }

    func fetchRecentPhotos(completion: @escaping (Results) -> Void) {
        let url = NetworkCoordinator.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }

    private func processRecentPhotosRequest(data: Data?, error: Error?) -> Results {
        guard data != nil else {
            return .Failure(error!)
        }
        return .Success(true)
    }
}

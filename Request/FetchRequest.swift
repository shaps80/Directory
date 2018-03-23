//
//  FetchService.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import Foundation

/// Encapsulates the fetching of `sites.json`. Its assumed that you will retain and reuse this instance.
/// You can specify a different environment when performing a fetch if necessary.
public final class FetchRequest {
    
    public var state: State = .ready
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func fetch(with environment: Environment = .master, completion: @escaping Completion) {
        guard state == .ready else {
            debugPrint("A request is already in progress.")
            return
        }
        
        let request = URLRequest(url: environment.url)
        
        func complete(with result: Result) {
            DispatchQueue.main.async {
                completion(result)
            }
            
            state = .ready
        }
        
        state = .inProgress
        urlSession.dataTask(with: request) { data, response, error in
            // if we got an error, complete with failure
            if let error = error {
                complete(with: .failure(error, environment))
                return
            }
            
            // if we got anything other than 200 for the response, complete with failure
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                complete(with: .failure(Error.unknown(data, response), environment))
                return
            }
            
            // if we didn't get any data, complete with failure
            guard let jsonData = data else {
                complete(with: .failure(Error.missingData, environment))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let regions = try decoder.decode([Region].self, from: jsonData)
                let categories = regions.flatMap { $0.categories }
                complete(with: .success(categories))
            } catch {
                // if JSON parsing failed, complete with failure
                complete(with: .failure(error, environment))
            }
        }.resume()
    }
    
}

extension FetchRequest {
    
    public typealias Completion = (Result) -> Void
    
    public enum State {
        case ready
        case inProgress
    }
    
    public enum Result {
        case success([Category])
        case failure(Swift.Error, Environment)
    }
    
    public enum Error: Swift.Error {
        case missingData
        case unknown(Data?, URLResponse?)
    }
    
}

extension FetchRequest.Error: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .missingData: return localized("error.missingData")
        case .unknown: return localized("error.unknown")
        }
    }
    
}

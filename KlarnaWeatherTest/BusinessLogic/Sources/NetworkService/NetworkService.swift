//
//  NetworkService.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import Foundation

public enum GeneralError: Error {
    case badResponse
    case badUrl
}

public protocol INetworkService {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ())
}

public final class NetworkService: INetworkService {
    private var currentTask: URLSessionDataTask?
    private let dataTaskFactory: IDataTaskFactory
    
    private let queue = DispatchQueue(label: "NetworkService.fetch")
    
    public init(dataTaskFactory: IDataTaskFactory) {
        self.dataTaskFactory = dataTaskFactory
    }
    
    public func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
        queue.async { [weak self] in
            self?.currentTask?.cancel()
            
            let request = URLRequest(url: url)
            let task = self?.dataTaskFactory.dataTask(with: request) { data, _, error in
                guard let data,
                      let decodedResponse = try? JSONDecoder().decode(T.self, from: data)
                else {
                    completion(.failure(GeneralError.badResponse))
                    return
                }
                
                completion(.success(decodedResponse))
            }
            
            task?.resume()
            
            self?.currentTask = task
        }
    }
}

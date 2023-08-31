//
//  File.swift
//  
//
//  Created by Igor Naumenko on 30.08.2023.
//

import Foundation

public protocol IDataTaskFactory {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: IDataTaskFactory {}

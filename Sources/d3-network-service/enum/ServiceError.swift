//
//  ServiceError.swift
//
//
//  Created by Igor Shelopaev on 25.05.2022.
//

import Foundation

/// Set of errors defined in the service
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 6.0, *)
public enum ServiceError: Error, Hashable {
    /// describe errors while chaining
    case chainingError

    /// input data could not be formed
    case inputDataError

    /// url error
    case urlError(String)

    /// The server response was invalid (unexpected format)
    case invalidResponse(URLResponse)

    /// The request was rejected: 400-499
    case clientError(HTTPURLResponse)

    /// A server error 500...599
    case serverError(HTTPURLResponse)

    /// status code error
    case http(HTTPURLResponse)

    /// There was an error parsing the data
    case parseError(String)

    /// Undefined error
    case error(NSError)
}

//
//  IRequest.swift
//
//
//  Created by Igor Shelopaev on 25.05.2022.
//

import Foundation
import Combine




/// Defines an interface to create `URLRequest`
public protocol IRequest {

    /// The path that will be appended to API's base URL.
    var path: String { get }

    /// The HTTP method.
    var method: RequestMethod { get }
}

extension IRequest {

    /// Create a URLRequest
    /// - Parameter environment: The environment where `URLRequest` happens
    /// - Parameter body:  Passing data
    /// - Returns: An optional `URLRequest`
    func urlRequest(
                    with environment: IEnvironment,
                    body: Data,
                    _ parameters: RequestParameters? = nil
    ) -> URLRequest? {

        guard var request = urlRequest(with: environment, parameters)else{
            return nil
        }

        request.httpBody = body

        return request
    }

    /// Create a URLRequest
    /// - Parameter environment: The environment where `URLRequest` happens
    /// - Returns: An optional `URLRequest`
    func urlRequest(
                    with environment: IEnvironment,
                    _ parameters: RequestParameters? = nil

    ) -> URLRequest? {

        guard let url = url(with: environment.baseURL, parameters) else {
            return nil
        }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        if let headers = environment.headers {
            headers.forEach { request.addValue($0) }
        }

        return request
    }

    // MARK: - Private

    /// Create a URL
    /// - Parameter baseURL: The base URL string
    /// - Returns: An optional `URL`
    private func url(
        with baseURL: String,
        _ parameters: RequestParameters?
    ) -> URL? {

        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }

        urlComponents.path = urlComponents.path + path

        urlComponents.queryItems = queryItems(parameters)

        return urlComponents.url
    }

    /// Create a list of parameters
    /// Returns the URLRequest `URLQueryItem`
    private func queryItems(_ parameters: RequestParameters?) -> [URLQueryItem]? {

        guard let parameters = parameters else { return nil }

        return parameters.map { (item) -> URLQueryItem in
            let valueString = String(describing: item.value ?? "")
            return URLQueryItem(name: item.key, value: valueString)
        }
    }

}

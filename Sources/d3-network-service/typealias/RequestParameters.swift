//
//  RequestParameters.swift
//
//
//  Created by Igor Shelopaev on 27.05.2022.
//

import Foundation

/// Type alias used for HTTP request parameters. Used for query parameters for GET, POST, PUT requests
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 6.0, *)
public typealias RequestParameters = [String: CustomStringConvertible]

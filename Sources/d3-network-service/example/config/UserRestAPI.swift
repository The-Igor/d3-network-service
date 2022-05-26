//
//  UserEndpoint.swift
//
//  Created by Igor Shelopaev on 25.05.2022.
//

import Foundation

enum UserRestAPI {
    
    case index(page: Int?)
    
    case read(id: Int)
    
    case create
    
    case update
    
    case delete(id: Int)
    
}

extension UserRestAPI: IRequest {
    
    var path: String {
        switch self {
        case .index: return "/user"
        case .read(let id): return "/user/\(id)"
        case .create: return "/user"
        case .update: return "/user"
        case .delete(let id): return "/user/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .index: return .get
        case .read(_): return .get
        case .create: return .post
        case .update: return .put
        case .delete(_): return .delete
        }
    }
    
    var parameters: [IRequestParameter] {
        
        if case .index(let num) = self {
            return Pagination.getAll(num: num)
        }
        
        return []
    }
    
}

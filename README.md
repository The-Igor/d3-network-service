# Network service layer Combine REST API CRUD
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fd3-network-service%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/d3-network-service) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fd3-network-service%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/d3-network-service)

Easy and lightweight network layer. Reactive wrapper for **URLSession.shared.dataTaskPublisher** to create different set of network requests like GET, POST, PUT, DELETE customizable with coders conforming to `TopLevelDecoder`, `TopLevelEncoder`

## Features
- [x] Stand alone package without any dependencies using just Apple's **Combine** facilities
- [x] Error handling from forming URLRequest object to gettting data on a subscription
- [x] Customizable for different environments development, production...
- [x] Customizable for different requests schemes from classic **CRUD Rest** to what suits to your own custom routes
- [x] Based on interfaces not implementations
- [x] Ability to log and customize logers for different environment
- [x] Ability to chain requests layering with predicate logic analyzing previous result

## 1. Environment
Define **enum** with interface [**IEnvironment**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/protocol/data/IEnvironment.swift)

```swift
enum Environment: IEnvironment {

    case development

    case production

    var baseURL: String {
        switch self {
            case .development: return "http://localhost:3000"
            case .production: return "https://apple.com"
        }
    }
    
    var headers: [IRequestHeader]? {
        switch self {
            case .development: return [ContentType.applicationJSON]
            case .production: return [ContentType.textJSON]
        }
    }
    
    var logger : ILogger? {
        switch self {
            case .development: return ServiceLogger()
            case .production: return nil
        }
    }  
}
```

### Request headers
All headers for a request have to conform to the interface [**IRequestHeader**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/protocol/data/IRequestHeader.swift)

The example implemetation for content type headers is here [**ContentType.swift**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/enum/ContentType.swift)

### Logger
You can use out of the box standard logger [**ServiceLogger**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/log/ServiceLogger.swift) if you don't need some specific data from [**URLRequest**](https://developer.apple.com/documentation/foundation/urlrequest) and [**URLResponse**](https://developer.apple.com/documentation/foundation/urlresponse) or define your own with interface [**ILogger**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/protocol/ILogger.swift)
## 2. API for endpoint
Define endpoint API **enum** 
```swift
enum UserRestAPI {

    case index
    case read(id: Int)
    case create
    case update
    case delete(id: Int)
}
```

Extend the enum with interface [**IRequest**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/protocol/data/IRequest.swift)

| field | type |
| --- | --- |
| route | String |
| method | RequestMethod |

```swift
extension UserRestAPI: IRequest {
    
    var route: String {
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
}
```
            
The example implemetation is here **UserRestAPI.swift**
[**UserRestAPI.swift**](https://github.com/The-Igor/d3-network-service/blob/main/Sources/d3-network-service/example/config/UserRestAPI.swift)



## 3. Create network sevice
```swift
    let network = NetworkService(environment: Environment.development)
```

`execute` - There's only one API method to do requests that gets what type of request you whant to do from the endpont configuration GET, POST, PUT, DELETE

There are four methods are available currently  GET, POST, PUT, DELETE

### Parameters
Pass a [String: CustomStringConvertible] dictionary to the parameter that avalable for GET, POST, PUT requests. It's an optinal parameter.

### Read

```swift
   let cfg = UserRestAPI.read(id: 1)
   
   let publisher: Output = network.execute(with: cfg, ["token" : 65678])
```

### Create
```swift
    let cfg = UserRestAPI.create
    let user = Model(id: 11, name: "Igor")

    let publisher: Output = network.execute(body: user, with: cfg)
```
### Update
```swift
    let cfg = UserRestAPI.update
    let user = Model(id: 11, name: "Igor")    

    let publisher: Output = network.execute(body: user, with: cfg)
```

### Delete
```swift
    let cfg = UserRestAPI.delete(id: 11)
    
    let publisher: Output = network.execute(with: cfg)
```    

### Chaining requests (Serial queue)
```swift
        let read: Output = network.execute(with: UserRestAPI.index)

        let user = Model(id: 11, name: "Igor")
        let create: Output = network.execute(body: user, with: UserRestAPI.create)
        
        read
            .then(create)
            
        // or chain it using predicate to analyze previous result
        
        read.then(ifTrue : {$0.count > 1}, create)
```    

## Package installation 
In Xcode - Select `Xcode`>`File`> `Swift Packages`>`Add Package Dependency...`  
and add `https://github.com/The-Igor/d3-network-service`


## Try it in the real environment
### Simple server instalation (mocking with NodeJS Express)

To try it in the real environment. I suggest installing the basic NodeJS Express boilerplate. Take a look on the video snippet how easy it is to get it through Webstorm that is accessible for free for a trial period.

[![Server instalation (NodeJS Express)](https://github.com/The-Igor/d3-network-service/blob/main/img/server_install.png)](https://youtu.be/9FPOYHzcE7A)

- Get [**WebStorm Early Access**](https://www.jetbrains.com/webstorm/nextversion)
- Get [**index.js**](https://github.com/The-Igor/d3-network-service/blob/main/js/index.js) file from here and replace it with the one in the boilerplate and luanch the server.

### Real SwiftUI example
[d3-rest-combine-swift-example](https://github.com/The-Igor/d3-rest-combine-swift-example)
- Run server *NodeJS Express*
- Run SwiftUI project

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

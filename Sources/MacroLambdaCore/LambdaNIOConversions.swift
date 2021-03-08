//
//  LambdaNIOConversions.swift
//  MacroLambda
//
//  Created by Helge Heß
//  Copyright © 2020-2021 ZeeZide GmbH. All rights reserved.
//

#if canImport(AWSLambdaEvents)
import struct NIOHTTP1.HTTPRequestHead
import struct NIOHTTP1.HTTPVersion
import enum   NIOHTTP1.HTTPMethod
import struct NIOHTTP1.HTTPHeaders
import enum   NIOHTTP1.HTTPResponseStatus

import struct AWSLambdaEvents.HTTPMethod
import struct AWSLambdaEvents.HTTPHeaders
import struct AWSLambdaEvents.HTTPMultiValueHeaders
import struct AWSLambdaEvents.HTTPResponseStatus

internal extension AWSLambdaEvents.HTTPMethod {
  
  @inlinable
  var asNIO: NIOHTTP1.HTTPMethod {
    switch self {
      case .GET     : return .GET
      case .POST    : return .POST
      case .PUT     : return .PUT
      case .PATCH   : return .PATCH
      case .DELETE  : return .DELETE
      case .OPTIONS : return .OPTIONS
      case .HEAD    : return .HEAD
      default       : return .RAW(value: rawValue)
    }
  }
}

internal extension AWSLambdaEvents.HTTPHeaders {
  
  @inlinable
  var asNIO: NIOHTTP1.HTTPHeaders {
    get {
      var headers = NIOHTTP1.HTTPHeaders()
      for ( name, value ) in self {
        headers.add(name: name, value: value)
      }
      return headers
    }
  }
}

internal extension AWSLambdaEvents.HTTPMultiValueHeaders {
  
  @inlinable
  var asNIO: NIOHTTP1.HTTPHeaders {
    set {
      for ( name, value ) in newValue {
        self[name, default: []].append(value)
      }
    }
    get {
      var headers = NIOHTTP1.HTTPHeaders()
      for ( name, values ) in self {
        for value in values {
          headers.add(name: name, value: value)
        }
      }
      return headers
    }
  }
}

internal extension NIOHTTP1.HTTPHeaders {
  
  @inlinable
  func asLambda() -> ( headers : AWSLambdaEvents.HTTPHeaders?,
                       cookies : [ String ]? )
  {
    guard !isEmpty else { return ( nil, nil ) }
    
    // Those do no proper CI, lets hope they are consistent
    var headers = AWSLambdaEvents.HTTPHeaders()
    var cookies = [ String ]()
    headers.reserveCapacity(headers.count)
    
    // Schnüff, we don't get NIO's `compareCaseInsensitiveASCIIBytes`
    for ( name, value ) in self {
      // This is all not good. But neither is the JSON gateway :-)
      if name.caseInsensitiveCompare("Set-Cookie") == .orderedSame ||
         name.caseInsensitiveCompare("Cookie")     == .orderedSame
      {
        cookies.append(value)
      }
      else {
        if let existing = headers.removeValue(forKey: name) {
          // Don't know, SwiftLambda 0.4 dropped the multiheaders? What should
          // we do for dupes?
          if      value   .isEmpty {}
          else if existing.isEmpty { headers[name] = value }
          else                     { headers[name] = existing + ", " + value }
        }
        else {
          headers[name] = value
        }
      }
    }

    return ( headers : headers.isEmpty ? nil : headers,
             cookies : cookies.isEmpty ? nil : cookies )
  }
}

internal extension NIOHTTP1.HTTPResponseStatus {

  @inlinable
  var asLambda : AWSLambdaEvents.HTTPResponseStatus { // why, o why
    return .init(code: UInt(code), reasonPhrase: reasonPhrase)
  }
}

internal extension AWSLambdaEvents.HTTPResponseStatus {
  
  @inlinable
  var asNIO : NIOHTTP1.HTTPResponseStatus { // why, o why
    return .init(statusCode: Int(code),
                 reasonPhrase: reasonPhrase ?? "HTTP Status \(code)")
  }
}
#endif // canImport(AWSLambdaEvents)

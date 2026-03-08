//
//  LambdaNIOConversions.swift
//  MacroLambda
//
//  Created by Helge Heß
//  Copyright © 2020-2026 ZeeZide GmbH. All rights reserved.
//

#if canImport(AWSLambdaEvents)
#if canImport(Foundation)
import Foundation // orderedSame (FIXME)
#endif

import struct NIOHTTP1.HTTPRequestHead
import struct NIOHTTP1.HTTPVersion
import enum   NIOHTTP1.HTTPMethod
import struct NIOHTTP1.HTTPHeaders
import enum   NIOHTTP1.HTTPResponseStatus

import HTTPTypes

internal extension HTTPRequest.Method {

  @inlinable
  var asNIO: NIOHTTP1.HTTPMethod {
    switch self {
      case .get     : return .GET
      case .post    : return .POST
      case .put     : return .PUT
      case .patch   : return .PATCH
      case .delete  : return .DELETE
      case .options : return .OPTIONS
      case .head    : return .HEAD
      default       : return .RAW(value: rawValue)
    }
  }
}

internal extension Dictionary where Key == String, Value == String {

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

internal extension NIOHTTP1.HTTPHeaders {

  @inlinable
  func asLambda() -> ( headers : [ String : String ]?,
                       cookies : [ String ]? )
  {
    guard !isEmpty else { return ( nil, nil ) }

    // Those do no proper CI, lets hope they are consistent
    var headers = [ String : String ]()
    var cookies = [ String ]()

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
          // Don't know, SwiftLambda 0.4 dropped the multiheaders? What
          // should we do for dupes?
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
  var asLambda : HTTPResponse.Status {
    return .init(code: Int(code))
  }
}

internal extension HTTPResponse.Status {

  @inlinable
  var asNIO : NIOHTTP1.HTTPResponseStatus {
    return .init(statusCode: code)
  }
}
#endif // canImport(AWSLambdaEvents)

//
//  LambdaRequest.swift
//  MacroLambda
//
//  Created by Helge Heß
//  Copyright © 2020-2026 ZeeZide GmbH. All rights reserved.
//

#if canImport(AWSLambdaEvents)

import struct   Logging.Logger
import struct   NIOHTTP1.HTTPRequestHead
import struct   AWSLambdaEvents.APIGatewayV2Request
import struct   MacroCore.Buffer
import protocol MacroCore.EnvironmentKey
import class    http.IncomingMessage

public extension IncomingMessage {

  convenience init(lambdaRequest : APIGatewayV2Request,
                   log           : Logger = .init(label: "μ.http"))
  {
    // version doesn't matter, we don't really do HTTP
    var head = HTTPRequestHead(
      version : .init(major: 1, minor: 1),
      method  : lambdaRequest.context.http.method.asNIO,
      uri     : lambdaRequest.context.http.path
    )
    head.headers = lambdaRequest.headers.asNIO

    if !lambdaRequest.cookies.isEmpty {
      // So our "connect" module expects them in the headers, so we'd need
      // to serialize them again ...
      // The `IncomingMessage` also has a `cookies` getter, but I think that
      // isn't cached.
      for cookie in lambdaRequest.cookies { // that is weird too, is it right?
        head.headers.add(name: "Cookie", value: cookie)
      }
    }

    // TBD: there is also "pathParameters", what is that, URL fragments (#)?
    if !lambdaRequest.pathParameters.isEmpty {
      log.warning("ignoring lambda path parameters: \(lambdaRequest.pathParameters)")
    }

    if !lambdaRequest.queryStringParameters.isEmpty {
      // TBD: is that included in the path?
      var isFirst = false
      if !head.uri.contains("?") { head.uri.append("?"); isFirst = true }
      for ( key, value ) in lambdaRequest.queryStringParameters {
        if isFirst { isFirst = false }
        else { head.uri += "&" }

        head.uri +=
          key.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? key
        head.uri += "="
        head.uri +=
          value.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? value
      }
    }

    self.init(head, socket: nil, log: log)
    
    // and keep the whole thing
    lambdaGatewayRequest = lambdaRequest
  }

  internal func sendLambdaBody(_ lambdaRequest: APIGatewayV2Request) {
    defer { push(nil) }
    
    guard let body = lambdaRequest.body else { return }
    do {
      if lambdaRequest.isBase64Encoded {
        push(try Buffer.from(body, "base64"))
      }
      else {
        push(try Buffer.from(body))
      }
    }
    catch {
      emit(error: error)
    }
  }
}


enum LambdaRequestKey: EnvironmentKey {

  static let defaultValue : APIGatewayV2Request? = nil
  static let loggingKey   = "lambda-request"
}

public extension IncomingMessage {

  var lambdaGatewayRequest: APIGatewayV2Request? {
    set { environment[LambdaRequestKey.self] = newValue }
    get { return environment[LambdaRequestKey.self] }
  }
}
#endif // canImport(AWSLambdaEvents)

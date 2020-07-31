//
//  ReExports.swift
//  MacroLambda
//
//  Created by Helge Heß
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda

public extension Lambda {
  
  static func run(_ middleware: MiddlewareObject) -> Never {
    let server = lambda.createServer(handler: middleware.requestHandler)
    _ = server.run()
  }
}

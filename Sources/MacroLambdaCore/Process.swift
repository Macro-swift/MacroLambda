//
//  lambda.swift
//  MacroLambda
//
//  Created by Helge Heß
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import let  xsys.getenv
import enum MacroCore.process

public extension process {

  #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(Windows)
    /**
     * Returns true if the server is running in an actual AWS Lambda
     * environment. (I.e. never true on macOS/iOS/etc)
     */
    static let isRunningInLambda = false
  #else
    /**
     * Returns true if the server is running in an actual AWS Lambda
     * environment. (I.e. never true on macOS/iOS/etc)
     */
    static let isRunningInLambda : Bool = {
      guard let s = xsys.getenv("AWS_LAMBDA_FUNCTION_NAME") else {
        return false
      }
      return s[0] != 0
    }()
  #endif
}

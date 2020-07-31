//
//  ReExports.swift
//  MacroLambda
//
//  Created by Helge Heß
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

@_exported import MacroCore
@_exported import MacroExpress

import enum MacroLambdaCore.lambda
public typealias lambda = MacroLambdaCore.lambda

import enum AWSLambdaRuntime.Lambda
public typealias Lambda = AWSLambdaRuntime.Lambda

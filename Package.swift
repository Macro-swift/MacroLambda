// swift-tools-version:5.2

import PackageDescription

let package = Package(
  
  name: "MacroLambda",
  
  platforms : [ .macOS(.v10_13) ], // drop once #152 is fixed in the runtime
  
  products: [
    .library(name: "MacroLambdaCore", targets: [ "MacroLambdaCore" ]),
    .library(name: "MacroLambda",     targets: [ "MacroLambda"     ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Macro-swift/Macro.git",
             from: "0.6.2"),
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.6.1"),
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
             .upToNextMajor(from:"0.3.0"))
  ],
  
  targets: [
    .target(name: "MacroLambdaCore", dependencies: [
      .product(name: "MacroCore"        , package: "Macro"),
      .product(name: "http"             , package: "Macro"),
      .product(name: "express"          , package: "MacroExpress"),
      .product(name: "AWSLambdaRuntime" , package: "swift-aws-lambda-runtime"),
      .product(name: "AWSLambdaEvents"  , package: "swift-aws-lambda-runtime")
    ]),
    .target(name: "MacroLambda", dependencies: [
      "MacroLambdaCore",
      .product(name: "AWSLambdaRuntime" , package: "swift-aws-lambda-runtime"),
      "MacroExpress"
    ])
  ]
)

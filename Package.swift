// swift-tools-version:5.2

import PackageDescription

let package = Package(
  
  name: "MacroLambda",
  
  products: [
    .library(name: "MacroLambdaCore", targets: [ "MacroLambdaCore" ]),
    .library(name: "MacroLambda",     targets: [ "MacroLambda"     ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Macro-swift/Macro.git",
             from: "0.8.7"),
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.8.4"),
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

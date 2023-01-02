// swift-tools-version:5.5

import PackageDescription

let package = Package(
  
  name: "MacroLambda",
  
  products: [
    .library(name: "MacroLambdaCore", targets: [ "MacroLambdaCore" ]),
    .library(name: "MacroLambda",     targets: [ "MacroLambda"     ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Macro-swift/Macro.git",
             from: "1.0.0"),
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "1.0.0"),
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
             from: "0.5.2")
  ],
  
  targets: [
    .target(name: "MacroLambdaCore", dependencies: [
      .product(name: "MacroCore"        , package: "Macro"),
      .product(name: "http"             , package: "Macro"),
      .product(name: "express"          , package: "MacroExpress"),
      .product(name: "AWSLambdaRuntime" , package: "swift-aws-lambda-runtime"),
      .product(name: "AWSLambdaEvents"  , package: "swift-aws-lambda-runtime")
    ],
    exclude: [
      "README.md"
    ]),
    .target(name: "MacroLambda", dependencies: [
      "MacroLambdaCore",
      .product(name: "AWSLambdaRuntime" , package: "swift-aws-lambda-runtime"),
      "MacroExpress"
    ])
  ]
)

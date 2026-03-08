// swift-tools-version:6.0

import PackageDescription

let package = Package(
  
  name: "MacroLambda",

  platforms: [ .macOS(.v15), .iOS(.v18) ],

  products: [
    .library(name: "MacroLambdaCore", targets: [ "MacroLambdaCore" ]),
    .library(name: "MacroLambda",     targets: [ "MacroLambda"     ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Macro-swift/Macro.git",
             from: "1.0.22"),
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "1.0.26"),
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
             from: "2.0.0"),
    .package(url: "https://github.com/swift-server/swift-aws-lambda-events.git",
             from: "1.0.0")
  ],
  
  targets: [
    .target(name: "MacroLambdaCore", dependencies: [
      .product(name: "MacroCore",        package: "Macro"),
      .product(name: "http",             package: "Macro"),
      .product(name: "express",          package: "MacroExpress"),
      .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
      .product(name: "AWSLambdaEvents",  package: "swift-aws-lambda-events")
    ],
    exclude: [
      "README.md"
    ]),
    .target(name: "MacroLambda", dependencies: [
      "MacroLambdaCore",
      "MacroExpress",
      .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
    ])
  ]
)

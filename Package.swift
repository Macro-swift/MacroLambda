// swift-tools-version:5.0

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
             from: "0.5.5"),
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.5.4"),
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
             .upToNextMajor(from:"0.2.0"))
  ],
  
  targets: [
    .target(name: "MacroLambdaCore", 
            dependencies: [ "MacroCore", "http",
                            "AWSLambdaRuntime", "AWSLambdaEvents" ]),
    .target(name: "MacroLambda",     
            dependencies: [ "MacroLambdaCore", "AWSLambdaRuntime",
                            "MacroExpress" ])
  ]
)

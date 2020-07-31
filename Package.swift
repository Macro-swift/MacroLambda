// swift-tools-version:5.0

import PackageDescription

let dependencies : [ PackageDescription.Package.Dependency ] = [
  .package(url: "https://github.com/Macro-swift/Macro.git",
           from: "0.5.4"),
  .package(url: "https://github.com/Macro-swift/MacroExpress.git",
           from: "0.5.3"),
  .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
           .upToNextMajor(from:"0.2.0"))
]

let platforms         : [ Platform           ]
let extraDependencies : [ PackageDescription.Package.Dependency ]
let extraTargetDeps   : [ PackageDescription.Target.Dependency  ]
if #available(macOS 10.15, iOS 13, *) {
  platforms = [ .macOS(.v10_15) ]
  extraDependencies = [
    .package(url: "https://github.com/Macro-swift/MacroApp.git", from: "0.5.0")
  ]
  extraTargetDeps = [ "MacroApp" ]
}
else {
  platforms = [ .macOS(.v10_13) ] // drop once #152 is fixed in the runtime
  extraDependencies = []
  extraTargetDeps   = []
}

let targets : [ PackageDescription.Target ] = [
  .target(name: "MacroLambdaCore",
          dependencies: [ "MacroCore", "http",
                          "AWSLambdaRuntime", "AWSLambdaEvents" ]),
  .target(name: "MacroLambda",
          dependencies: [ "MacroLambdaCore", "AWSLambdaRuntime",
                          "MacroExpress" ] + extraTargetDeps)
]

let package = Package(
  
  name: "MacroLambda",
  
  platforms : [ .macOS(.v10_13) ], // drop once #152 is fixed in the runtime
  
  products: [
    .library(name: "MacroLambdaCore", targets: [ "MacroLambdaCore" ]),
    .library(name: "MacroLambda",     targets: [ "MacroLambda"     ])
  ],
  
  dependencies : dependencies + extraDependencies,
  targets      : targets
)

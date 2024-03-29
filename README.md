<h2>MacroLambda
  <img src="http://zeezide.com/img/macro/MacroExpressIcon128.png"
       align="right" width="100" height="100" />
</h2>

AWS Lambda [API Gateway](https://aws.amazon.com/api-gateway/)
Support for Macro and MacroExpress
(and all things built on-top).

It allows deployment of arbitrary Macro applications as AWS Lambda functions,
including MacroApp endpoints.

Blog article: [Deploying Swift on AWS Lambda](http://www.alwaysrightinstitute.com/macrolambda/).

The module is split into the `MacroLambda` module, 
which provides the Express runner (`Lambda.run(express-app)`)
and `MacroLambdaCore` which only links against `http` and provides the 
`lambda.createServer` (the peer to `http.createServer`).

There is a tutorial on getting started with those things:
[Create your first HTTP endpoint with Swift on AWS Lambda](https://fabianfett.de/swift-on-aws-lambda-creating-your-first-http-endpoint).

Note: The Swift Lambda Runtime requires Swift 5.2.

## Example

```swift
import MacroLambda

let app = Express()

app.use(bodyParser.text())

app.post("/hello") { req, res, next in
  console.log("Client posted:", req.body.text ?? "-")
  res.send("Client body sent: \(req.body.text ?? "~nothing~")")
}

app.get { req, res, next in
  res.send("Welcome to Macro!")
}

Lambda.run(app)
```

## Deployment

Using `swift lambda` (`brew install SPMDestinations/tap/swift-lambda`):
```
$ swift lambda deploy -d 5.2
```
Tutorial available: [Deploying Swift on AWS Lambda](http://www.alwaysrightinstitute.com/macrolambda/).

## Environment Variables

- `macro.core.numthreads`
- `macro.core.iothreads`
- `macro.core.retain.debug`
- `macro.concat.maxsize`
- `macro.streams.debug.rc`

### Links

- [Deploying Swift on AWS Lambda](http://www.alwaysrightinstitute.com/macrolambda/)
- WWDC 2020: [Use Swift on AWS Lambda with Xcode](https://developer.apple.com/videos/play/wwdc2020/10644/)
- Tutorial: [Create your first HTTP endpoint with Swift on AWS Lambda](https://fabianfett.de/swift-on-aws-lambda-creating-your-first-http-endpoint)
- [Swift AWS Lambda Runtime](https://github.com/swift-server/swift-aws-lambda-runtime)
- Amazon Web Services [API Gateway](https://aws.amazon.com/api-gateway/)
- [µExpress](http://www.alwaysrightinstitute.com/microexpress-nio2/)
- [SwiftNIO](https://github.com/apple/swift-nio)

### Who

**Macro** is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

There is a `#microexpress` channel on the 
[Noze.io Slack](http://slack.noze.io/). Feel free to join!

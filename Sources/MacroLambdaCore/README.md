# Macro http.lambda

The files within simulate `http.createServer` but for AWS Lambda functions
addressed using the
AWS [API Gateway](https://aws.amazon.com/api-gateway/) V2.

Tutorial:
[Create your first HTTP endpoint with Swift on AWS Lambda](https://fabianfett.de/swift-on-aws-lambda-creating-your-first-http-endpoint))

Requests are regular `IncomingMessage` objects, responses are regular
`ServerResponse` objects.

Requests carry the additional `lambdaGatewayRequest` property to provide
access to the full Lambda JSON structure.

## Example

```swift
let server = lambda.createServer { req, res in
  req.log.info("request arrived in Macro land: \(req.url)")
  res.send("Hello You!")
}
server.run()
```

Note that the `run` function never returns.

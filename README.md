
# NetworkKit

## Introduction

NetworkKit is a lightweight and efficient Swift package for network management. Designed specifically to simplify network calls in Swift applications, it encapsulates the complexities of `URLSession` and provides a clear, concise interface for making HTTP requests.

## Features

- Easy to use and configure.
- Support for common HTTP methods (GET, POST, etc.).
- Includes a robust framework for unit testing.
- Fully compatible with Swift Concurrency.

## Requirements

- iOS 16.0+
- Swift 5.0+

## Installation

### Swift Package Manager

You can install NetworkKit using the Swift Package Manager by adding the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "NetworkKit", from: "1.0.0")
]
```

## Usage

First, import NetworkKit in the file where you want to use it:

```swift
import NetworkKit
```

### Making a Request

To make a network request, create an instance of `NetworkService` and use the `request` method. For example, to fetch popular movies:

```swift
let networkService = NetworkService<YourAPIEndpoint>()
let result = try await networkService.request(ofType: YourResponseType.self, .yourEndpoint)
```

Replace `YourAPIEndpoint`, `YourResponseType`, and `.yourEndpoint` as necessary to fit your API.

## Tests

NetworkKit comes with a suite of unit tests to ensure the reliability and stability of the package. The tests use `XCTest` and a mock system to simulate network responses.

To run the tests, open the project in Xcode and run the test scheme.

## Contribution

Contributions are always welcome! If you wish to contribute, feel free to open a pull request or create an issue.

## License

NetworkKit is available under the MIT license. See the LICENSE file for more information.

[![Build Status](https://app.bitrise.io/app/e92e109959b2fd4a/status.svg?token=RK3sadyzv8puC80GhNLq3w&branch=develop)](https://app.bitrise.io/app/e92e109959b2fd4a)

C0T0 - simple networking library for iOS based on NSURLSession 
## Installation

### CocoaPods

To integrate C0T0 into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<target name>' do
  pod 'C0T0', '~> 0.1.0'
end

```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Making a simple GET request

Create an object of `SessionConfiguration` with specified host.

If you're interested in logging requests, responses and errors, just enable logging in `SessionConfiguration` `init` method. By default logging is disable (also the default value is set so you can skip it in init method).

```swift 
    private let sessionConfiguration = SessionConfiguration(
                                           host: "https://api.github.com",
                                           loggingEnabled: true
                                       )
```

Next create instance of `ApiService`
```swift
    private lazy var apiService = ApiService(configuration: sessionConfiguration)
```

Remember to retain the `apiService` object instead of creating local variable inside a function's scope, otherwise your object may be released before the response will be received.

Here's an example of `requestRepositories(for:)` function with setting repositories array for success or showing the error alert in case of failure. For parsing the results we're using `Codable` models. So for the `Result` you have to provide a generic type which is conforming to `Codable` protocol.

```swift
private func requestRepositories(for organization: String) {
        let apiRequest = ApiRequest(endpoint: "/orgs/\(organization)/repos", method: .GET)
        
        apiService.send(request: apiRequest) { [weak self] (result: Result<[Repository], ApiError>) in
            result.ifSuccess { repositories in
                self?.repositories = repositories
            }.else(closure: { error in
                DispatchQueue.main.async {
                    self?.showAlertWith(error)
                }
            })
        }
    }
```

### URL encoded parameters

If your request needs an URL encoded parameters just create the request like below: 
```swift
        let apiRequest = ApiRequest(
                             endpoint: "/endpoint",
                             method: .GET, 
                             urlParameters: ["sampleKey": "sampleValue"]
                         )
```

### Making a POST request with headers

If your request needs JSON encoded parameters you can achieve that in that way:

```swift
        let postJSON = """
                        {
                            "name": "ToopLoox team member"
                            "job" : "iOS Developer"
                        }
                        """
        let postJSONData = postJSON.data(using: .utf8)
        let apiRequest = ApiRequest(
                             endpoint: "/users",
                             method: .POST,
                             httpBody: postJSONData,
                             headers: ["Content-Type": "application/json"]
                         )
       
```

### Download content

`ApiService` also supports downloading. 

```swift
        apiService.download(from: url) { (result: Result<Data, ApiError>) in
            result.ifSuccess(closure: { data in
                // Your's code goes here
            })
        }
```

### Sample project

Sample project is included in this repository, just type `pod install` and you're ready to run it.


### Tests

Tests covering the code are included in Example Project

### License
C0T0 is released under the MIT license. See [LICENSE](../master/LICENSE) for details.

//
// Created by Karol on 07.09.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Quick
import Nimble
@testable import Networking

class StandardURLRequestSenderTests: QuickSpec {

    override func spec() {
        describe("StandardURLRequestSender") {
            var urlSessionMock: URLSessionMock!
            var sut: StandardURLRequestSender!

            beforeEach {
                urlSessionMock = URLSessionMock()
                sut = StandardURLRequestSender(urlSession: urlSessionMock)
            }

            context("when request is MockData.request ") {
                context("and response status code is 200") {
                    it("returns data") {
                        let response = HTTPURLResponse(url: MockData.url, statusCode: 200, httpVersion: nil, headerFields: nil)
                        urlSessionMock.dataTaskWithRequestReturnedValue = (MockData.data, response, nil)

                        var returnedData: Data!
                        var returnedError: URLRequestSenderError!
                        sut.send(urlRequest: MockData.request) { data, error in
                            returnedData = data
                            returnedError = error
                        }

                        expect(returnedData).toEventually(equal(MockData.data))
                        expect(returnedError).toEventually(beNil())
                    }
                }

                context("and response status code is not success") {
                    it("returns authorization error") {
                        let response = HTTPURLResponse(url: MockData.url, statusCode: 404, httpVersion: nil, headerFields: nil)
                        urlSessionMock.dataTaskWithRequestReturnedValue = (nil, response, nil)

                        var returnedData: Data!
                        var returnedError: URLRequestSenderError!
                        sut.send(urlRequest: MockData.request) { data, error in
                            returnedData = data
                            returnedError = error
                        }

                        expect(returnedData).toEventually(beNil())
                        expect(returnedError).toEventually(equal(URLRequestSenderError.http(404)))
                    }
                }

                context("and response is error") {
                    it("returns network error") {
                        let error = NSError(domain: "TestError", code: 111)
                        urlSessionMock.dataTaskWithRequestReturnedValue = (nil, nil, error)

                        var returnedData: Data!
                        var returnedError: URLRequestSenderError!
                        sut.send(urlRequest: MockData.request) { data, error in
                            returnedData = data
                            returnedError = error
                        }

                        expect(returnedData).toEventually(beNil())
                        expect(returnedError).toEventually(equal(URLRequestSenderError.network(error)))
                    }
                }
            }

            context("when url is MockData.url") {
                context("and response status code is 200") {
                    it("returns data") {
                        let response = HTTPURLResponse(url: MockData.url, statusCode: 200, httpVersion: nil, headerFields: nil)
                        urlSessionMock.dataTaskWithUrlReturnedValue = (MockData.data, response, nil)

                        var returnedData: Data!
                        var returnedError: URLRequestSenderError!
                        sut.download(url: MockData.url) { data, error in
                            returnedData = data
                            returnedError = error
                        }

                        expect(returnedData).toEventually(equal(MockData.data))
                        expect(returnedError).toEventually(beNil())
                    }
                }

                context("and response status code is not success") {
                    it("returns authorization error") {
                        let response = HTTPURLResponse(url: MockData.url, statusCode: 404, httpVersion: nil, headerFields: nil)
                        urlSessionMock.dataTaskWithUrlReturnedValue = (nil, response, nil)

                        var returnedData: Data!
                        var returnedError: URLRequestSenderError!
                        sut.download(url: MockData.url) { data, error in
                            returnedData = data
                            returnedError = error
                        }

                        expect(returnedData).toEventually(beNil())
                        expect(returnedError).toEventually(equal(URLRequestSenderError.http(404)))
                    }
                }

                context("and response is error") {
                    it("returns network error") {
                        let error = NSError(domain: "TestError", code: 111)
                        urlSessionMock.dataTaskWithUrlReturnedValue = (nil, nil, error)

                        var returnedData: Data!
                        var returnedError: URLRequestSenderError!
                        sut.download(url: MockData.url) { data, error in
                            returnedData = data
                            returnedError = error
                        }

                        expect(returnedData).toEventually(beNil())
                        expect(returnedError).toEventually(equal(URLRequestSenderError.network(error)))
                    }
                }
            }
        }
    }
}

private class URLSessionMock: URLSessionProtocol {

    var dataTaskWithRequestReturnedValue: (Data?, URLResponse?, Error?)!
    var dataTaskWithUrlReturnedValue: (Data?, URLResponse?, Error?)!

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask {
        completionHandler(
            dataTaskWithRequestReturnedValue.0,
            dataTaskWithRequestReturnedValue.1,
            dataTaskWithRequestReturnedValue.2
        )
        return URLSessionDataTaskMock()
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask {
        completionHandler(
            dataTaskWithUrlReturnedValue.0,
            dataTaskWithUrlReturnedValue.1,
            dataTaskWithUrlReturnedValue.2
        )
        return URLSessionDataTaskMock()
    }
}

private class URLSessionDataTaskMock: URLSessionDataTask {
    override func resume() {
        // do nothing, it's just a mock
    }
}

private class MockData {
    static let data = "Test".data(using: .utf8)
    static let url = URL(string: "example.com")!
    static let request = URLRequest(url: MockData.url)

}

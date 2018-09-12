//
// Created by Karol on 10.09.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import C0T0

class URLSessionApiDataSourceTests: QuickSpec {

    override func spec() {
        describe("URLSessionApiDataSource") {

            var builder: URLRequestBuilderMock!
            var sender: URLRequestSenderMock!
            var errorConverter: URLRequestSenderErrorConverterMock!
            var sut: URLSessionApiDataSource!

            var returnedResult: Result<MockModel, ApiError>!
            var returnedDownloadResult: Result<Data, ApiError>!

            beforeEach {
                builder = URLRequestBuilderMock()
                sender = URLRequestSenderMock()
                errorConverter = URLRequestSenderErrorConverterMock()
                sut = URLSessionApiDataSource(
                    urlRequestBuilder: builder,
                    urlRequestSender: sender,
                    converter: errorConverter,
                    configuration: ApiDataSourceConfiguration()
                )
                returnedResult = nil
            }

            context("when input request is MockData.urlRequest") {

                beforeEach {
                    builder.returnedRequest = MockData.urlRequest
                }
                
                context("and sender returns MockData.senderError") {

                    beforeEach {
                        sender.returnedSendData = (nil, MockData.senderError)
                    }

                    context("and error converter returns MockData.convertedSenderError") {

                        beforeEach {
                            errorConverter.returnedError = MockData.convertedSenderError
                            sut.send(request: MockData.apiRequest) { (result: Result<MockModel, ApiError>) in
                                returnedResult = result
                            }
                        }

                        it("passes request to request builder") {
                            expect(builder.inputRequest).toEventually(equal(MockData.apiRequest))
                            expect(builder.invocationCounter).toEventually(equal(1))
                        }

                        it("passes MockData.urlRequest to sender") {
                            expect(sender.inputSendRequest).toEventually(equal(MockData.urlRequest))
                            expect(sender.sendInvocationCounter).toEventually(equal(1))
                        }

                        it("passes error to error converter") {
                            expect(errorConverter.inputError).toEventually(equal(MockData.senderError))
                            expect(errorConverter.invocationCounter).toEventually(equal(1))
                        }

                        it("send method returns error") {
                            expect(returnedResult.error).toEventually(equal(MockData.convertedSenderError))
                        }

                    }
                }

                context("and sender returns MockData.senderJSONData") {

                    beforeEach {
                        sender.returnedSendData = (MockData.senderJSONData, nil)
                        sut.send(request: MockData.apiRequest) { (result: Result<MockModel, ApiError>) in
                            returnedResult = result
                        }
                    }

                    it("returns MockData.parsedJSONObject") {
                        expect(returnedResult.value).toEventually(equal(MockData.parsedJSONObject))
                    }
                }

                context("and sender returns MockData.senderInvalidJSONData") {

                    beforeEach {
                        sender.returnedSendData = (MockData.senderInvalidJSONData, nil)
                        sut.send(request: MockData.apiRequest) { (result: Result<MockModel, ApiError>) in
                            returnedResult = result
                        }
                    }

                    it("returns ApiError.cannotParseData") {
                        expect(returnedResult.error).toEventually(equal(MockData.invalidJSONError))
                    }
                }
            }

            context("when input url is MockData.url") {

                context("when sender returns MockData.senderError") {

                    beforeEach {
                        sender.returnedDownloadData = (nil, MockData.senderError)
                    }

                    context("and error converter returns MockData.convertedSenderError") {

                        beforeEach {
                            errorConverter.returnedError = MockData.convertedSenderError

                            sut.download(fromURL: MockData.url) { result in
                                returnedDownloadResult = result
                            }
                        }

                        it("returns MockData.convertedSenderError") {
                            expect(returnedDownloadResult.error).toEventually(equal(MockData.convertedSenderError))
                        }
                    }
                }
                
                context("and sender returns downloaded MockData.senderJSONData") {
                    beforeEach {
                        sender.returnedDownloadData = (MockData.senderJSONData, nil)
                        sut.download(fromURL: MockData.url, completion: { (result: Result<Data, ApiError>) in
                            returnedDownloadResult = result
                        })
                    }
                    
                    it("returns MockData.downloaderData") {
                        expect(returnedDownloadResult.value).toEventually(equal(MockData.senderJSONData))
                    }
                }
            }
        }
    }
}

private struct MockData {
    static let urlString = "example.com"
    static let url = URL(string: urlString)!
    static let apiRequest = ApiRequest(endpoint: urlString, method: .GET)
    static let urlRequest = URLRequest(url: url)
    static let senderError = URLRequestSenderError.http(404)
    static let senderJSONData = "{\"id\": 1}".data(using: .utf8)
    static let senderInvalidJSONData = "{\"id\"}".data(using: .utf8)
    static let convertedSenderError = ApiError.http(404)
    static let parsedJSONObject = MockModel(id: 1)
    static let invalidJSONError = ApiError.cannotParseData("The data couldn’t be read because it isn’t in the correct format.")
}

private class URLRequestBuilderMock: URLRequestBuilder {

    var inputRequest: ApiRequest!
    var invocationCounter = 0

    var returnedRequest: URLRequest!

    func build(from request: ApiRequest) -> URLRequest? {
        inputRequest = request
        invocationCounter += 1
        return returnedRequest
    }
}

private class URLRequestSenderMock: URLRequestSender {

    var inputSendRequest: URLRequest!
    var sendInvocationCounter = 0
    var returnedSendData: (Data?, URLRequestSenderError?)!

    var inputDownloadURL: URL!
    var downloadInvocationCunter = 0
    var returnedDownloadData: (Data?, URLRequestSenderError?)!

    func send(urlRequest: URLRequest, completion: @escaping (Data?, URLRequestSenderError?) -> Void) {
        inputSendRequest = urlRequest
        sendInvocationCounter += 1
        completion(returnedSendData.0, returnedSendData.1)
    }

    func download(url: URL, completion: @escaping (Data?, URLRequestSenderError?) -> Void) {
        inputDownloadURL = url
        downloadInvocationCunter += 1
        completion(returnedDownloadData.0, returnedDownloadData.1)
    }
}

private class URLRequestSenderErrorConverterMock: URLRequestSenderErrorConverter {

    var inputError: URLRequestSenderError!
    var invocationCounter = 0

    var returnedError: ApiError!

    func convert(urlSessionSenderError: URLRequestSenderError) -> ApiError {
        inputError = urlSessionSenderError
        invocationCounter += 1
        return returnedError
    }
}

struct MockModel: Decodable, Equatable {
    let id: Int
}

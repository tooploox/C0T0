//
//  SenderTests.swift
//  NetworkingExampleTests
//
//  Created by Paweł Chmiel on 11.09.2018.
//  Copyright © 2018 Tooploox. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Networking

class SenderTests: QuickSpec {
    override func spec() {
        describe("Sender") {
            var apiRequest: ApiRequest!
            var sut: ApiService.Sender!
            var apiDataSourceMock: ApiDataSourceMock!
            
            context("when api request is mock api request and the send method is called") {
                context("number of retries is taken from standard configuration") {
                    beforeEach {
                        apiRequest = ApiRequest(endpoint: "", method: .GET)
                        apiDataSourceMock = ApiDataSourceMock()
                        apiDataSourceMock.returnedResult = .failure(.network)
                        sut = ApiService.Sender(apiDataSource: apiDataSourceMock, requestDecorator: { $0 })
                        sut.send(request: apiRequest, configuration: RequestConfiguration.standard, completion: { (result: Result<MockModel, ApiError>) in })
                    }
                
                    it("pass the request and will be called once") {
                        expect(apiDataSourceMock.inputRequest).to(equal(apiRequest))
                        expect(apiDataSourceMock.sendInvocationCounter).to(equal(1))
                    }
                }
                
                context("and number of retries from MockData for network error") {
                    beforeEach {
                        apiRequest = ApiRequest(endpoint: "", method: .GET)
                        apiDataSourceMock = ApiDataSourceMock()
                        apiDataSourceMock.returnedResult = .failure(.network)
                        sut = ApiService.Sender(apiDataSource: apiDataSourceMock, requestDecorator: { $0 })
                        
                        sut.send(request: apiRequest, configuration: RequestConfiguration(numberOfRetries: MockData.numberOfRetries), completion: { (result: Result<MockModel, ApiError>) in })
                    }
                    
                    it("invocation counter value is equal to MockData.numberOfRetries + first invocation") {
                        expect(apiDataSourceMock.sendInvocationCounter).to(equal(MockData.numberOfRetries + 1))
                    }
                }
                
                context("number of retries from MockData will be ignored due to parseError") {
                    beforeEach {
                        apiRequest = ApiRequest(endpoint: "", method: .GET)
                        apiDataSourceMock = ApiDataSourceMock()
                        apiDataSourceMock.returnedResult = .failure(.cannotParseData(""))
                        sut = ApiService.Sender(apiDataSource: apiDataSourceMock, requestDecorator: { $0 })
                        
                        sut.send(request: apiRequest, configuration: RequestConfiguration(numberOfRetries: MockData.numberOfRetries), completion: { (result: Result<MockModel, ApiError>) in })
                    }
                    
                    it("invocation counter value is equal 1") {
                        expect(apiDataSourceMock.sendInvocationCounter).to(equal(1))
                    }
                }
            }
        }
    }
}

private class ApiDataSourceMock: ApiDataSource {
    private(set) var sendInvocationCounter = 0
    private(set) var inputRequest: ApiRequest!
    var returnedResult: Result<MockModel, ApiError>!
    
    func send<T:Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        inputRequest = request
        sendInvocationCounter += 1
        completion(returnedResult as! Result<T,ApiError>)
    }
    
    func download(fromURL url: URL, completion: @escaping(Result<Data, ApiError>) -> Void) {}
}

private struct MockData {
    static let numberOfRetries = 5
}



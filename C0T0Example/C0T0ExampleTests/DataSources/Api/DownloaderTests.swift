//
//  DownloaderTests.swift
//  NetworkingExampleTests
//
//  Created by Paweł Chmiel on 11.09.2018.
//  Copyright © 2018 Tooploox. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import C0T0

class DownloaderTests: QuickSpec {
    override func spec() {
        describe("Downloader") {
            var apiURL: URL!
            var sut: ApiService.Downloader!
            var apiDataSourceMock: ApiDataSourceMock!
            
            context("when api request is mock api request and the download method is called") {
                context("number of retries is taken from standard configuration") {
                    beforeEach {
                        apiURL = URL(string: "https://example.com")
                        apiDataSourceMock = ApiDataSourceMock()
                        apiDataSourceMock.returnedResult = .failure(.network)
                        sut = ApiService.Downloader(apiDataSource: apiDataSourceMock)
                        sut.download(fromURL: apiURL, configuration: RequestConfiguration.standard, completion: { (result: Result<Data, ApiError>) in })
                    }
                    
                    it("pass the request and will be called once") {
                        expect(apiDataSourceMock.inputURL).to(equal(apiURL))
                        expect(apiDataSourceMock.downloadInvocationCounter).to(equal(1))
                    }
                }
                
                context("and number of retries from MockData for network error") {
                    beforeEach {
                        apiURL = URL(string: "https://example.com")
                        apiDataSourceMock = ApiDataSourceMock()
                        apiDataSourceMock.returnedResult = .failure(.network)
                        sut = ApiService.Downloader(apiDataSource: apiDataSourceMock)
                        
                        sut.download(fromURL: apiURL, configuration: RequestConfiguration(numberOfRetries: MockData.numberOfRetries), completion: { (result: Result<Data, ApiError>) in })
                    }
                    
                    it("invocation counter value is equal to MockData.numberOfRetries + first invocation") {
                        expect(apiDataSourceMock.downloadInvocationCounter).to(equal(MockData.numberOfRetries + 1))
                    }
                }
                
                context("number of retries from MockData will be ignored due to parseError") {
                    beforeEach {
                        apiURL = URL(string: "https://example.com")
                        apiDataSourceMock = ApiDataSourceMock()
                        apiDataSourceMock.returnedResult = .failure(.cannotParseData(""))
                        sut = ApiService.Downloader(apiDataSource: apiDataSourceMock)
                        
                        sut.download(fromURL: apiURL, configuration: RequestConfiguration.standard, completion: { (result: Result<Data, ApiError>) in })
                    }
                    
                    it("invocation counter value is equal 1") {
                        expect(apiDataSourceMock.downloadInvocationCounter).to(equal(1))
                    }
                }
            }
        }
    }
}

private class ApiDataSourceMock: ApiDataSource {
    private(set) var downloadInvocationCounter = 0
    private(set) var inputURL: URL!
    var returnedResult: Result<Data, ApiError>!
    
    func send<T:Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) {}
    
    func download(fromURL url: URL, completion: @escaping(Result<Data, ApiError>) -> Void) {
        inputURL = url
        downloadInvocationCounter += 1
        completion(returnedResult)
    }
}

private struct MockData {
    static let numberOfRetries = 5
}

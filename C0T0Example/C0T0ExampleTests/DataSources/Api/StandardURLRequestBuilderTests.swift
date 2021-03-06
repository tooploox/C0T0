//
// Created by Karol on 07.09.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Quick
import Nimble
@testable import C0T0

class StandardURLRequestBuilderTests: QuickSpec {

    override func spec() {
        describe("StandardURLRequestBuilder") {
            var sut: StandardURLRequestBuilder!

            beforeEach {
                sut = StandardURLRequestBuilder(host: MockData.host)
            }

            context("when endpoint, http method, urlParameters, httpBody and headers are set as in MockData") {

                var apiRequest: ApiRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    apiRequest = ApiRequest(
                        endpoint: MockData.endpoint,
                        method: MockData.httpMethod,
                        urlParameters: MockData.urlParameters,
                        httpBody: MockData.httpBody,
                        headers: MockData.headers
                    )
                    urlRequest = sut.build(from: apiRequest)
                }

                it("returns URLRequest with endpoint set to MockData.endpoint") {
                    expect(urlRequest.url!).to(equal(URL(string: MockData.host + MockData.endpoint + "?" + MockData.urlParametersString)))
                }

                it("returns URLRequest with method set to MockData.httpMethod") {
                    expect(urlRequest.httpMethod!).to(equal(MockData.httpMethod.toString()))
                }

                it("returns URLRequest with proper contained MockData.parameters") {
                    let expectedBody = MockData.httpBody
                    expect(urlRequest.httpBody!).to(equal(expectedBody))
                }

                it("returns URLRequest with headers set to MockData.headers") {
                    let expected = NSDictionary(dictionary: MockData.headers)
                    expect(expected.isEqual(to: urlRequest.allHTTPHeaderFields!)).to(equal(true))
                }
            }
            
            context("when request doesn't contain urlParameters") {
                var apiRequest: ApiRequest!
                var urlRequest: URLRequest!
                
                beforeEach {
                    apiRequest = ApiRequest(
                        endpoint: MockData.endpoint,
                        method: MockData.httpMethod,
                        headers: MockData.headers
                    )
                    urlRequest = sut.build(from: apiRequest)
                }
                
                it("returns URLRequest with url created from host and endpoint from MockData.endpoint") {
                    expect(urlRequest.url!).to(equal(URL(string: MockData.host + MockData.endpoint)))
                }
            }
        }
    }
}

private struct MockData {
    static let host = "https://example.com"
    static let endpoint = "/someEndpoint"
    static let httpMethod = HTTPMethod.GET
    static let urlParameters = ["id": 123, "test": "test1"]  as [String : Any]
    static let httpBody = "sample data".data(using: .utf8)
    static let headers = ["someKey": "someValue"]
    
    static var path: String {
        var components = URLComponents()
        components.host = MockData.host
        return components.string!
    }
    
    static var urlParametersString: String {
        return urlParameters.map { (key, value) in
            "\(key)=\(value)"
            }.joined(separator: "&")
    }
}

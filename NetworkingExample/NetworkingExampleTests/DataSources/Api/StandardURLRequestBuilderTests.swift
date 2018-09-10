//
// Created by Karol on 07.09.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Quick
import Nimble
@testable import Networking

class StandardURLRequestBuilderTests: QuickSpec {

    override func spec() {
        describe("StandardURLRequestBuilder") {
            var sut: StandardURLRequestBuilder!

            beforeEach {
                sut = StandardURLRequestBuilder(host: MockData.host)
            }

            context("when endpoint, http method, parameters and headers are set as in MockData") {

                var apiRequest: ApiRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    apiRequest = ApiRequest(
                        endpoint: MockData.endpoint,
                        method: MockData.httpMethod,
                        parameters: MockData.parameters,
                        headers: MockData.headers
                    )
                    urlRequest = sut.build(from: apiRequest)
                }

                it("returns URLRequest with endpoint set to MockData.endpoint") {
                    expect(urlRequest.url!).to(equal(URL(string: MockData.host + MockData.endpoint)))
                }

                it("returns URLRequest with method set to MockData.httpMethod") {
                    expect(urlRequest.httpMethod!).to(equal(MockData.httpMethod.toString()))
                }

                it("returns URLRequest with proper contained MockData.parameters") {
                    let expectedBody = try! JSONSerialization.data(withJSONObject: MockData.parameters)
                    expect(urlRequest.httpBody!).to(equal(expectedBody))
                }

                it("returns URLRequest with headers set to MockData.headers") {
                    let expected = NSDictionary(dictionary: MockData.headers)
                    expect(expected.isEqual(to: urlRequest.allHTTPHeaderFields!)).to(equal(true))
                }
            }
        }
    }
}

private struct MockData {
    static let host = "http://example.com"
    static let endpoint = "/someEndpoint"
    static let httpMethod = HTTPMethod.GET
    static let parameters = ["id": 123]
    static let headers = ["someKey": "someValue"]

    static var path: String {
        var components = URLComponents()
        components.host = MockData.host
        return components.string!
    }
}

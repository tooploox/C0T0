//
// Created by Karol on 10.09.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Networking

class StandardURLRequestSenderErrorConverterTests: QuickSpec {
    override func spec() {
        describe("StandardURLRequestSenderErrorConverter") {

            var sut: StandardURLRequestSenderErrorConverter!

            beforeEach {
                sut = StandardURLRequestSenderErrorConverter()
            }

            context("when request sender error is network error") {
                let requestSenderError = URLRequestSenderError.network(NSError(domain: "TestError", code: 111))

                it("returns network error") {
                    expect(sut.convert(urlSessionSenderError: requestSenderError)).to(equal(.network))
                }
            }

            context("when request sender error is http error") {
                let requestSenderError = URLRequestSenderError.http(404)

                it("returns http error") {
                    expect(sut.convert(urlSessionSenderError: requestSenderError)).to(equal(.http(404)))
                }
            }
        }
    }
}

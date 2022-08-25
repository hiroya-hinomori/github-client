//
//  DomainTests.swift
//  DomainTests
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import XCTest
@testable import Domain

class DomainTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_stub_username() {
        let stub = StubNetworkService()
        stub.request(Connection.GraphQL.LoginUserTarget(token: "")) {
            if case .success(let value) = $0 {
                XCTAssertEqual(value.name, "hoge-taro")
            } else {
                XCTFail()
            }
        }
    }
    
    func test_stub_repositories() {
        let stub = StubNetworkService()
        let ref = [
            Repositories.Repository(url: .init(string: "https://hoge.co.jp")!, name: "hoge"),
            Repositories.Repository(url: .init(string: "https://huga.co.jp")!, name: "huga"),
            Repositories.Repository(url: .init(string: "https://fuga.co.jp")!, name: "fuga"),
            Repositories.Repository(url: .init(string: "https://foga.co.jp")!, name: "foga"),
            Repositories.Repository(url: .init(string: "https://tiga.co.jp")!, name: "tiga"),
        ]
        stub.request(Connection.GraphQL.RepositoriesTarget(token: "")) {
            if case .success(let list) = $0 {
                XCTAssertEqual(list.list, ref)
            } else {
                XCTFail()
            }
        }
    }
}

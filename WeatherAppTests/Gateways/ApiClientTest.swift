//
//  ApiClientTest.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 9/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ApiClientTest: XCTestCase {
    
    // https://www.martinfowler.com/bliki/TestDouble.html
    let urlSessionStub = URLSessionStub()
    
    var apiClient: ApiClientImplementation!
    
    
    // MARK: - Set up
    
    override func setUp() {
        super.setUp()
        apiClient = ApiClientImplementation(urlSession: urlSessionStub)
    }
    
    // MARK: - Tests
    
    func test_execute_successful_http_response_parses_ok() {
        // Given
        
        // Normally to mock JSON responses you should use a Dictionary and convert it to JSON using JSONSerialization.data
        // In our example here we don't care about the actual JSON, we care about the data regardless of its format it would have
        let expectedUtf8StringResponse = "{\"SomeProperty\":\"SomeValue\"}"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected2xxReponse = HTTPURLResponse(statusCode: 200)
        
        urlSessionStub.enqueue(response: (data: expectedData, response: expected2xxReponse, error: nil))
        
        let executeCompletionHandlerExpectation = expectation(description: "Completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<ApiResponse<TestDoubleApiEntity>>) in
            // Then
            guard let response = try? result.get() else {
                XCTFail("A successfull response should've been returned")
                return
            }
            
            XCTAssertEqual(expectedUtf8StringResponse, response.entity.utf8String, "The string is not the expected one")
            XCTAssertTrue(expected2xxReponse === response.httpUrlResponse, "The http response is not the expected one")
            XCTAssertEqual(expectedData?.base64EncodedString(), response.data?.base64EncodedString(), "Data doesn't match")
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_execute_successful_http_response_prase_error() {
        // Given
        let expectedUtf8StringResponse = "{ \"SomeProperty\" : \"SomeValue\" }"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected2xxReponse = HTTPURLResponse(statusCode: 200)
        let expectedParsingErrorMessage = "A parsing error occured"
        
        urlSessionStub.enqueue(response: (data: expectedData, response: expected2xxReponse, error: nil))
        
        let executeCompletionHandlerExpectation = expectation(description: "Completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<ApiResponse<TestDoubleErrorParseApiEntity>>) in
            // Then
            do {
                let _ = try result.get()
                XCTFail("Expected parse error to be thrown")
            } catch let error as ApiParseError {
                XCTAssertTrue(expected2xxReponse === error.httpUrlResponse, "The http response is not the expected one")
                XCTAssertEqual(expectedData?.base64EncodedString(), error.data?.base64EncodedString(), "Data doesn't match")
                XCTAssertEqual(expectedParsingErrorMessage, error.localizedDescription, "Error message doesn't match")
            } catch {
                XCTFail("Expected parse error to be thrown")
            }
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_execute_error_no_httpurlresponse() {
        // Given
        let expectedErrorMessage = "Some random network error"
        let expectedError = NSError.createError(withMessage: expectedErrorMessage)
        
        urlSessionStub.enqueue(response: (data: nil, response: nil, error: expectedError))
        
        let executeCompletionHandlerExpectation = expectation(description: "Completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<ApiResponse<TestDoubleApiEntity>>) in
            // Then
            do {
                let _ = try result.get()
                XCTFail("Expected network error to be thrown")
            } catch let error as NetworkRequestError {
                XCTAssertEqual(expectedErrorMessage, error.localizedDescription, "Error message doesn't match")
            } catch {
                XCTFail("Expected network error to be thrown")
            }
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

private struct TestDoubleRequest: ApiRequest {
    var urlRequest: URLRequest {
        return URLRequest(url: URL.googleUrl)
    }
}


private struct TestDoubleApiEntity: Codable {
    var SomeProperty: String
    
    var utf8String: String {
        let data = try? JSONEncoder().encode(self)
        return String(data: data!, encoding: .utf8)!
    }
}

private struct TestDoubleErrorParseApiEntity: Decodable {
    init(from decoder: Decoder) throws {
        throw NSError.createPraseError()
    }
}

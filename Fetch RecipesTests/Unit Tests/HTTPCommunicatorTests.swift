//
//  HTTPCommunicatorTests.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Testing
import Foundation
@testable import Fetch_Recipes

struct MockRequest: HTTPRequestable {
    var path: String = "/some/path"
    var method: HTTPMethod = .get
}

struct MockResponse: Decodable {}

struct HTTPCommunicatorTests {
    @Test("Test send request failure with bad response")
    func testSendRequestWithBadRequest() async throws {
        let mockRequester = MockURLRequester()
        mockRequester.mockResponse = .init()
        mockRequester.mockData = .init()
        let sut = HTTPCommunicator(
            server: .init(scheme: "http", host: "google"),
            requester: mockRequester
        )
        do {
            let _: MockResponse = try await sut.send(request: MockRequest())
        } catch {
            switch error {
            case NetworkingError.badResponse:
                assert(true)
            default:
                assert(false)
            }
        }
    }
    
    @Test("Test send request failure with HTTP status code error")
    func testSendRequestWithHTTPStatusCodeError() async throws {
        let mockRequester = MockURLRequester()
        let statusCode = 502
        mockRequester.mockResponse = HTTPURLResponse.init(
            url: .init(string: "url")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        mockRequester.mockData = .init()
        let sut = HTTPCommunicator(
            server: .init(scheme: "http", host: "google"),
            requester: mockRequester
        )
        do {
            let _: MockResponse = try await sut.send(request: MockRequest())
        } catch {
            switch error {
            case NetworkingError.httpError(let statusCode):
                assert(statusCode == statusCode)
            default:
                assert(false)
            }
        }
    }
    
    @Test("Test send request failure with JSON decoding error")
    func testSendRequestWithJSONDecodingError() async throws {
        let mockRequester = MockURLRequester()
        let statusCode = 200
        mockRequester.mockResponse = HTTPURLResponse.init(
            url: .init(string: "url")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        mockRequester.mockData = "{illegalJSONData}".data(using: .utf8)
        let sut = HTTPCommunicator(
            server: .init(scheme: "http", host: "google"),
            requester: mockRequester
        )
        do {
            let _: MockResponse = try await sut.send(request: MockRequest())
        } catch {
            switch error {
            case DecodingError.dataCorrupted:
                assert(true)
            default:
                assert(false)
            }
        }
    }
    
    @Test("Test send request with success")
    func testSendRequestWithSuccess() async throws {
        let mockRequester = MockURLRequester()
        let statusCode = 200
        mockRequester.mockResponse = HTTPURLResponse.init(
            url: .init(string: "url")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        let jsonString = """
            [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                }
            ]
        """
        mockRequester.mockData = jsonString.data(using: .utf8)
        let sut = HTTPCommunicator(
            server: .init(scheme: "http", host: "google"),
            requester: mockRequester
        )
        do {
            let response: [Recipe] = try await sut.send(request: MockRequest())
            assert(response[0].id.uuidString == "0C6CA6E7-E32A-4053-B824-1DBF749910D8")
            assert(response[0].name == "Apam Balik")
            assert(response[0].cuisine == "Malaysian")
            assert(response[0].photoURLSmall.absoluteString == "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
            assert(response[0].photoURLLarge.absoluteString == "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
            assert(response[0].sourceURL?.absoluteString == "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
            assert(response[0].youtubeURL?.absoluteString == "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        } catch {
            assert(false)
        }
    }
}

//
//  SportCatalogueViewModelTests.swift
//  SportsbookTests
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation
import XCTest


final class SportCatalogueViewModelTests: XCTestCase {
    
    private var sut: SportsCatalogueViewModel!
    private var apiManagerMock: APIManagerMock!
    
    override func setUpWithError() throws {
        sut = SportsCatalogueViewModel()
        apiManagerMock = APIManagerMock()
    }
    
    func test_fetchSportsCatalog_fetchesDataAndUpdatesState_whenSuccessful() {
        // Given
        let mockResponse = SportsResponseModel(data: [SportModel(id: 123, name: "Football")])
        apiManagerMock.response = APIResponse(statusCode: 200, data: mockResponse)
        
        // When
        sut.fetchSportsCatalogue(apiManager: apiManagerMock)
        
        // Then
        XCTAssertEqual(sut.loadingState, .loading)
        let expectation = expectation(description: "Delay 1 second for simulated loading")
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.sportsCatalogue[0].name, "Football", "Names match")
            XCTAssertEqual(sut.sportsCatalogue[0].id, 123, "Ids match")
            XCTAssertEqual(sut.loadingState, .finished)
            XCTAssertEqual(sut.cellModels.count, 1)
            XCTAssertEqual(sut.sportsCatalogue.count, 1)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_fetchSportsCatalog_fetchesDataAndUpdatesState_whenFailure() {
        // Given
        let mockResponse = APIError.failedDecoding
        apiManagerMock.response = mockResponse
        
        // When
        sut.fetchSportsCatalogue(apiManager: apiManagerMock)
        
        // Then
        XCTAssertEqual(sut.loadingState, .loading)
        let expectation = expectation(description: "Delay 1 second for simulated loading")
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.loadingState, .error(mockResponse))
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_showSportDetails_isCalledAndReceivesSportModel() {
        // Given
        let sportCatalogueDelegate = SportsCatalogueDelegateMock()
        let sportModel = SportModel(id: 122, name: "Rugby")
        sut.coordinatorDelegate = sportCatalogueDelegate
        
        // When
        sut.showSportDetails(for: sportModel)
        
        // Then
        let delegate = sut.coordinatorDelegate as! SportsCatalogueDelegateMock
        XCTAssert(delegate.showSportDetailsCalled)
        XCTAssertEqual(delegate.receivedSportModel, sportModel)
    }
}

// **************************************
// MARK: - Mock Classes
// **************************************

final class APIManagerMock: APIManagerProtocol {
    var response: Any?
    
    func execute<ModelType>(request: APIRequest, expectedType: ModelType.Type) async throws -> APIResponse<ModelType> where ModelType : Decodable {
        guard let response = response else {
            fatalError("Mock not configured")
        }
        
        try await Task.sleep(for: .seconds(0.5))
        if let error = response as? APIError {
            throw error
        } else {
            return response as! APIResponse<ModelType>
        }
    }
}

final class SportsCatalogueDelegateMock: SportsCatalogueDelegate {
    var showSportDetailsCalled = false
    var receivedSportModel: SportModel?
    
    func showSportDetails(for model: SportModel) {
        showSportDetailsCalled = true
        receivedSportModel = model
    }
}

// TODO: Move this to a suitable place
extension SportCatalogueViewModelLoadingState: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case  (.finished, .finished):
            return true
        case (let .error(lhsError), let .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

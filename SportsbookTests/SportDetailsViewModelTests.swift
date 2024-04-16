//
//  SportDetailsViewModelTests.swift
//  SportsbookTests
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import XCTest

final class SportDetailsViewModelTests: XCTestCase {
    
    private var sut: SportDetailsViewModel!
    private var apiManagerMock: APIManagerMock!

    override func setUpWithError() throws {
        sut = SportDetailsViewModel(sportModel: SportModel(id: 123, name: "Football"))
        apiManagerMock = APIManagerMock()
    }

    func test_fetchSportsCatalog_fetchesDataAndUpdatesState_whenSuccessful() {
        // Given
        let runner = WDWMatchRunner(name: "Liverpool", id: UUID(uuidString: "2E5E6576-ED16-405F-8864-6ED83C68FCC7")!, odds: Odds(numerator: 10, denominator: 4), marketType: .matchBetting)
        let market = Market(id: UUID(uuidString: "9A50EE7E-F2BC-47FC-96F1-A84068311E0D")!, type: .matchBetting, name: "Regular Time Match Odds", runners: [runner])
        
        let mockResponse = SportDetailEventsResponseModel(data: [EventPrimaryMarketAggregate(id:UUID(uuidString: "3E9A2ABA-5F9C-4939-BDF7-3E5F9AC9CEDD")! , name: "Liverpool FC vs Manchester Utd", date: Date(timeIntervalSince1970: 1713243548), primaryMarket: market)]) //Tuesday, 16 April 2024 04:59:08
        apiManagerMock.response = APIResponse(statusCode: 200, data: mockResponse)
        
        // When
        sut.fetchAndTransformSportsEvents(forSportWith: sut.sportModel.id, apiManager: apiManagerMock)
        
        // Then
        XCTAssertEqual(sut.loadingState, .loading)
        let expectation = expectation(description: "Delay 1 second for simulated loading")
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.loadingState, .finished)
            XCTAssertEqual(sut.sportsEventMarketTableModel.count, 1)
            XCTAssertEqual(sut.sportsEventMarketTableModel[0].cellModels.count, 1)
            XCTAssertEqual(sut.sportsEventMarketTableModel[0].dateString, "Tuesday 16th April")
            let cellModel = sut.sportsEventMarketTableModel[0].cellModels[0] as! SportDetailsTableViewCellModel
            XCTAssertEqual(cellModel.homeTeamName, "Liverpool FC")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}

// TODO: Move this to a suitable place
extension SportDetailsViewModelLoadingState: Equatable {
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

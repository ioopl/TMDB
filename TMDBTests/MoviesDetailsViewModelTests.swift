import XCTest
@testable import TMDB

final class MoviesDetailsViewModelTests: XCTestCase {

    func test_stateTransitions_fromLoadingToLoaded() {
        // Arrange
        let movie = Movie(id: 1, title: "Tenet", overview: "", posterPath: nil, voteAverage: 7.5, genreIDs: [])
        let details = MovieDetails(title: "Tenet", overview: "Time travel", backdropPath: "", tagline: "")
        let api = MockAPIManager(result: .success(details))
        let sut = MoviesDetailsViewModel(movie: movie, apiManager: api)
        let exp = expectation(description: "Updated called")

        // Act
        sut.updatedState = {
            if case .loaded = sut.state {
                exp.fulfill()
            }
        }
        sut.fetchData()

        // Assert
        wait(for: [exp], timeout: 1)
        if case .loaded(let result) = sut.state {
            XCTAssertEqual(result.title, "Tenet")
        } else {
            XCTFail("Expected loaded state")
        }
    }
}

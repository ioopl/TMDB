import XCTest
@testable import TMDB

final class GenreManagerTests: XCTestCase {

    func test_fetchGenresIfNeeded_storesGenres() {
        // Arrange
        let mockGenres = GenreList(genres: [
            Genre(id: 1, name: "Action"),
            Genre(id: 2, name: "Drama")
        ])

        let apiManager = MockAPIManager(result: .success(mockGenres))
        let sut = GenreManager(apiManager: apiManager)
        let exp = expectation(description: "Genres fetched")

        // Act
        sut.fetchGenresIfNeeded {
            // Assert
            XCTAssertEqual(sut.genreMap[1], "Action")
            XCTAssertEqual(sut.genreMap[2], "Drama")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_fetchGenresIfNeeded_returnsImmediately_whenCached() {
        // Arrange
        let mockGenreProvider = MockGenreProvider()
        // sut.genreMap = [1: "Action"] // already cached in 

        let exp = expectation(description: "Immediate completion")

        // Act
        mockGenreProvider.fetchGenresIfNeeded {
            // Assert
            XCTAssertEqual(mockGenreProvider.genreMap[1], "Action")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func test_fetchGenresIfNeeded_handlesFailure() {
        // Arrange
        let apiManager = MockAPIManager(result: .failure(.networkError))
        let sut = GenreManager(apiManager: apiManager)
        let exp = expectation(description: "Completion called even on failure")

        // Act
        sut.fetchGenresIfNeeded {
            // Assert
            XCTAssertTrue(sut.genreMap.isEmpty)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }
}

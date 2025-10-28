import XCTest
@testable import TMDB


final class SimilarMoviesViewModelTests: XCTestCase {

    func test_fetchSimilarMovies_transitionsFromLoadingToLoaded() {
        // Arrange
        let movies = [
            Movie(id: 1, title: "Inception", overview: "", posterPath: nil, voteAverage: 9.0, genreIDs: [1, 2]),
            Movie(id: 2, title: "Interstellar", overview: "", posterPath: nil, voteAverage: 8.5, genreIDs: [1])
        ]
        let page = Page<Movie>(pageNumber: 1, totalResults: 2, totalPages: 1, results: movies)

        let mockAPI = MockAPIManager(result: .success(page))
        let mockGenres = MockGenreProvider()
        mockGenres.genreMap = [1: "Action", 2: "Sci-Fi"]

        let sut = SimilarMoviesViewModel(apiManager: mockAPI, genres: mockGenres)
        let exp = expectation(description: "Loaded state emitted")

        // Act
        sut.onChange = { state in
            if case .loaded(let items) = state {
                XCTAssertEqual(items.count, 2)
                XCTAssertEqual(items.first?.title, "Inception")
                XCTAssertEqual(items.first?.genreNames, ["Action", "Sci-Fi"])
                exp.fulfill()
            }
        }

        sut.fetchSimilarMovies(movieID: 42)

        // Assert
        wait(for: [exp], timeout: 1.0)
    }

    func test_fetchSimilarMovies_setsErrorState_onFailure() {
        // Arrange
        let mockAPI = MockAPIManager(result: .failure(.networkError))
        let mockGenres = MockGenreProvider()
        let sut = SimilarMoviesViewModel(apiManager: mockAPI, genres: mockGenres)
        let exp = expectation(description: "Error state emitted")

        // Act
        sut.onChange = { state in
            if case .error = state {
                exp.fulfill()
            }
        }

        sut.fetchSimilarMovies(movieID: 123)

        // Assert
        wait(for: [exp], timeout: 1.0)
    }

    func test_fetchSimilarMovies_startsWithLoadingState() {
        // Arrange
        let mockAPI = MockAPIManager(result: .failure(.networkError))
        let mockGenres = MockGenreProvider()
        let sut = SimilarMoviesViewModel(apiManager: mockAPI, genres: mockGenres)
        let exp = expectation(description: "Loading state emitted")

        // Act
        sut.onChange = { state in
            if case .loading = state {
                exp.fulfill()
            }
        }

        sut.fetchSimilarMovies(movieID: 1)

        // Assert
        wait(for: [exp], timeout: 0.5)
    }
}

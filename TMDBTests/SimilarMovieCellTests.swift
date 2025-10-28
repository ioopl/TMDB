import XCTest
@testable import TMDB

final class SimilarMovieCellTests: XCTestCase {

    func test_configure_setsLabelsCorrectly() {
        // Arrange
        let cell = SimilarMovieCell()
        let movie = Movie(
            id: 1,
            title: "Matrix",
            overview: "Sci-fi",
            posterPath: nil,
            voteAverage: 8.8,
            genreIDs: [1, 2]
        )

        let genres = [1: "Action", 2: "Sci-Fi"]

        // Act
        cell.configure(movie, genreMap: genres)

        // Assert
        XCTAssertEqual(cell.title.text, "Matrix")
        XCTAssertEqual(cell.genresLabel.text, "Action • Sci-Fi")
    }
}

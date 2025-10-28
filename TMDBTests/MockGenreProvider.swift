import XCTest
@testable import TMDB

final class MockGenreProvider: GenreProviding {
    var genreMap: [Int: String] = [1: "Action"]
    func fetchGenresIfNeeded(completion: @escaping () -> Void) {

        // Simulate instant availability of genres
        completion()
    }
}

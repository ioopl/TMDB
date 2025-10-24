import Foundation

enum SimilarMoviesState: Equatable {
    case idle
    case loading
    case loaded([Item])
    case error

    struct Item: Equatable {
        let id: Int
        let title: String
        let posterPath: String?
        let rating: Double
        let genreNames: [String]
    }
}

import Foundation

///https://developer.themoviedb.org/reference/discover-movie
struct Movie: Decodable {
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let genreIDs: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIDs = "genre_ids"
    }
    
}

extension Movie {
    static var topRated: Request<Page<Movie>> {
        return Request(method: .get, path: "/movie/top_rated")
    }
    
    static func similar(for movieID: Int) -> Request<Page<Movie>> {
        return Request(method: .get, path: "/movie/\(movieID)/similar")
    }
}

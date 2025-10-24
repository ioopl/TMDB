import Foundation

///https://developer.themoviedb.org/reference/genre-movie-list
struct GenreList: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable, Hashable {
    let id: Int
    let name: String
}

extension Genre {
    static var all: Request<GenreList> {
        return Request(method: .get, path: "/genre/movie/list")
    }
}

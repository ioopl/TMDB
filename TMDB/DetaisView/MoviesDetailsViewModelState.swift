import Foundation

enum MoviesDetailsViewModelState {
    case loading(Movie)
    case loaded(MovieDetails)
    case error

    var title: String? {
        switch self {
        case .loaded(let movie):
            return movie.title
        case .loading(let movie):
            return movie.title
        case .error:
            return nil
        }
    }

    var movie: MovieDetails? {
        switch self {
        case .loaded(let movie):
            return movie
        case .loading, .error:
            return nil
        }
    }
}

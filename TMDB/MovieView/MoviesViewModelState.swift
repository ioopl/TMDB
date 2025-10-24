enum MoviesViewModelState {
    case loading
    case loaded([Movie])
    case error

    var movies: [Movie] {
        switch self {
        case .loaded(let movies):
            return movies
        case .loading, .error:
            return []
        }
    }
}

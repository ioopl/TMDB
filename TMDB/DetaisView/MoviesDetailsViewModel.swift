final class MoviesDetailsViewModel {

    private let apiManager: APIManaging
    private let initialMovie: Movie

    init(movie: Movie, apiManager: APIManaging) {
        self.initialMovie = movie
        self.apiManager = apiManager
        self.state = .loading(movie)
    }
    
    var state: MoviesDetailsViewModelState {
        didSet {
            updatedState?()
        }
    }
    
    var updatedState: (() -> Void)?

    func fetchData() {
        apiManager.execute(MovieDetails.details(for: initialMovie)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetails):
                self.state = .loaded(movieDetails)
            case .failure:
                self.state = .error
            }
        }
    }
}

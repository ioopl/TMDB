final class SimilarMoviesViewModel {
    
    private let apiManager: APIManaging
    private let genres: GenreProviding

    init(apiManager: APIManaging, genres: GenreProviding) {
        self.apiManager = apiManager
        self.genres = genres
    }

    private(set) var state: SimilarMoviesState = .idle {
        didSet {
            onChange?(state)
        }
    }

    var onChange: ((SimilarMoviesState) -> Void)?

    func fetchData(movieID: Int) {
        state = .loading
        genres.fetchGenresIfNeeded { [weak self] in
            guard let self else { return }

            let request: Request<Page<Movie>> = Movie.similar(for: movieID)

            self.apiManager.execute(request) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let page):
                    let mapped = page.results.map { movie -> SimilarMoviesState.Item in
                        let names = (movie.genreIDs ?? []).compactMap { self.genres.genreMap[$0] }
                        return .init(id: movie.id,
                                     title: movie.title,
                                     posterPath: movie.posterPath,
                                     rating: movie.voteAverage,
                                     genreNames: names)
                    }
                    self.state = .loaded(mapped)
                case .failure:
                    self.state = .error
                }
            }
        }
    }
}

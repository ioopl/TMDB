import Foundation

final class MoviesViewModel {

    private let apiManager: APIManaging

    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }

    var updatedState: (() -> Void)?

    var state: MoviesViewModelState = .loading {
        didSet {
            updatedState?()
        }
    }

    func fetchData() {
        apiManager.execute(Movie.topRated) { [weak self] result in
            switch result {
            case .success(let page):
                self?.state = .loaded(page.results)
            case .failure:
                self?.state = .error
            }
        }
    }
}

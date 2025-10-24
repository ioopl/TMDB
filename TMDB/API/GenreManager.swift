import Foundation

protocol GenreProviding {
    var genreMap: [Int: String] { get }
    func fetchGenresIfNeeded(completion: @escaping () -> Void)
}


/// A global manager that caches all movie genres so we only fetch them once per app session.
final class GenreManager: GenreProviding {
    
    private let apiManager: APIManaging
    private(set) var genreMap: [Int: String] = [:]
    private var isFetching = false
    private var pendingCompletions: [() -> Void] = []

    init(apiManager: APIManaging) {
        self.apiManager = apiManager
        
    }
    /// Fetches the global genre list only once and caches it.
    func fetchGenresIfNeeded(completion: @escaping () -> Void) {
        // If we already have genres, return immediately
        if !genreMap.isEmpty {
            completion()
            return
        }

        // If another request is already in progress, queue this completion
        if isFetching {
            pendingCompletions.append(completion)
            return
        }

        isFetching = true
        let request = Genre.all

        apiManager.execute(request) { [weak self] result in
            guard let self = self else { return }
            defer {
                self.isFetching = false
                DispatchQueue.main.async {
                    self.pendingCompletions.forEach { $0() }
                    self.pendingCompletions.removeAll()
                }
            }

            if case .success(let list) = result {
                self.genreMap = Dictionary(uniqueKeysWithValues: list.genres.map { ($0.id, $0.name) })
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

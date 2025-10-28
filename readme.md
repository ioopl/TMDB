# TMDB App

A Swift Application using TMDB API to showcase MVVM Architecture via Dependency Injection (DI).

**Example Flow

1. MovieDetailsViewController creates a SimilarMoviesViewModel.
2. ViewModel calls the injected APIManager to fetch data.
4. On success, it maps API responses to lightweight state objects.
4. It triggers onChange?(state) → UI updates in ViewController.
5. Tests inject MockAPIManager to simulate steps 2–4 without the network.

- **Models:**  
  Models like Movie, Genre, MovieDetails and Page<T> represent the API’s data responses.
They are Decodable Swift structs used to map JSON into strongly typed Swift objects, ensuring compile-time safety and cleaner business logic.

- **API:**  
The APIManager is the app’s network layer responsible for executing typed requests (Request<T>) and decoding them into model objects. T is Generic type placeholder. _(It represents “some type” that you will decide later when you use the request — it’s not a concrete type yet.)_
Each request clearly defines its HTTP method, path, and response type — keeping network logic clean, reusable, and testable.

- **MVVM Pattern/ View Models:**  
Using MVVM Pattern which separates data, logic, and UI — the ViewModel holds business logic, injected with dependencies (like APIManager) via dependency injection, while ViewControllers focus purely on displaying state.

- **Dependency Injection (DI):**  
Core dependencies (API clients, data providers, etc.) are passed into ViewModels and Controllers through their initializers, improving modularity, reusability, and testability across the codebase.

- **Closures:**  
Used as lightweight callbacks (e.g. onChange) that act like methods with a modern inline syntax, allowing the ViewModel to notify the ViewController reactively without delegation or subclassing.

- **Protocols:**  
Define clean, testable interfaces (like APIManaging and GenreProviding) so implementation details (e.g. real API calls) can be swapped or mocked without changing the app logic.

- **Coordinator Pattern:**  
  App navigation will be managed iA via `AppCoordinator`, separating UI flow logic from Swift Views.

- **Mock API Manager for Testing:**  
The APIManager and GenreManager are tested using mock protocol implementations, ensuring predictable results and verifying logic without performing real network calls.

  A `Mock API Manager` class that replaces network requests in all tests. 
    -- Deterministic (no real HTTP)
    -- Type-safe generic Value
    -- Simulates both success & failure paths .

- **GenreManagerTests.swift:**  
  GenreManager uses DI, so we can pass a mock APIManager. These Tests verify:
    -- Genre caching
    -- Immediate return when cached
    -- Safe completion on error path



---

## Explain your architecture

**Architecture:** MVVM + Coordinator Pattern  
**Language:** Swift  
**UI:** Programmatically making UI via UIKit (chosen for declarative layout, state-driven updates, and easy previews)  
**Frameworks:** Swift  

The App follows a clean separation of concerns:

---

## Notes on Decisions/trade-offs 

AppDelegate was chosen over SceneDelegate :
- SceneDeleagate allows for Multiple Windows(of same  App) while AppDelegate is single Window App(pre iOS 13) 
- Latest Apps all use SceneDelegate but we went with AppDelegate approach

- Used closures instead of methods(which is exactly what Swift’s reactive patterns like Combine or delegation are built on). Closures make ViewModel reactive, without needing inheritance or a delegate class.
 **Think of closures as “inline delegates.” They let you observe events without needing to create a whole new delegate protocol or subclass. 
 
 _(ref: https://chatgpt.com/s/t_68fcc12f31f88191ba0b86426c9717f5)
 
for exmaple usage in SimilarMoviesViewModel: 
/**
It’s a variable that can hold any function (or closure) taking one argument of type SimilarMoviesState and returning nothing (Void).

var onChange: ((SimilarMoviesState) -> Void)?

**
Example of assigning it:

viewModel.onChange = { state in
    print("State changed to:", state)
}

**
It’s called automatically whenever state changes:

private(set) var state: SimilarMoviesState = .idle {
    didSet {
        onChange?(state)
    }
}

**That ? means: if someone assigned this closure, call it.

**If it were a method instead, we could write the same logic like this:

final class SimilarMoviesViewModel {
    private let apiManager: APIManaging
    private let genres: GenreProviding

    private(set) var state: SimilarMoviesState = .idle {
        didSet {
            stateDidChange(state)
        }
    }

    init(apiManager: APIManaging, genres: GenreProviding) {
        self.apiManager = apiManager
        self.genres = genres
    }

    // ✅ A method instead of a closure
    func stateDidChange(_ newState: SimilarMoviesState) {
        print("State changed:", newState)
    }

    func fetchSimilarMovies(movieID: Int) {
        state = .loading
        // ...
    }
}

**And we would just override or subclass and override stateDidChange.

final class LoggingSimilarMoviesViewModel: SimilarMoviesViewModel {
    override func stateDidChange(_ newState: SimilarMoviesState) {
        print("State changed to:", newState)
    }
}


*/

---


## How to run the project
- Clone or unzip the repo.
- Open the .xcodeproj or .xcworkspace in Xcode 15.2+.

---



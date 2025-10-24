import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: - Dependency Graph/Setup (Composition root)

        let apiManager = APIManager()
        let genreProvider = GenreManager(apiManager: apiManager)

        let moviesVM = MoviesViewModel(apiManager: apiManager)

        let rootVC = MoviesViewController(
            viewModel: moviesVM,
            apiManager: apiManager,
            genreProvider: genreProvider
        )

        let nav = UINavigationController(rootViewController: rootVC)
        nav.view.backgroundColor = .white
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.isTranslucent = false

        // MARK: window setup (classic iOS 12 style)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}

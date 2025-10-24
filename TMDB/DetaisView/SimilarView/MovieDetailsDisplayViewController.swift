import UIKit

final class MovieDetailsDisplayViewController: UIViewController {

    private let apiManager: APIManaging
    private let genreProvider: GenreProviding
    private let movieID: Int
    private let movieDetails: MovieDetails

    private var contentView: InnerView {
        return view as! InnerView
    }

    init(movieID: Int,
         movieDetails: MovieDetails,
         apiManager: APIManaging,
         genreProvider: GenreProviding) {
        self.movieID = movieID
        self.movieDetails = movieDetails
        self.apiManager = apiManager
        self.genreProvider = genreProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// We are declaring that Instead of using a plain UIView, this view controller’s main view will be an instance of my custom subclass InnerView.

    override func loadView() {
        view = InnerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Creating and Injecting SimilarMoviesViewController
        let similarVM = SimilarMoviesViewModel(apiManager: apiManager, genres: genreProvider)
        let similarVC = SimilarMoviesViewController(movieID: movieID, viewModel: similarVM)

        // Configuring the Top section (poster, title, overview)
        contentView.configure(movieDetails: movieDetails)
        addChild(similarVC)
        contentView.similarContainer.addSubview(similarVC.view)
        
        similarVC.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            similarVC.view.topAnchor.constraint(equalTo: (view as? InnerView)!.similarContainer.topAnchor),
            similarVC.view.leadingAnchor.constraint(equalTo: (view as? InnerView)!.similarContainer.leadingAnchor),
            similarVC.view.trailingAnchor.constraint(equalTo: (view as? InnerView)!.similarContainer.trailingAnchor),
            similarVC.view.bottomAnchor.constraint(equalTo: (view as? InnerView)!.similarContainer.bottomAnchor)
        ])

        similarVC.didMove(toParent: self)
    }
}

private class InnerView: UIView {

    let scrollView = UIScrollView()
    let backdropImageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()

    private let similarHeader = UILabel()
    let similarContainer = UIView() // placeholder for child SimilarMoviesViewController

    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        backdropImageView,
        titleLabel,
        overviewLabel,
        similarHeader,
        similarContainer
    ])

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true

        titleLabel.font = UIFont.Heading.medium
        titleLabel.textColor = UIColor.Text.charcoal
        titleLabel.numberOfLines = 0
        overviewLabel.font = UIFont.Body.small
        overviewLabel.textColor = UIColor.Text.grey
        overviewLabel.numberOfLines = 0

        similarHeader.font = UIFont.Heading.small
        similarHeader.textColor = UIColor.Text.charcoal
        similarHeader.text = LocalizedString(key: "moviedetails.similar.header")

        similarContainer.translatesAutoresizingMaskIntoConstraints = false
        similarContainer.heightAnchor.constraint(equalToConstant: 280).isActive = true

        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.setCustomSpacing(8, after: titleLabel)
        contentStackView.setCustomSpacing(12, after: overviewLabel)

        addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 11 / 16),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
        ])
    }

    func configure(movieDetails: MovieDetails) {
        backdropImageView.dm_setImage(backdropPath: movieDetails.backdropPath)
        titleLabel.text = movieDetails.title
        overviewLabel.text = movieDetails.overview
    }
}

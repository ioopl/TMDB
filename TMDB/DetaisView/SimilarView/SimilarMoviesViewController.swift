import UIKit

/// This SimilarMoviesViewController owns the collection view. The MovieDetailsDisplayViewController VC hosts it in a container view.
final class SimilarMoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let viewModel: SimilarMoviesViewModel
    private let movieID: Int

    private lazy var collection: UICollectionView = {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .estimated(210)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 12)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(210)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.reuseID)
        return cv
    }()

    private var items: [SimilarMoviesState.Item] = []

    init(movieID: Int, viewModel: SimilarMoviesViewModel) {
        self.movieID = movieID
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        viewModel.onChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .loaded(let items):
                self.items = items
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            case .error, .idle, .loading:
                break
            }
        }
        viewModel.fetchData(movieID: movieID)
    }

    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.reuseID, for: indexPath) as! SimilarMovieCell
        let item = items[indexPath.item]
        cell.configure(
            title: item.title,
            posterPath: item.posterPath,
            rating: item.rating,
            genresLine: item.genreNames.joined(separator: " • ")
        )
        return cell
    }
}

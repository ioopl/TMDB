import UIKit

// MARK: - Similar Movies Cell & DataSource
final class SimilarMovieCell: UICollectionViewCell {
    
    static let reuseID = "SimilarMovieCell"
    private let imageView = UIImageView()
    internal let title = UILabel()
    
    internal let genresLabel = UILabel()
    private let ratingTag = TagView()
    
    func configure(title: String, posterPath: String?, rating: Double, genresLine: String) {
        self.title.text = title
        self.genresLabel.text = genresLine.isEmpty ? nil : genresLine
        self.ratingTag.configure(.rating(value: rating))
        if let path = posterPath {
            imageView.dm_setImage(posterPath: path)
        } else {
            imageView.image = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingTag.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        title.numberOfLines = 2
        title.font = UIFont.Body.small
        title.textColor = UIColor.Text.charcoal
        
        genresLabel.numberOfLines = 1
        genresLabel.font = UIFont.Body.small
        genresLabel.textColor = UIColor.Text.grey
        
        contentView.addSubview(imageView)
        contentView.addSubview(title)
        contentView.addSubview(genresLabel)
        contentView.addSubview(ratingTag)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/2), // aspect (2:3)
            
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            genresLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingTag.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 10),
            ratingTag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingTag.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ movie: Movie, genreMap: [Int:String]) {
        title.text = movie.title
        if let ids = movie.genreIDs, !ids.isEmpty {
            let names = ids.compactMap {
                genreMap[$0]
            }
            genresLabel.text = names.joined(separator: " • ")
        } else {
            genresLabel.text = nil
        }
        ratingTag.configure(.rating(value: movie.voteAverage))
        
        if let path = movie.posterPath {
            imageView.dm_setImage(posterPath: path)
        } else {
            imageView.image = nil
        }
    }
}

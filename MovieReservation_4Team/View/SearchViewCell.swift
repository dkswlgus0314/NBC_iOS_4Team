
import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func didTapImageView(cell: MovieCollectionViewCell)
}

class MovieCollectionViewCell: UICollectionViewCell {

    weak var delegate: MovieCollectionViewCellDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.3)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc private func imageViewTapped() {
        delegate?.didTapImageView(cell: self)
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let posterPath = movie.posterPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            NetworkManager.shared.loadImage(from: imageUrl, into: imageView)
        } else {
            imageView.image = nil
        }
    }
}

import UIKit
import SnapKit
class SearchView: UIView {

    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "영화 검색"
        search.barStyle = .default
        search.searchBarStyle = .minimal
        search.barTintColor = .mainWhite
        search.searchTextField.textColor = .mainWhite
        if let textField = search.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .mainBlack
            let placeholderText = NSAttributedString(string: "영화 검색", attributes: [.foregroundColor: UIColor.mainWhite])
            textField.attributedPlaceholder = placeholderText
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.mainWhite
            }
        }
        return search
    }()

    let recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "추천 영화"
        label.textColor = UIColor.mainWhite
        label.font = FontNames.mainFont.font()
        return label
    }()

    let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemWidth: CGFloat = 150
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemWidth = (UIScreen.main.bounds.width - 24) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.isHidden = true
        return collectionView
    }()
    weak var cellDelegate: MovieCollectionViewCellDelegate?
    private var nowPlayingMovies: [Movie] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        fetchNowPlayingMovies()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        self.backgroundColor = UIColor.mainBlack
        [searchBar, recentSearchesLabel, horizontalCollectionView, searchResultsCollectionView].forEach { self.addSubview($0) }
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        recentSearchesLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(8)
        }
        horizontalCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalTo(recentSearchesLabel.snp.bottom).offset(5)
            $0.height.equalTo(300)
        }
        searchResultsCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(0)
        }
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
        searchBar.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
        
    }
    @objc private func handleTextDidChange(notification: NSNotification) {
        guard let textField = notification.object as? UITextField else { return }
        searchResultsCollectionView.isHidden = textField.text?.isEmpty ?? true
    }
    private func fetchNowPlayingMovies() {
        let currentPage = 1 // 필요한 페이지 번호로 설정합니다.
        NetworkManager.shared.fetchNowPlayingMovies(page: currentPage) { [weak self] movies in
            DispatchQueue.main.async {
                self?.nowPlayingMovies = movies ?? []
                self?.horizontalCollectionView.reloadData()
            }
        }
    }
}
// MARK: - UICollectionViewDataSource Methods
extension SearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCollectionView {
            return nowPlayingMovies.count
        } else {
            return 10 // 여기에 실제 데이터 카운트를 반환해야 합니다.
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.delegate = cellDelegate
        if collectionView == horizontalCollectionView {
            let movie = nowPlayingMovies[indexPath.item]
            cell.configure(with: movie)
        } else {
            // Configure cell for searchResultsCollectionView
        }
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout Methods
extension SearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 24) / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}
// MARK: - UISearchBarDelegate Methods
extension SearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResultsCollectionView.isHidden = searchBar.text?.isEmpty ?? true
    }
}

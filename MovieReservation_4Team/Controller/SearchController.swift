import UIKit

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, MovieCollectionViewCellDelegate {

    private let searchView = SearchView()
    private var searchResults: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchView.searchResultsCollectionView.dataSource = self
        searchView.searchResultsCollectionView.delegate = self
        searchView.searchBar.delegate = self
        searchView.searchResultsCollectionView.delegate = self // Set delegate for MovieCollectionViewCellDelegate

        // Assign delegate to SearchView
        searchView.cellDelegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
        } else {
            fetchMovies(with: searchText)
        }
        searchView.searchResultsCollectionView.reloadData()
    }

    func fetchMovies(with query: String) {
        // Example movie fetching implementation
        NetworkManager.shared.searchMovies(query: query, page: 1) { [weak self] movies in
            guard let self = self else { return }
            self.searchResults = movies ?? []
            DispatchQueue.main.async {
                self.searchView.searchResultsCollectionView.reloadData()
            }
        }
    }

    // MARK: - UICollectionViewDataSource Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = searchResults[indexPath.item]
        cell.configure(with: movie)
        cell.delegate = self // Set the delegate for cell
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout Methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 24) / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }

    // MARK: - MovieCollectionViewCellDelegate Methods

    func didTapImageView(cell: MovieCollectionViewCell) {
        guard let indexPath = searchView.searchResultsCollectionView.indexPath(for: cell) else { return }
        let movie = searchResults[indexPath.item]
        showMovieDetailViewController(for: movie)
    }

    private func showMovieDetailViewController(for movie: Movie) {
        let movieDetailVC = MovieInfoViewController()
        movieDetailVC.readMovieDetail(movieID: movie.id)
        movieDetailVC.modalPresentationStyle = .pageSheet
        present(movieDetailVC, animated: true, completion: nil)
    }
}

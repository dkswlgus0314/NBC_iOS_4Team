//
//  FavoritesView.swift
//  MovieReservation_4Team
//
//  Created by 4Team on 7/22/24.

import UIKit
import SnapKit

class FavoritesView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FavoritesViewCellDelegate {

    // 영화 데이터 저장
    var movieData: [CollectionViewData] = []
    private var selectedMovieId: Int?
    var movieIds:[Int] = []
    
    // CollectionViewData 구조체 정의
    struct CollectionViewData {
        let title: String
        let posterPath: String?
        let backdropPath: String?
        let id: Int

        init(from movieDetail: MovieDetail) {
            self.title = movieDetail.title
            self.posterPath = movieDetail.posterPath
            self.backdropPath = movieDetail.backdropPath
            self.id = movieDetail.id
        }
    }

    // 컬렉션 뷰 설정
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
//        loadFavoriteMovies()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
//        loadFavoriteMovies()
    }

    // 컬렉션 뷰 설정
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func settingMovie() {
        guard let user = UserDataManager.shared.getCurrentLoggedInUser() else {
          return
        }
        movieIds.removeAll()
        if let favorites = user.favorites as? [FavoriteMovie] {
          for i in favorites {
            if let movieID = i.movieID, let id = Int(movieID) {
              movieIds.append(id)
            }
          }
        }
      }
    
    // 즐겨찾기 영화 로드
    func loadFavoriteMovies() {
        settingMovie()
            movieData.removeAll()
            let group = DispatchGroup()
            for movieID in movieIds {
              group.enter()
              NetworkManager.shared.fetchMovieDetail(movieId: movieID) { movieDetail in
                if let movieDetail = movieDetail {
                  let data = CollectionViewData(from: movieDetail)
                  self.movieData.append(data)
                }
                group.leave()
              }
            }
            group.notify(queue: .main) {
              self.collectionView.reloadData()
            }
          }

    func getUserFavoriteMovieIDs() -> [Int] {
        return [101, 102, 103, 104, 105, 106, 107, 108, 109]
    }

    // UICollectionViewDataSource 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! FavoritesViewCell
        let data = movieData[indexPath.item]
        cell.configure(with: data)
        cell.delegate = self
        return cell
    }

    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3
        return CGSize(width: width, height: width * 1.5)
    }

    // FavoritesViewCellDelegate 메서드
    func didTapImageView(cell: FavoritesViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let data = movieData[indexPath.item]
            selectedMovieId = data.id
            showMovieDetailViewController()
        }
    }

    func didToggleFavorite(cell: FavoritesViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            // 즐겨찾기에서 영화 제거
            movieData.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
    }

    func deleteMovie(movieData: CollectionViewData) {
       guard let user = UserDataManager.shared.getCurrentLoggedInUser() else {
         print("로그인된 유저 정보를 찾을 수 없습니다.")
         return
       }
       let movie = String(movieData.id) // 영화 ID를 문자열로 변환
       if let favorites = user.favorites as? [FavoriteMovie] {
         for i in favorites {
           if let movieId = i.movieID, movie == movieId {
             FavoriteManager.shared.deleteFavoriteMovie(favorite: i)
             break
           }
         }
       }
       loadFavoriteMovies()
     }
    
    // 영화 상세 정보 화면 표시
    private func showMovieDetailViewController() {
        guard let movieId = selectedMovieId else { return }
        let movieDetailVC = MovieInfoViewController()
        movieDetailVC.readMovieDetail(movieID: movieId)
        if let viewController = self.parentViewController {
            viewController.present(movieDetailVC, animated: true, completion: nil)
        }
    }
}

import UIKit
import CoreData
class MovieInfoViewController: UIViewController {
    let networkManager = NetworkManager.shared
    var movieInfoView = MovieInfoView()
    
    //main뷰컨에서 선택된 영화의 id.
    var userMovieId = 0  //현재 선택된 영화ID
    var isLike = false // 사용자가 좋아요를 눌렀는지 확인하기 위한 변수
    var movieLike: FavoriteMovie? = nil // 사용자가 좋아요를 눌러놨을 경우 가져올 FavoriteMovie데이터
    
    override func loadView() {
        view = movieInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieInfoView.reservationButton.addTarget(self, action: #selector(showModal), for: .touchDown)
        movieInfoView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchDown)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 즐겨찾기 상태 업데이트
        likeButtonSetting()
    }
    
    //MARK: -@objc
    // [예약하기] 버튼 클릭 시 모달 띄우기
    @objc
    func showModal(){
        let modalVc = ModalViewController()
        modalVc.userMovieId = self.userMovieId
        if let modal = modalVc.sheetPresentationController {
            modal.detents = [.medium()]
        }
        present(modalVc, animated: true)
    }
    
    
    // 좋아요를 눌렀는지 확인하고 하트 이미지를 세팅해줄 변수
      func likeButtonSetting() {
        guard let user = UserDataManager.shared.getCurrentLoggedInUser() else {
            print("로그인된 유저 정보를 찾을 수 없습니다.")
          return
        }
        let movie = String(userMovieId) // 영화 ID를 문자열로 변환
        if let favorites = user.favorites?.allObjects as? [FavoriteMovie] {
          for i in favorites {
            if let movieId = i.movieID, movie == movieId {
                print("저장된 데이터 영화ID :", movieId)
              movieLike = i
              isLike = true
              break
            }
          }
        }
        if isLike {
            movieInfoView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            movieInfoView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
      }
    // [즐겨찾기] 버튼 클릭 시 코어데이터에 추가 또는 삭제
      @objc func likeButtonTapped() {
        guard let user = UserDataManager.shared.getCurrentLoggedInUser() else {
            print("로그인된 유저 정보를 알 수 없습니다.")
          return
        }
        if let movieLike = movieLike, isLike {
          isLike = false
          self.movieLike = nil
          FavoriteManager.shared.deleteFavoriteMovie(favorite: movieLike)
                print(":네잎클로버::네잎클로버::네잎클로버:즐겨찾기 삭제!!:네잎클로버::네잎클로버::네잎클로버: ")
        } else {
          FavoriteManager.shared.addFavoriteMovie(movieID: String(userMovieId), user: user)
            print(":별2::별2::별2:즐겨찾기 추가!!:별2::별2::별2: ")
        }
        likeButtonSetting()
      }
    
    
    
    //MARK: -상세정보 불러오기
    func readMovieDetail(movieID: Int) {
        userMovieId = movieID
        
        // 특정 영화의 상세 정보 가져오기
        NetworkManager.shared.fetchMovieDetail(movieId: userMovieId) { movieDetail in
            
            if let movieDetail = movieDetail {
                DispatchQueue.main.async {
                    self.movieInfoView.movieTitleLabel.text = movieDetail.title
                    self.movieInfoView.openingDateLabel.text = movieDetail.releaseDate
                    self.movieInfoView.descriptionLabel.text = movieDetail.overview
                    self.movieInfoView.runningTimeLabel.text = "\(movieDetail.runtime)분"
                    self.movieInfoView.genreLabel.text = movieDetail.genres.map { $0.name }.joined(separator: "/")
                    if let posterPath = movieDetail.posterPath {
                        let fullPosterUrl = "https://image.tmdb.org/t/p/w500/\(posterPath)"
                        self.loadImage(from: fullPosterUrl)
                        //            NetworkManager.shared.loadImage(from: fullPosterUrl) { image in
                        //              self.movieInfoView.movieImageView.image = image
                        //            }
                    }
                }
            }
        }
        
        
        // 특정 영화의 평점 가져오기
        networkManager.fetchMovieRating(movieId: userMovieId) { rating in
            DispatchQueue.main.async {
                if let rating = rating {
                    // 평점을 문자열로 변환하여 UI 업데이트
                    self.movieInfoView.reviewScoreLabel.text = "평점 " + String(format: "%.1f", rating)
                } else {
                    self.movieInfoView.reviewScoreLabel.text = "Rating: Not Available"
                }
            }
        }
    }
    
    
    //MARK: -다운로드한 이미지를 movieInfoView.movieImageView에 설정
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // 네트워크에서 이미지 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error: Unable to load image data")
                return
            }
            
            // 메인 스레드에서 이미지 뷰 업데이트
            DispatchQueue.main.async {
                self.movieInfoView.movieImageView.image = image
            }
        }.resume()
    }
}

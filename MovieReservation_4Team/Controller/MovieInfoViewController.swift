import UIKit
import CoreData
class MovieInfoViewController: UIViewController {
    let networkManager = NetworkManager.shared
    var movieInfoView = MovieInfoView()
    
    //main뷰컨에서 선택된 영화의 id.
    var userMovieId = 0  //현재 선택된 영화ID
    
    
    override func loadView() {
        view = movieInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieInfoView.reservationButton.addTarget(self, action: #selector(showModal), for: .touchDown)
        
        movieInfoView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchDown)
        
        // 즐겨찾기 상태 업데이트
             
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          // 화면이 나타날 때마다 즐겨찾기 상태 업데이트
         
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
    
    
    // [즐겨찾기] 버튼 클릭 시 코어데이터에 추가 또는 삭제
    @objc func likeButtonTapped() {
        guard let user = UserDataManager.shared.getCurrentLoggedInUser() else {
            print("로그인된 유저 정보를 찾을 수 없습니다.")
            return
        }
        
        let context = FavoriteManager.shared.persistentContainer.viewContext
        let movieID = String(userMovieId) // 영화 ID를 문자열로 변환
        
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        // UserData의 id를 사용하여 비교합니다.
        fetchRequest.predicate = NSPredicate(format: "movieID == %@ AND user.id == %@", movieID, user.id!)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteMovie = results.first {
                if favoriteMovie.isLiked {  //false라면
                    // 즐겨찾기에서 제거
                    FavoriteManager.shared.deleteFavoriteMovie(favorite: favoriteMovie)
                    movieInfoView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    print("🍀🍀🍀즐겨찾기 삭제!!🍀🍀🍀 ")
                } else {
                    // 즐겨찾기에 추가
                    favoriteMovie.isLiked = true
                    FavoriteManager.shared.saveContext()
                    movieInfoView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    print("🌟🌟🌟즐겨찾기 추가!!🌟🌟🌟 ")
                }
            } else {
                // 새로운 즐겨찾기 영화 생성
                FavoriteManager.shared.addFavoriteMovie(movieID: movieID, user: user)
                movieInfoView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                print("🌟🌟🌟새로운 즐겨찾기 영화 생성???🌟🌟🌟 ")
                print()
            }
            
        } catch {
            print("Failed to fetch favorite movie: \(error.localizedDescription)")
        }
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

//
//  NetworkManager.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/23/24.
//


import Foundation
import UIKit // UIKit을 추가합니다.

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "c272149d0f0d1ed77d32b7d71522185e"
    private let baseUrl = "https://api.themoviedb.org/3"

    private init() {}

    //MARK: -이미지 로드
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
           guard let url = URL(string: urlString) else {
               completion(nil)
               return
           }
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   completion(nil)
                   return
               }
               let image = UIImage(data: data)
               DispatchQueue.main.async {
                   completion(image)
               }
           }.resume()
       }

    // MARK: - 가로 이미지 가져오기
      func fetchMovieBackdropImage(movieId: Int, completion: @escaping (String?) -> Void) {
          
          let urlString = "\(baseUrl)/movie/\(movieId)?api_key=\(apiKey)&language=ko-KR"
          
          guard let url = URL(string: urlString) else {
              print("Invalid URL")
              completion(nil)
              return
          }

          let task = URLSession.shared.dataTask(with: url) { data, response, error in
              if let error = error {
                  print("Error: \(error.localizedDescription)")
                  completion(nil)
                  return
              }

              guard let data = data else {
                  print("No data returned")
                  completion(nil)
                  return
              }

              do {
                  let decoder = JSONDecoder()
                  let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                  completion(movieDetail.backdropPath)
              } catch let jsonError {
                  print("JSON error: \(jsonError.localizedDescription)")
                  completion(nil)
              }
          }

          task.resume()
      }

    //MARK: -실시간 인기 영화 가져오기
    func fetchPopularMovies(page: Int, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseUrl)/movie/popular?api_key=\(apiKey)&language=ko-KR&region=KR&page=\(page)"

        fetchMovies(with: urlString, completion: completion)
    }


    // MARK: - 개봉 예정 영화 가져오기
    func fetchUpcomingMovies(page: Int, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseUrl)/movie/upcoming?api_key=\(apiKey)&language=ko-KR&region=KR&page=\(page)"
        fetchMovies(with: urlString, completion: completion)
    }


    // MARK: - 추천 영화 가져오기
    func fetchRecommendedMovies(movieId: Int, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseUrl)/movie/\(movieId)/recommendations?api_key=\(apiKey)&language=ko-KR&region=KR"
        fetchMovies(with: urlString, completion: completion)
    }

    //MARK: -최신 개봉 영화 가져오기
    func fetchNowPlayingMovies(page: Int, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseUrl)/movie/now_playing?api_key=\(apiKey)&language=ko-KR&region=KR&page=\(page)"

        fetchMovies(with: urlString, completion: completion)
    }


    // MARK: - 영화 검색하기
    func searchMovies(query: String, page: Int, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseUrl)/search/movie?api_key=\(apiKey)&language=ko-KR&query=\(query)&page=\(page)"
        fetchMovies(with: urlString, completion: completion)
    }


    //MARK: -장르별 영화 검색
    // genreId - 액션: 28/ 애니메이션 : 16/ 공포 : 27/ 로맨스: 10749 / 코미디 : 35
    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseUrl)/discover/movie?api_key=\(apiKey)&language=ko-KR&with_genres=\(genreId)&page=\(page)"
        fetchMovies(with: urlString, completion: completion)
    }


    //MARK: - 특정 영화의 평점 가져오기
    func fetchMovieRating(movieId: Int, completion: @escaping (Double?) -> Void) {
        let urlString = "\(baseUrl)/movie/\(movieId)?api_key=\(apiKey)&language=ko-KR"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                completion(movieDetail.voteAverage)
            } catch let jsonError {
                print("JSON error: \(jsonError.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }

    //MARK: -영화 리뷰 보기
    func fetchMovieReviews(movieId: Int, completion: @escaping ([Review]?) -> Void) {
        let urlString = "\(baseUrl)/movie/\(movieId)/reviews?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                print(error)
                return
            }
            
            do {
                let reviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: data)
                completion(reviewResponse.results)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }


    //MARK: -특정 영화 상세 정보 가져오기
    func fetchMovieDetail(movieId: Int, completion: @escaping (MovieDetail?) -> Void) {
        
        let urlString = "\(baseUrl)/movie/\(movieId)?api_key=\(apiKey)&language=ko-KR"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                completion(movieDetail)
            } catch let jsonError {
                print("JSON error: \(jsonError.localizedDescription)")
                print(String(data: data, encoding: .utf8) ?? "No readable data")
                completion(nil)
            }
        }

        task.resume()
    }


    //MARK: - 공통 영화 가져오기 메서드 추가
    private func fetchMovies(with urlString: String, completion: @escaping ([Movie]?) -> Void) {

        //urlString을 URL 객체로 변환하고 유효성을 검사
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        //비동기적으로 네트워크 요청을 수행
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
            
            // JSON 디코딩 - 디코딩 성공 시 completion(movieDetail) 호출
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieResponse.self, from: data)
                completion(result.results)
            } catch let jsonError {
                print("JSON error: \(jsonError.localizedDescription)")
                print(String(data: data, encoding: .utf8) ?? "No readable data")
                completion(nil)
            }
        }

        task.resume()

    }
}

//MARK: -MovieResponse
struct MovieResponse: Decodable {
    let results: [Movie]
}

//
//  ThirdViewController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0112 on 7/23/24.
//
import UIKit
import SnapKit
import CoreData

class ReservationController: UIViewController {

    private let reservaitionView: ReservaitionView = {
        let view = ReservaitionView()
        view.backgroundColor = UIColor.mainBlack
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reservation"
        setupUI()
        configureView()
        loadReservationData()
    }

    private func setupUI() {
        view.addSubview(reservaitionView)
        reservaitionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureView() {
        let posterUrlString = "https://api.example.com/path/to/poster" // 포스터 이미지의 URL

        NetworkManager.shared.loadImage(from: posterUrlString) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.reservaitionView.configure(with: image)
                    print("영화 포스터 이미지를 성공적으로 로드했습니다.")
                } else {
                    print("영화 포스터 이미지 로드에 실패했습니다.")
                }
            }
        }
    }

    private func getCurrentUserId() -> String? {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(value: true))

        do {
            let results = try UserDataManager.shared.context.fetch(fetchRequest)
            if let userId = results.first?.id {
                print("로그인된 사용자 ID: \(userId)")
                return userId
            } else {
                print("로그인된 사용자가 없습니다.")
                return nil
            }
        } catch {
            print("현재 사용자를 가져오는 데 실패했습니다: \(error)")
            return nil
        }
    }

    private func loadReservationData() {
        guard let userId = getCurrentUserId() else {
            print("로그인된 사용자를 찾을 수 없습니다.")
            return
        }

        let reservations = ReservationManager.shared.fetchReservations(for: userId)

        if reservations.isEmpty {
            reservaitionView.updateReservationInfo(with: nil)
            print("예매된 영화가 없습니다.")
        } else {
            for reservation in reservations {
                fetchMovieDetail(movieId: reservation.movieID ?? "") { movieDetail in
                    guard let movieDetail = movieDetail else {
                        print("영화 세부 정보를 가져오는 데 실패했습니다.")
                        return
                    }

                    let posterUrlString = "https://image.tmdb.org/t/p/w500\(movieDetail.posterPath ?? "")"

                    NetworkManager.shared.loadImage(from: posterUrlString) { image in
                        DispatchQueue.main.async {
                            if let image = image {
                                self.reservaitionView.configure(with: image)
                                print("영화 포스터 이미지를 성공적으로 로드했습니다.")
                            } else {
                                print("영화 포스터 이미지 로드에 실패했습니다.")
                            }
                        }
                    }

                    DispatchQueue.main.async {
                        // Reservationticket을 ReservaitionView.Reservation으로 변환
                        let reservationData = ReservaitionView.Reservation(
                            movieID: reservation.movieID,
                            date: reservation.date,
                            quantity: Int(reservation.quantity) // Core Data에서의 quantity는 Int32 타입입니다.
                        )
                        self.reservaitionView.updateReservationInfo(with: reservationData)
                    }
                }
            }
        }
    }

    private func fetchMovieDetail(movieId: String, completion: @escaping (MovieDetail?) -> Void) {
        guard let movieIdInt = Int(movieId) else {
            print("유효하지 않은 영화 ID: \(movieId)")
            completion(nil)
            return
        }

        NetworkManager.shared.fetchMovieDetail(movieId: movieIdInt, completion: completion)
    }
}

#Preview("ReservationController") { ReservationController() }

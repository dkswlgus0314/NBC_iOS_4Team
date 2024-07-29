//
//  ReservationViewModel.swift
//  MovieReservation_4Team
//
//  Created by Lee juhee on 7/24/24.
//


import UIKit
import CoreData

class ReservationViewModel {
    var reservations: [(ReservationView.Reservation, UIImage?)] = []

    func loadReservationData(completion: @escaping () -> Void) {
        guard let userId = getCurrentUserId() else {
            print("현재 사용자 ID를 가져올 수 없습니다.") // 💖 디버깅 로그 추가
            completion()
            return
        }

        let reservationTickets = ReservationManager.shared.fetchReservations(for: userId)
        print("불러온 예매 내역 수: \(reservationTickets.count)") // 💖 디버깅 로그 추가

        if reservationTickets.isEmpty {
            completion()
        } else {
            let dispatchGroup = DispatchGroup()
            var loadedReservations: [(ReservationView.Reservation, UIImage?)] = []

            for reservation in reservationTickets {
                dispatchGroup.enter()
                fetchMovieDetail(movieId: reservation.movieID ?? "") { movieDetail in
                    guard let movieDetail = movieDetail else {
                        print("영화 정보를 불러올 수 없습니다. 영화 ID: \(reservation.movieID ?? "")") // 💖 디버깅 로그 추가
                        dispatchGroup.leave()
                        return
                    }

                    let posterUrlString = "https://image.tmdb.org/t/p/w500\(movieDetail.posterPath ?? "")"
                    NetworkManager.shared.loadImage(from: posterUrlString) { image in
                        let reservationData = ReservationView.Reservation(
                            movieID: reservation.movieID,
                            date: reservation.date,
                            quantity: Int(reservation.quantity),
                            reservationID: reservation.reservationID!
                        )
                        loadedReservations.append((reservationData, image))
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.reservations = loadedReservations
                print("로딩된 예매 내역: \(self.reservations.map { $0.0.reservationID.uuidString })") // 💖 디버깅 로그 추가
                completion()
            }
        }
    }

    private func getCurrentUserId() -> String? {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(value: true))

        do {
            let results = try UserDataManager.shared.context.fetch(fetchRequest)
            let userId = results.first?.id
            print("현재 사용자 ID: \(userId ?? "없음")") // 💖 디버깅 로그 추가
            return userId
        } catch {
            print("현재 사용자 ID를 가져오는 중 오류 발생: \(error)") // 💖 디버깅 로그 추가
            return nil
        }
    }

    private func fetchMovieDetail(movieId: String, completion: @escaping (MovieDetail?) -> Void) {
        guard let movieIdInt = Int(movieId) else {
            completion(nil)
            return
        }
        NetworkManager.shared.fetchMovieDetail(movieId: movieIdInt, completion: completion)
    }
}

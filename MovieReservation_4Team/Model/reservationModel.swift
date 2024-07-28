//
//  reservationModel.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/28/24.
//

import UIKit
import CoreData

class ReservationViewModel {
    private var reservations: [Reservationticket] = []

    func loadReservationData(completion: @escaping (UIImage?, ReservaitionView.Reservation?) -> Void) {
        guard let userId = getCurrentUserId() else {
            completion(nil, nil)
            return
        }

        reservations = ReservationManager.shared.fetchReservations(for: userId)

        if reservations.isEmpty {
            completion(nil, nil)
        } else {
            for reservation in reservations {
                fetchMovieDetail(movieId: reservation.movieID ?? "") { movieDetail in
                    guard let movieDetail = movieDetail else {
                        completion(nil, nil)
                        return
                    }

                    let posterUrlString = "https://image.tmdb.org/t/p/w500\(movieDetail.posterPath ?? "")"
                    NetworkManager.shared.loadImage(from: posterUrlString) { image in
                        let reservationData = ReservaitionView.Reservation(
                            movieID: reservation.movieID,
                            date: reservation.date,
                            quantity: Int(reservation.quantity)
                        )
                        completion(image, reservationData)
                    }
                }
            }
        }
    }

    private func getCurrentUserId() -> String? {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(value: true))

        do {
            let results = try UserDataManager.shared.context.fetch(fetchRequest)
            return results.first?.id
        } catch {
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

import UIKit
import CoreData

class ReservationViewModel {
    var reservations: [(ReservaitionView.Reservation, UIImage?)] = []

    func loadReservationData(completion: @escaping () -> Void) {
        guard let userId = getCurrentUserId() else {
            completion()
            return
        }

        let reservationTickets = ReservationManager.shared.fetchReservations(for: userId)

        if reservationTickets.isEmpty {
            completion()
        } else {
            let dispatchGroup = DispatchGroup()
            var loadedReservations: [(ReservaitionView.Reservation, UIImage?)] = []

            for reservation in reservationTickets {
                dispatchGroup.enter()
                fetchMovieDetail(movieId: reservation.movieID ?? "") { movieDetail in
                    guard let movieDetail = movieDetail else {
                        dispatchGroup.leave()
                        return
                    }

                    let posterUrlString = "https://image.tmdb.org/t/p/w500\(movieDetail.posterPath ?? "")"
                    NetworkManager.shared.loadImage(from: posterUrlString) { image in
                        let reservationData = ReservaitionView.Reservation(
                            movieID: reservation.movieID,
                            date: reservation.date,
                            quantity: Int(reservation.quantity)
                        )
                        loadedReservations.append((reservationData, image))
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.reservations = loadedReservations
                completion()
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

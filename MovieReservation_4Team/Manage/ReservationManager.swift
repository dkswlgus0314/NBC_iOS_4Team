//
//  ReservationManager.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/26/24.
//
//
//date: Date?
// movieID: String?
// quantity: Int32
//reservationID: UUID?
//user: UserData?

import UIKit
import CoreData
class ReservationManager {

    static let shared = ReservationManager()

    private let userDataManager = UserDataManager.shared

    // 영화 예매 정보 저장
    func saveReservation(movieID: Int, quantity: Int32, date: Date, userId: String) {
        let context = userDataManager.context

        // 사용자 조회
        let userFetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userId)

        do {
            let users = try context.fetch(userFetchRequest)
            guard let user = users.first else {
                print("User with id \(userId) not found")
                return
            }

            // 새로운 예약 객체 생성
            let newReservation = Reservationticket(context: context)
            newReservation.movieID = String(movieID)
            newReservation.quantity = quantity
            newReservation.date = date
            newReservation.reservationID = UUID()
            newReservation.user = user

            // 사용자 객체에 예약 추가
            user.addToReservations(newReservation)

            // 저장 후 로그 출력
            saveReservationContext()
            print("영화 ID \(movieID)에 대한 예약이 성공적으로 저장되었습니다. 수량: \(quantity), 날짜: \(date)")

            // 저장된 예약을 출력
            let reservations = fetchReservations(for: userId)
            print("저장된 예약 내역: \(reservations)")

        } catch {
            print("사용자 조회 또는 예약 저장 실패: \(error)")
        }
    }

    private func saveReservationContext() {
        do {
            try userDataManager.context.save()
        } catch {
            if let nserror = error as? NSError {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            } else {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    // 특정 사용자에 대한 예매 내역을 조회합니다.
    func fetchReservations(for userId: String) -> [Reservationticket] {
        let context = userDataManager.context
        let fetchRequest: NSFetchRequest<Reservationticket> = Reservationticket.fetchRequest()

        // 사용자 조회
        let userFetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userId)

        do {
            let users = try context.fetch(userFetchRequest)
            guard let user = users.first else {
                print("User with id \(userId) not found")
                return []
            }

            // 사용자 기반 예매 내역 조회
            fetchRequest.predicate = NSPredicate(format: "user == %@", user)
            let reservations = try context.fetch(fetchRequest)
            return reservations
        } catch {
            print("Failed to fetch reservations: \(error)")
            return []
        }
    }
    
    // 예매 내역 삭제
    func removeReservation(_ reservation: Reservationticket) {
        userDataManager.context.delete(reservation)
        saveReservationContext()
    }

    // 다수 예매 내역 삭제
    func removeReservations(_ reservations: Set<Reservationticket>) {
        for reservation in reservations {
            userDataManager.context.delete(reservation)
        }
        saveReservationContext()
    }
}

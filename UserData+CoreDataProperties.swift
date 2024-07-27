//
//  UserData+CoreDataProperties.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0117 on 7/25/24.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var userprofile: Data?
    @NSManaged public var reservations: NSSet?
    @NSManaged public var favorites: NSSet?
    @NSManaged public var isLoggedIn: Bool


    // 예매내역
    @objc(addReservationsObject:)
    @NSManaged public func addToReservations(_ value: Reservationticket)

    @objc(removeReservationsObject:)
    @NSManaged public func removeFromReservations(_ value: Reservationticket)

    @objc(addReservations:)
    @NSManaged public func addToReservations(_ values: NSSet)

    @objc(removeReservations:)
    @NSManaged public func removeFromReservations(_ values: NSSet)

    // 즐겨찾기
    @objc(addFavoriteMoviesObject:)
    @NSManaged public func addToFavoriteMovies(_ value: FavoriteMovie)

    @objc(removeFavoriteMoviesObject:)
    @NSManaged public func removeFromFavoriteMovies(_ value: FavoriteMovie)

    @objc(addFavoriteMovies:)
    @NSManaged public func addToFavoriteMovies(_ values: NSSet)

    @objc(removeFavoriteMovies:)
    @NSManaged public func removeFromFavoriteMovies(_ values: NSSet)
}

extension UserData : Identifiable {}

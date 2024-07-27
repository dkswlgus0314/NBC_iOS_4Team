//
//  Reservation+CoreDataProperties.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/26/24.
//
//

import Foundation
import CoreData


extension Reservationticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservationticket> {
        return NSFetchRequest<Reservationticket>(entityName: "Reservationticket")
    }

    @NSManaged public var date: Date?
    @NSManaged public var movieID: String?
    @NSManaged public var quantity: Int32
    @NSManaged public var reservationID: UUID?
    @NSManaged public var user: UserData?

}

extension Reservationticket : Identifiable {

}

//
//  FavoriteMovie+CoreDataProperties.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/26/24.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var favoriteID: UUID?
       @NSManaged public var movieID: String?
       @NSManaged public var user: UserData?
       @NSManaged public var isLiked: Bool
}

extension FavoriteMovie : Identifiable {

}

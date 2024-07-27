//
//  Movie.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/24/24.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

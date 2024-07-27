//
//  Genre.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/26/24.
//

import Foundation

// 장르 모델
struct Genre: Decodable {
    let id: Int
    let name: String
}

// 장르 응답 모델
struct GenreResponse: Decodable {
    let genres: [Genre]
}

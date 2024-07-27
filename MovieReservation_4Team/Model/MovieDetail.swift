//
//  MovieDetail.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/24/24.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let genres: [Genre]
    let voteAverage: Double
    let runtime: Int
    let posterPath: String?
    let backdropPath: String? // 가로 이미지를 위한 추가 필드
    
    struct Genre: Decodable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case genres
        case voteAverage = "vote_average"
        case runtime
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path" // 추가된 가로 이미지 필드
    }
}

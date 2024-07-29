//
//  Reviews.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/29/24.
//

import Foundation


struct Review: Decodable {
    let author: String
    let content: String
}

struct ReviewResponse: Decodable {
    let results: [Review]
}

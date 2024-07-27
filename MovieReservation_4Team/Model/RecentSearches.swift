//
//  RecentSearches.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0117 on 7/24/24.
//

// MARK: - 최근 검색 관리
import Foundation

class RecentSearches {
    private(set) var searches: [String] = []

    func addSearch(_ search: String) {
        if !searches.contains(search) {
            searches.insert(search, at: 0)
        }
    }

    func removeSearch(at index: Int) {
        if index >= 0 && index < searches.count {
            searches.remove(at: index)
        }
    }

    func clearAllSearches() {
        searches.removeAll()
    }
}


//
//  BookmarkController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/24/24.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoritesView()
        self.title = "Wish list"
    }
    
    private func setupFavoritesView() {
        let favoritesView = FavoritesView()
        view.addSubview(favoritesView)
        
        favoritesView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

#Preview {
    let FavoritesViewController = FavoritesViewController()
    return FavoritesViewController
}

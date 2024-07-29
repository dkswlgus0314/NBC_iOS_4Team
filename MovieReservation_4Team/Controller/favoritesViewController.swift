//
//  BookmarkController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/24/24.
//

import UIKit
import SnapKit
class FavoritesViewController: UIViewController {
    let favoritesView = FavoritesView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoritesView()
        self.title = "Wish list"
        NotificationCenter.default.addObserver(self, selector: #selector(movieInfoViewControllerDidDismiss), name: Notification.Name("MovieInfoViewControllerDidDismiss"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MovieInfoViewControllerDidDismiss"), object: nil)
    }
    @objc func movieInfoViewControllerDidDismiss() {
        // 모달 창이 닫힌 후에 새로고침 작업 수행
        favoritesView.loadFavoriteMovies()
    }
    private func setupFavoritesView() {
        view.addSubview(favoritesView)
        favoritesView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("test")
        favoritesView.loadFavoriteMovies()
    }
}









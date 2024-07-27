//
//  BookmarkVC.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/23/24.
//

import UIKit
import SnapKit

class BookmarkController: UIViewController {

    private let bookmarkView = BookmarkView()

    override func loadView() {
        view = bookmarkView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 타이틀 설정
        navigationItem.title = "Bookmark"

        // 오른쪽 바 버튼 설정
        let myPageButton = UIBarButtonItem(title: "My Page", style: .plain, target: self, action: #selector(myPageButtonTapped))
        navigationItem.rightBarButtonItem = myPageButton
    }

    @objc private func myPageButtonTapped() {
        let myPage = MyPageController()
        navigationController?.pushViewController(myPage, animated: true)
    }
}

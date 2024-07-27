//
//  File.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/24/24.
//

import UIKit
import SnapKit

class FavoriteMovieCell: UICollectionViewCell {

    static let identifier = "FavoriteMovieCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        return button
    }()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontNames.subFont.font()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomCell()
        setupCellConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCustomCell() {
        // 서브뷰를 contentView에 추가
        [imageView, favoriteButton, movieTitleLabel].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupCellConstraints() {
        // 이미지뷰
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.5)  // 너비에 비례하여 높이 설정
        }

        // 즐겨찾기 버튼
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.height.equalTo(24)
        }

        // 영화 제목 레이블
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}

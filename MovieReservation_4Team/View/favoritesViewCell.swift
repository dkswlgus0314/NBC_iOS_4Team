//
//  favoritesViewCell.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/24/24.
//

import UIKit
import SnapKit

// FavoritesViewCellDelegate 프로토콜 정의
protocol FavoritesViewCellDelegate: AnyObject {
    func didTapImageView(cell: FavoritesViewCell)   // 이미지 뷰가 클릭되었을 때 호출되는 메서드
    func didToggleFavorite(cell: FavoritesViewCell)  // 하트 버튼이 클릭되었을 때 호출되는 메서드
}

class FavoritesViewCell: UICollectionViewCell {

    weak var delegate: FavoritesViewCellDelegate?

    // MARK: - UI 요소 정의
    private let containerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FontNames.subFont2.font()  // 이 부분은 FontNames가 정의되어 있어야 합니다.
        label.textColor = UIColor.mainWhite
        label.numberOfLines = 0 // 여러 줄 설정
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heartimage"), for: .normal) // 빈 하트 이미지
        button.setImage(UIImage(named: "heartfilledimage"), for: .selected) // 채워진 하트 이미지
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)

        // 스냅킷을 사용한 오토레이아웃 설정
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(containerView)
        }

        favoriteButton.snp.makeConstraints {
            $0.bottom.equalTo(imageView.snp.bottom).inset(4)
            $0.trailing.equalTo(imageView.snp.trailing).inset(4)
            $0.width.height.equalTo(30)
        }
    }

    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }

    // 이미지 뷰 탭 시 호출되는 메서드
    @objc private func imageViewTapped() {
        delegate?.didTapImageView(cell: self)
    }

    // 하트 버튼 탭 시 호출되는 메서드
    @objc private func toggleFavorite() {
        favoriteButton.isSelected.toggle()
        delegate?.didToggleFavorite(cell: self)
        print("toggleFavorite 호출됨")
    }

    // 셀 데이터 설정
    func configure(with data: FavoritesView.CollectionViewData) {
        if let posterPath = data.posterPath {
            let fullPosterUrl = "https://image.tmdb.org/t/p/w500/\(posterPath)"
            loadImage(from: fullPosterUrl)
        }
        titleLabel.text = data.title
    }

    // 이미지 다운로드 및 설정
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지 로딩 에러: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("이미지 데이터 로딩 에러")
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}

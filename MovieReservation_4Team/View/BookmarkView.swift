//
//  BookmarkView.swift
//  MovieReservation_4Team
//
//  Created by 4Team on 7/22/24.
//
import UIKit
import SnapKit

class BookmarkView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 제목 레이블
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 영화 목록"
        label.textColor = UIColor.mainRed
        label.font = FontNames.mainFont.font()
        return label
    }()

    let userButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.tintColor = .red
        return button
    }()

    // 컬렉션 뷰를 설정하는 클로저
    let favoriteMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        return collectionView
    }()

    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        favoriteMoviesCollectionView.dataSource = self
        favoriteMoviesCollectionView.delegate = self
        favoriteMoviesCollectionView.register(FavoriteMovieCell.self, forCellWithReuseIdentifier: FavoriteMovieCell.identifier)  // 셀 등록
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        [titleLabel, favoriteMoviesCollectionView].forEach { self.addSubview($0) }

        backgroundColor = UIColor.mainBlack
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }

        favoriteMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - UICollectionViewDataSource

    // 컬렉션 뷰의 섹션당 아이템 수를 반환합니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20  // 예시를 위해 20개의 아이템을 반환합니다.
    }

    // 특정 인덱스 경로에 있는 아이템에 대한 셀을 반환합니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMovieCell.identifier, for: indexPath) as? FavoriteMovieCell else {
            return UICollectionViewCell()  // 셀을 dequeue하지 못하면 기본 셀 반환
        }
        // 예시 데이터 설정
        cell.imageView.image = UIImage(systemName: "film")  // 아이콘 이미지 설정
        cell.movieTitleLabel.text = "영화 제목 \(indexPath.item + 1)"  // 영화 제목 설정
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    // 셀의 크기를 반환합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16  // 셀 간의 여백 설정
        let width = (collectionView.frame.width - padding * 4) / 3  // 3열 레이아웃을 위한 셀 너비 계산
        return CGSize(width: width, height: width * 1.5)  // 셀 크기 설정 (비율: 2:3)
    }
}

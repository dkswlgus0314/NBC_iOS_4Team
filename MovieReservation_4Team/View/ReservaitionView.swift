//
//  reservaitionView.swift
//  MovieReservation_4Team
//
//  Created by 4Team on 7/22/24.
//

import UIKit
import SnapKit

class ReservaitionView: UIView {

    // MARK: - UI 요소 정의
    private let ticketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let movieImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .red
        return imageView
    }()

    private let separatorLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray // 실선 색상
        return view
    }()

    private let separatorLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray // 실선 색상
        return view
    }()

    private let runTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FontNames.subFont.font()
        label.textColor = UIColor.mainBlack

        // 심볼 이미지 설정
        let clockImage = UIImage(systemName: "clock")?.withRenderingMode(.alwaysTemplate)
        let attachment = NSTextAttachment()
        attachment.image = clockImage

        // 심볼의 크기를 조정
        let imageSize = CGSize(width: 18, height: 18) // 원하는 크기로 조정
        attachment.bounds = CGRect(origin: .zero, size: imageSize)

        // 텍스트 추가
        let textString = NSAttributedString(string: " 0h 00m")

        // attributedString 생성
        let attributedString = NSMutableAttributedString()

        // 심볼을 포함한 NSAttributedString 생성
        let symbolString = NSAttributedString(attachment: attachment)
        attributedString.append(symbolString)
        attributedString.append(textString)

        // baselineOffset을 조정하여 심볼과 텍스트의 수직 정렬을 맞춥니다.
        let baselineOffset: CGFloat = -4 // 적절한 값으로 조정

        // 심볼에 baselineOffset을 적용
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: symbolString.length))

        label.attributedText = attributedString
        return label
    }()

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "영화제목"
        label.textAlignment = .center
        label.font = FontNames.mainFont.font()
        label.textColor = UIColor.mainBlack
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "0월 0일 0시 0분"
        label.textAlignment = .center
        label.font = FontNames.subFont3.font()
        label.textColor = UIColor.mainBlack
        return label
    }()

    private let ticketQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "00명"
        label.textAlignment = .center
        label.font = FontNames.subFont2.font()
        label.textColor = UIColor.mainBlack
        return label
    }()

    let noReservationLabel: UILabel = {
        let label = UILabel()
        label.text = "예매된 영화가 없습니다"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isHidden = true // 초기에는 숨김
        return label
    }()

    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        [
            ticketImageView,
            movieImageview,
            runTimeLabel,
            movieTitleLabel,
            dateLabel,
            ticketQuantityLabel,
            separatorLine1,
            separatorLine2,
            noReservationLabel
        ].forEach { self.addSubview($0) }

        ticketImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview().offset(-120)
        }

        movieImageview.snp.makeConstraints {
            $0.top.equalTo(ticketImageView.snp.top).offset(20)
            $0.leading.equalTo(ticketImageView.snp.leading).offset(36)
            $0.trailing.equalTo(ticketImageView.snp.trailing).offset(-36)
            $0.height.equalTo(movieImageview.snp.width).multipliedBy(1.2)
        }

        runTimeLabel.snp.makeConstraints {
            $0.top.equalTo(movieImageview.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }

        separatorLine1.snp.makeConstraints {
            $0.top.equalTo(runTimeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(ticketImageView.snp.leading).offset(80)
            $0.trailing.equalTo(ticketImageView.snp.trailing).offset(-80)
            $0.height.equalTo(1) // 실선의 두께
        }

        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine1.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        separatorLine2.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(ticketImageView.snp.leading).offset(36)
            $0.trailing.equalTo(ticketImageView.snp.trailing).offset(-36)
            $0.height.equalTo(1) // 실선의 두께
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine2.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }

        ticketQuantityLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        noReservationLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - 데이터 구성
    func configure(with ticketImage: UIImage?, movieImage: UIImage?) {
        ticketImageView.image = ticketImage
        movieImageview.image = movieImage
    }

    func showNoReservationMessage() {
        noReservationLabel.isHidden = false
        ticketImageView.isHidden = true
        movieImageview.isHidden = true
        runTimeLabel.isHidden = true
        movieTitleLabel.isHidden = true
        dateLabel.isHidden = true
        ticketQuantityLabel.isHidden = true
        separatorLine1.isHidden = true
        separatorLine2.isHidden = true
    }

    func hideNoReservationMessage() {
        noReservationLabel.isHidden = true
        ticketImageView.isHidden = false
        movieImageview.isHidden = false
        runTimeLabel.isHidden = false
        movieTitleLabel.isHidden = false
        dateLabel.isHidden = false
        ticketQuantityLabel.isHidden = false
        separatorLine1.isHidden = false
        separatorLine2.isHidden = false
    }
}

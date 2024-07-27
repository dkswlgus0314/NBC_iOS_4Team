//
//  reservaitionView.swift
//  MovieReservation_4Team
//
//  Created by 4Team on 7/22/24.
//

import UIKit
import SnapKit

class ReservaitionView: UIView {
    struct Reservation {
        var movieID: String?
        var date: Date?
        var quantity: Int
    }
    // MARK: - UI 요소 정의
    private let ticketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let movieImageView: UIImageView = {
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
        label.font = FontNames.subFont2.font()
        label.textColor = UIColor.mainBlack

        // 심볼 이미지 설정
        let clockImage = UIImage(systemName: "clock")
        if clockImage == nil {
            print("경고: 'clock' 심볼을 찾을 수 없습니다.")
        }

        let attachment = NSTextAttachment()
        attachment.image = clockImage

        // 심볼의 크기를 조정
        let imageSize = CGSize(width: 15, height: 15) // 원하는 크기로 조정
        attachment.bounds = CGRect(origin: .zero, size: imageSize)

        // 텍스트 추가
        let textString = NSAttributedString(string: " 0h 00m")

        // attributedString 생성
        let attributedString = NSMutableAttributedString()

        // 심볼을 포함한 NSAttributedString 생성
        let symbolString = NSAttributedString(attachment: attachment)
        attributedString.append(symbolString)
        attributedString.append(textString)

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
        label.font = FontNames.subFont2.font()
        label.textColor = UIColor.mainBlack
        label.numberOfLines = 0 // 여러 줄을 표시하도록 설정
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
            movieImageView,
            runTimeLabel,
            movieTitleLabel,
            dateLabel,
            ticketQuantityLabel,
            separatorLine1,
            separatorLine2,
        ].forEach { self.addSubview($0) }

        ticketImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview().offset(-120)
        }

        movieImageView.snp.makeConstraints {
            $0.top.equalTo(ticketImageView.snp.top).offset(20)
            $0.leading.equalTo(ticketImageView.snp.leading).offset(36)
            $0.trailing.equalTo(ticketImageView.snp.trailing).offset(-36)
            $0.height.equalTo(movieImageView.snp.width).multipliedBy(1.2)
        }

        runTimeLabel.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(60)
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
    }


    // MARK: - 데이터 구성
    func configure(with movieImage: UIImage?) {
        ticketImageView.image = UIImage(named: "ticket")
        movieImageView.image = movieImage
        print("영화 이미지를 설정했습니다. 영화 이미지: \(String(describing: movieImage))")
    }

    func updateReservationInfo(with reservation: Reservation?) {
        // 기본 날짜 포맷 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"

        // 시간 포맷 설정
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH시 mm분"

        // 예매 정보가 있는 경우 영화 정보 조회
        if let reservation = reservation, let movieIDString = reservation.movieID, let movieID = Int(movieIDString) {
            NetworkManager.shared.fetchMovieDetail(movieId: movieID) { [weak self] movieDetail in
                DispatchQueue.main.async {
                    if let movieDetail = movieDetail {
                        // 영화 정보가 있는 경우 UI 업데이트
                        self?.movieTitleLabel.text = "\(movieDetail.title)"
                        self?.runTimeLabel.text = " runtime : \(movieDetail.runtime)분"
                    } else {
                        // 영화 정보가 없는 경우
                        self?.movieTitleLabel.text = "영화 제목 : 알 수 없음"
                        self?.runTimeLabel.text = "상영 시간 : 정보 없음"
                    }

                    // 날짜와 시간 포맷 설정
                    let formattedDate = dateFormatter.string(from: reservation.date ?? Date())
                    let formattedTime = timeFormatter.string(from: reservation.date ?? Date())

                    self?.dateLabel.text = "상영 시간 : \(formattedDate)\n\(formattedTime)"
                    self?.ticketQuantityLabel.text = "인원 수 : \(reservation.quantity)명"


                    print("예매 정보를 업데이트했습니다. 영화 제목: \(movieDetail?.title ?? "알 수 없음"), 상영 시간: \(movieDetail?.runtime ?? 0)분, 예매일: \(formattedDate), 시간: \(formattedTime), 수량: \(reservation.quantity)명")
                }
            }
        } else {
            // 예매 정보가 없는 경우 UI 업데이트
            self.movieTitleLabel.text = "예매된 영화가 없습니다"
            self.runTimeLabel.text = ""
            self.dateLabel.text = ""
            self.ticketQuantityLabel.text = ""
            print("예매된 영화가 없습니다.")
        }
    }
}


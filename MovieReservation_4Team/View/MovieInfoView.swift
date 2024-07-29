//
// movieInfoView.swift
// MovieReservation_4Team
//
// Created by 4Team on 7/22/24.
//
import UIKit
import SnapKit


class MovieInfoView: UIView {
    //    let movieInfVC = MovieInfoViewController()
    
    // 스크롤뷰
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //더보기 기능
    private var isExpanded = false
    
    //영화 이미지
    var movieImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.clipsToBounds = true
        return image
    }()
    //영화 제목
    var movieTitleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.mainWhite
        title.font = FontNames.mainFont3.font()
        title.numberOfLines = 0
        return title
    }()
    //개봉 날짜
    var openingDateLabel: UILabel = {
        let date = UILabel()
        date.textColor = UIColor.mainWhite
        date.font = FontNames.subFont2.font()
        return date
    }()
    //상영시간
    var runningTimeLabel: UILabel = {
        let runningTime = UILabel()
        runningTime.textColor = UIColor.mainWhite
        runningTime.font = FontNames.subFont2.font()
        return runningTime
    }()
    //영화 장르
    var genreLabel: UILabel = {
        let genre = UILabel()
        genre.textColor = UIColor.mainWhite
        genre.font = FontNames.subFont2.font()
        return genre
    }()
    //개봉날짜/시간/장르 담을 가로 stackView
    var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    //영화 평점
    var reviewScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainWhite
        label.font = FontNames.subFont2.font()
        return label
    }()
    //영화 줄거리
    var descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = .mainWhite
        description.font = FontNames.subFont2.font()
        description.numberOfLines = 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        return description
    }()
    //더보기 기능
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("...더보기", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .mainBlack
        button.titleLabel?.font = FontNames.subFont2.font()
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchDown)
        return button
    }()
    //예매하기 버튼
    lazy var reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .mainRed
        button.layer.cornerRadius = 8
        return button
    }()
    //찜하기 버튼
    lazy var likeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.mainRed
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1938742399, green: 0.1839756966, blue: 0.184156239, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    //MARK: -init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder) // 'super.init(coder: coder)' 호출 추가
        //        configureUI()
    }
    
    //MARK: -메서드
    private func configureUI(){
        self.backgroundColor = UIColor.mainBlack
        
        
        //상단 라벨 StackView에 추가
        [reviewScoreLabel,openingDateLabel,
         runningTimeLabel,
         genreLabel].forEach { infoStackView.addArrangedSubview($0)
        }
        //하단 라벨 StackView에 추가
        [reservationButton, likeButton].forEach { bottomStackView.addArrangedSubview($0)}
        
        //스크롤뷰에 추가
        [movieImageView,
         movieTitleLabel,
         infoStackView,
         descriptionLabel,
         moreButton,
         bottomStackView].forEach { scrollView.addSubview($0) }
        
        //스크롤뷰
        [scrollView].forEach { self.addSubview($0) }
        
        //MARK: -오토레이아웃
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        movieImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(450)
            $0.width.equalTo(self)
        }
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        infoStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
        }
        // Content Hugging Priority 설정
        reviewScoreLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        openingDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        runningTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(24)
            $0.trailing.leading.equalToSuperview().inset(24)
            //      $0.height.equalTo(100)
        }
        moreButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom)
            $0.trailing.equalTo(descriptionLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(50)
            //$0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        reservationButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.equalTo(50)
        }
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(80)
        }
        bottomStackView.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    //MARK: -@objc
    @objc
    func moreButtonTapped() {
        isExpanded.toggle()
        descriptionLabel.numberOfLines = isExpanded ? 0 : 4
        moreButton.setTitle(isExpanded ? "닫기" : "...더보기", for: .normal)
        moreButton.titleLabel?.font = FontNames.subFont2.font()
    }
    
}





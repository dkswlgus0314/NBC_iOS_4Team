//
//  ModalViewController.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/25/24.
//

import UIKit
import SnapKit

class ModalViewController: UIViewController {
    
    //사용자가 선택한 영화의 id.
    var userMovieId: Int?   //0이면 에러처리도 해볼 것. ->  if let/ guard let
    var numberOfPeople = 0 // 예매 인원 수량 카운트
    var reservationDate: String = ""  // 예매 날짜 및 시간
    
    
    //예매하기 버튼
    lazy var reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .mainRed
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(reservationButtonTapped), for: .touchDown)
        return button
    }()
    
    //상단 라벨
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜/시간/인원 선택"
        label.font = FontNames.mainFont.font()
        label.textColor = UIColor.mainBlack
        return label
    }()
    
    //DatePicker
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR") //언어 설정
        picker.backgroundColor = .mainWhite // 배경색 설정
        return picker
    }()
    
    //예매 날짜 및 시간 정보
    var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //인원 텍스트 라벨
    var quantityLabel: UILabel = {
       let label = UILabel()
        label.text = "예매 수량"
        label.font = FontNames.subFont2.font()
        label.textColor = UIColor.mainBlack
        return label
    }()
    
    // + 버튼
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .mainBlack
        button.layer.cornerRadius = 8
     
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchDown)
        return button
    }()
    
    // 수량 라벨
    var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = FontNames.mainFont.font()
        return label
    }()
    
    // - 버튼
   lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .mainBlack
       button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchDown)
        return button
    }()
    
    //버튼들을 담은 스택뷰
    var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite
        setupUI()
        
        // DatePicker의 날짜 범위 설정
        setDatePickerRange()
    }
    
    // DatePicker의 최대 날짜와 최소 날짜
    private func setDatePickerRange() {
        var components = DateComponents()
        components.day = 10
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        components.day = 0
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
    }
    
    func setupUI() {
        
        [minusButton, countLabel, plusButton].forEach { buttonsStackView.addArrangedSubview($0) }
        
        [titleLabel, datePicker, dateLabel, quantityLabel, buttonsStackView, reservationButton].forEach { view.addSubview($0)}
        
        
        // 값이 변할 때마다 동작을 설정해 줌
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        // label에 오늘 날짜로 표시되게 설정
        dateLabel.text = dateFormat(date: Date())
        
        
        //오토레이아웃
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalTo(buttonsStackView.snp.bottom)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(reservationButton.snp.top).offset(24)
        }
        
        reservationButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        
    }
    
    //MARK: -@objc
    // 값이 변할 때 마다 동작
    @objc
    func dateChange(_ sender: UIDatePicker) {
        // 값이 변하면 UIDatePicker에서 날짜를 받아와 형식을 변형해서 Lable에 넣어준다.
        reservationDate = dateFormat(date: sender.date)
        dateLabel.text = "예매 일정 : \(reservationDate)"
    }
    
    @objc
    private func minusButtonTapped(){
        if numberOfPeople > 0 {
            numberOfPeople -= 1
            countLabel.text = "\(numberOfPeople)"
        }
    }
    
    
    @objc
    private func plusButtonTapped(){
        numberOfPeople += 1
        countLabel.text = "\(numberOfPeople)"
    }
    
    //예약하기 버튼 클릭 시 영화 정보 전달
    @objc
    private func reservationButtonTapped(){

        let reservationVC = ReservaitionController()
        
        //옵셔널 타입이라 바인딩해서 사용할 것. 값이 없을 때 처리 필요.
        let userReservationData = (movieId: userMovieId ?? 0, count: numberOfPeople, date: reservationDate)
        
        //🌟ReservationController에서 위의 데이터를 받아 사용하세요!!
        print(userReservationData)
        navigationController?.pushViewController(reservationVC, animated: true)
    }
    
    
    
    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd HH:mm"
        
        return formatter.string(from: date)
    }
    
    
}

#Preview("ModalViewController") {ModalViewController()}


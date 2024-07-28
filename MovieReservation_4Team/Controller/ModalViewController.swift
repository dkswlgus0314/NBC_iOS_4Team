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
    
    var pushReservation: (() -> Void)?
    
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
        label.font = FontNames.mainFont2.font()
        label.textColor = UIColor.mainBlack
        return label
    }()
    
    //DatePicker
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR") //언어 설정
        picker.backgroundColor = UIColor.mainWhite // 배경색 설정
        return picker
    }()
    
    //예매 날짜 및 시간 정보
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontNames.subFont3.font()
        label.textColor = UIColor.mainBlack
        return label
    }()
    
    //인원 텍스트 라벨
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "예매 수량"
        label.font = FontNames.subFont3.font()
        label.textColor = UIColor.mainBlack
        return label
    }()
    
    // + 버튼
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchDown)
        return button
    }()
    
    // 수량 라벨
    var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = FontNames.subFont3.font()
        return label
    }()
    
    // - 버튼
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .systemGray4
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
        
        view.backgroundColor = UIColor.mainWhite
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
        //초기 예매 날짜 세팅
        reservationDate = dateToString(date: Date())
        dateLabel.text = "예매 일정 : \(reservationDate)"
        
        [minusButton, countLabel, plusButton].forEach { buttonsStackView.addArrangedSubview($0) }
        
        [titleLabel, datePicker, dateLabel, quantityLabel, buttonsStackView, reservationButton].forEach { view.addSubview($0)}
        
        
        // 값이 변할 때마다 동작을 설정해 줌
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
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
            $0.leading.equalToSuperview().inset(32)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(40)
            $0.leading.equalTo(dateLabel)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalTo(buttonsStackView.snp.bottom)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(quantityLabel.snp.bottom)
        }
        
        reservationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
        
    }
    
    //MARK: -@objc
    // 값이 변할 때 마다 동작
    @objc
    func dateChange(_ sender: UIDatePicker) {
        // 값이 변하면 UIDatePicker에서 날짜를 받아와 형식을 변형해서 Lable에 넣어준다.
        // label에 오늘 날짜로 표시되게 설정
        
        reservationDate = dateToString(date: sender.date)
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
    @objc private func reservationButtonTapped() {
        guard let user = UserDataManager.shared.getCurrentLoggedInUser() else {
            print("로그인된 사용자를 찾을 수 없습니다.")
            return
        }
        
        guard let movieId = userMovieId else {
            print("유효한 영화 ID를 입력하세요.")
            return
        }
        
        let count = numberOfPeople
        guard let date = dateFromString(reservationDate) else {
            print("날짜 형식이 올바르지 않습니다.")
            return
        }
        
        
        if count > 0 {
            // 예매 정보를 저장
            ReservationManager.shared.saveReservation(
                movieID: movieId,
                quantity: Int32(count),
                date: date,
                userId: user.id ?? "" // 기본값으로 빈 문자열을 사용
            )
            
            // 예매 정보 출력
            print("예매 정보가 저장되었습니다. 영화 ID: \(movieId), 수량: \(count), 날짜: \(date)")
            
            //예매완료 Alert
            reservationAlert()
        } else {
            warningAlert()
        }
    }
    
    
    
    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd HH:mm" // 날짜 형식에 맞게 설정
        return formatter.date(from: dateString)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd HH:mm" // 날짜 형식에 맞게 설정
        return formatter.string(from: date)
    }
    
    //예매 완료 Alert
    private func reservationAlert() {
  
        
        let alert = UIAlertController(title: "예매 완료", message: "예매 완료되었습니다.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: self.pushReservation)
            
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
//        self.dismiss(animated: true, completion: nil)
            // 모달 형태로 전환할 경우
//            let reservationController = ReservationController()
//            reservationController.modalPresentationStyle = .fullScreen
//            self.present(reservationController, animated: true, completion: nil)
//        pushReservation!()
        
            //네비게이션컨트롤러로 화면 전환활 경우
//            if let navigationController = self.navigationController {
//                let reservationController = ReservationController()
//                navigationController.pushViewController(reservationController, animated: true)
//            }
//            if let viewController = self.parentViewController {
//                viewController.present(movieDetailVC, animated: true, completion: nil)
//            }
        
        
    }
    
    //수량이 0인 경우 경고 alert
    private func warningAlert(){
        let alert = UIAlertController(title: "예매 수량 확인", message: "예매 수량을 선택해주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

#Preview("ModalViewController") {ModalViewController()}


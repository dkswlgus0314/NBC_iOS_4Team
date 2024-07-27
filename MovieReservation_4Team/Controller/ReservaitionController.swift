//
//  ThirdViewController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0112 on 7/23/24.
//

import UIKit
import SnapKit

class ReservaitionController: UIViewController {
    
    // 사용자가 선택한 영화의 id.
    // 1. 모델 정의
    struct Reservation {
        let movieId: Int
        let count: Int
        let date: Date
    }
    
    // 2. 저장된 데이터 정의
    let storedReservations: [Reservation] = [
        Reservation(movieId: 1, count: 2, date: Date()),
        Reservation(movieId: 2, count: 4, date: Date().addingTimeInterval(86400)),
        // 필요에 따라 더 많은 데이터를 추가하세요.
    ]
    
    // 3. 사용자 예약 데이터 바인딩
    private var userReservationData: (movieId: Int, count: Int, date: Date) = (0, 0, Date())
    
    private let reservaitionView: ReservaitionView = {
        let view = ReservaitionView()
        view.backgroundColor = .clear // 배경색 조정
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reservation"
        setupUI()
        configureView()
        
        // 4. 데이터 바인딩
        bindUserReservationData()
        
        // 5. 바인딩된 데이터 사용
        print("Movie ID: \(userReservationData.movieId), Count: \(userReservationData.count), Date: \(userReservationData.date)")
        
        // 6. 데이터에 따라 UI 업데이트
        updateUIBasedOnReservationData()
    }
    
    private func setupUI() {
        view.addSubview(reservaitionView)
        reservaitionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        if let ticketImage = UIImage(named: "ticket"),
           let movieImage = UIImage(named: "image1") {
            reservaitionView.configure(with: ticketImage, movieImage: movieImage)
        } else {
            print("One or more images not found")
        }
    }
    
    private func bindUserReservationData() {
        let userReservation: Reservation? = fetchUserReservation()
        
        if let reservation = userReservation {
            userReservationData = (movieId: reservation.movieId, count: reservation.count, date: reservation.date)
        } else {
            // 값이 없을 때 처리
            userReservationData = (movieId: 0, count: 0, date: Date())
        }
    }
    
    // 4. 데이터를 가져오는 함수
    private func fetchUserReservation() -> Reservation? {
        // 필요한 로직을 사용하여 데이터를 가져옵니다.
        // 예를 들어, 특정 조건에 맞는 데이터를 가져올 수 있습니다.
        return storedReservations.first { $0.movieId == 1 }
    }
    
    private func updateUIBasedOnReservationData() {
        if userReservationData.movieId == 0 && userReservationData.count == 0 {
            reservaitionView.showNoReservationMessage()
        } else {
            reservaitionView.hideNoReservationMessage()
        }
    }
}
#Preview("ReservaitionController") { ReservaitionController() }

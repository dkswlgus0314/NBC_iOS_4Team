//
//  ThirdViewController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0112 on 7/23/24.
//
import UIKit
import SnapKit

class ReservationController: UIViewController {

    private let reservaitionView: ReservaitionView = {
        let view = ReservaitionView()
        view.backgroundColor = UIColor.mainBlack
        return view
    }()

    private let viewModel = ReservationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reservation"
        setupUI()
        configureView()
    }

    private func setupUI() {
        view.addSubview(reservaitionView)
        reservaitionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureView() {
        viewModel.loadReservationData { [weak self] image, reservation in
            DispatchQueue.main.async {
                if let image = image {
                    self?.reservaitionView.configure(with: image)
                }
                if let reservation = reservation {
                    self?.reservaitionView.updateReservationInfo(with: reservation)
                } else {
                    self?.reservaitionView.updateReservationInfo(with: nil)
                }
            }
        }
    }
}

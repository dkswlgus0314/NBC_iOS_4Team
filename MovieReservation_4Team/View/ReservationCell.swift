import UIKit
import SnapKit

class ReservationCell: UICollectionViewCell {
    static let identifier = "ReservationCell"

    private let reservationView: ReservationView = {
        let view = ReservationView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(reservationView)
        reservationView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with reservation: ReservationView.Reservation, movieImage: UIImage?, delegate: ReservationViewDelegate) {
        reservationView.configure(with: movieImage)
        reservationView.updateReservationInfo(with: reservation)
        reservationView.delegate = delegate
    }
}

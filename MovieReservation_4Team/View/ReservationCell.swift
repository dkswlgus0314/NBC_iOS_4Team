import UIKit
import SnapKit

class ReservationCell: UICollectionViewCell {
    static let identifier = "ReservationCell"

    private let reservaitionView: ReservaitionView = {
        let view = ReservaitionView()
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
        contentView.addSubview(reservaitionView)
        reservaitionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with reservation: ReservaitionView.Reservation, movieImage: UIImage?) {
        reservaitionView.configure(with: movieImage)
        reservaitionView.updateReservationInfo(with: reservation)
    }
}

import UIKit
import SnapKit
import CoreData

protocol ReservationViewDelegate: AnyObject {
    func didTapDeleteButton(in view: ReservationView)
}

class ReservationController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 수평 스크롤 설정
        layout.minimumLineSpacing = 10 // 셀 사이 간격 설정
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ReservationCell.self, forCellWithReuseIdentifier: ReservationCell.identifier)
        collectionView.backgroundColor = UIColor.mainBlack // 배경색 설정
        return collectionView
    }()

    private let viewModel = ReservationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reservation"
        view.backgroundColor = UIColor.mainBlack
        setupUI()
        setupCollectionView()
        loadData()

        NotificationCenter.default.addObserver(self, selector: #selector(handleReservationsUpdated), name: .reservationsUpdated, object: nil)
    }

    @objc private func handleReservationsUpdated() {
        print("handleReservationsUpdated 호출됨")
        loadData()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 컬렉션뷰가 전체 화면을 차지하도록 설정
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func loadData() {
        viewModel.loadReservationData { [weak self] in
            DispatchQueue.main.async {
                print("로딩된 데이터: \(self?.viewModel.reservations.map { $0.0.reservationID.uuidString ?? "unknown" })") // 💖 로드된 데이터 확인
                self?.collectionView.reloadData()
            }
        }
    }


    func fetchReservationByUUID(uuid: UUID) -> Reservationticket? {
        let fetchRequest: NSFetchRequest<Reservationticket> = Reservationticket.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "reservationID == %@", uuid as CVarArg)

        do {
            let results = try ReservationManager.shared.context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch reservation: \(error)")
            return nil
        }
    }
}

extension ReservationController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = viewModel.reservations.count
        print("컬렉션 뷰 아이템 수: \(itemCount)") // 💖 디버깅 로그 추가
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationCell.identifier, for: indexPath) as? ReservationCell else {
            return UICollectionViewCell()
        }
        let (reservation, image) = viewModel.reservations[indexPath.row]
        cell.configure(with: reservation, movieImage: image, delegate: self)
        cell.backgroundColor = .clear // 셀의 배경색을 투명하게 설정
        
        print("셀 구성: \(reservation.reservationID.uuidString)") // 💖 디버깅 로그 추가
        return cell
    }
}

extension ReservationController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height - 20) // 적절한 크기로 설정하세요
    }
}

extension ReservationController: ReservationViewDelegate {
    func didTapDeleteButton(in view: ReservationView) {
        guard let cell = view.superview?.superview as? ReservationCell,
              let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let reservation = viewModel.reservations[indexPath.row].0

        // CoreData에서 예약 삭제
        if let reservationToDelete = fetchReservationByUUID(uuid: reservation.reservationID) {
            print("삭제할 예약: \(reservationToDelete.reservationID?.uuidString ?? "unknown")") // 💖 삭제할 예약 확인
            ReservationManager.shared.removeReservation(reservationToDelete)
        }

        // ViewModel에서 예약 삭제 및 컬렉션 뷰 갱신
        viewModel.reservations.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])

        print("삭제 후 남은 예약: \(viewModel.reservations.map { $0.0.reservationID.uuidString ?? "unknown" })") // 💖 삭제 후 남은 예약 확인
    }
}

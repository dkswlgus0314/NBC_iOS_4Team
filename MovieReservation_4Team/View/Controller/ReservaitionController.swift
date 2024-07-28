import UIKit
import SnapKit

class ReservationController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 수평 스크롤 설정
        layout.minimumLineSpacing = 20 // 셀 사이 간격 설정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ReservationCell.self, forCellWithReuseIdentifier: ReservationCell.identifier)
        collectionView.backgroundColor = UIColor.mainBlack // 배경색 설정
        return collectionView
    }()

    private let viewModel = ReservationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reservation"
        view.backgroundColor = UIColor.mainBlack // 전체 뷰의 배경색 설정
        setupUI()
        loadData()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func loadData() {
        viewModel.loadReservationData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ReservationController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reservations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationCell.identifier, for: indexPath) as? ReservationCell else {
            return UICollectionViewCell()
        }
        let (reservation, image) = viewModel.reservations[indexPath.row]

        cell.configure(with: reservation, movieImage: image)
        cell.backgroundColor = .clear // 셀의 배경색을 투명하게 설정
        
        return cell
    }
}

extension ReservationController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height - 20) // 적절한 크기로 설정하세요
    }
}

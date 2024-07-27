////
////  CustomNavigationBarView.swift
////  MovieReservation_4Team
////
////  Created by t2023-m0023 on 7/23/24.
////
//
//import UIKit
//import SnapKit
//
//class CustomNavigationBarView: UIView {
//
//    private let navigationBar: UINavigationBar = {
//        let navBar = UINavigationBar()
//        navBar.isTranslucent = true
//        navBar.setBackgroundImage(UIImage(), for: .default)
//        navBar.shadowImage = UIImage()
//        navBar.tintColor = UIColor.mainWhite// 버튼 색상
//        return navBar
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.mainWhite // 타이틀 색상
//        label.font = FontNames.mainFont.font() ?? UIFont.systemFont(ofSize: 20) // 커스텀 폰트
//        label.textAlignment = .center
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    private func setupView() {
//        // 네비게이션 바와 타이틀 레이블을 서브뷰로 추가
//        addSubview(navigationBar)
//        addSubview(titleLabel)
//
//        navigationBar.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(70)
//        }
//
//        titleLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(navigationBar.snp.bottom).offset(-10)
//            make.centerX.equalToSuperview()
//        }
//    }
//
//    func setTitle(_ title: String, leftButtonAction: Selector?, rightButtonImage: UIImage?, rightButtonAction: Selector?, target: Any?) {
//        titleLabel.text = title // 타이틀 레이블 업데이트
//
//        let navItem = UINavigationItem()
//
//        // 왼쪽 버튼 설정
//        if let leftButtonAction = leftButtonAction {
//            let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: target, action: leftButtonAction)
//            navItem.leftBarButtonItem = leftButton
//        } else {
//            navItem.leftBarButtonItem = nil
//        }
//
//        // 오른쪽 버튼 설정
//        if let rightButtonImage = rightButtonImage {
//            let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: target, action: rightButtonAction)
//            navItem.rightBarButtonItem = rightButton
//        } else {
//            navItem.rightBarButtonItem = nil
//        }
//
//        navigationBar.items = [navItem]
//    }
//
//    @objc func backButtonTapped() {
//        // 뒤로가기 버튼 액션
//        if let navigationController = self.findNavigationController() {
//            navigationController.popViewController(animated: true)
//        }
//    }
//
//    private func findNavigationController() -> UINavigationController? {
//        var currentView: UIView? = self
//        while let view = currentView {
//            if let viewController = view.next as? UIViewController,
//               let navigationController = viewController.navigationController {
//                return navigationController
//            }
//            currentView = view.superview
//        }
//        return nil
//    }
//}

//
//  MyPageController.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0117 on 7/23/24.
//

import UIKit

class MyPageController: UIViewController {
    
    private let myPageView = MyPageView()
    
    override func loadView() {
        self.view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainBlack
        setupNavigation()
     }
    
    private func setupNavigation() {
        myPageView.onEditInfoSelected = { [weak self] in
            self?.navigateToSignUpView()
        }
    }
    
    private func navigateToSignUpView() {
        let signUpViewController = SignUpView()
        signUpViewController.isUpdating = true
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
}

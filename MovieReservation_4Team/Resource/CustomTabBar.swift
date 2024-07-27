//
//  CustomTabBar.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0112 on 7/23/24.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 20  // 높이 조정
        let width: CGFloat = self.bounds.width - 60  // 원하는 너비로 설정
        let path = UIBezierPath(
            roundedRect: CGRect(x: (self.bounds.width - width) / 2, y: -10, width: width, height: height + 20),
            cornerRadius: (height + 20) / 2
        )
        return path.cgPath
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50  // 높이 조정
        return sizeThatFits
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabBarHeight: CGFloat = 50  // 높이 조정
        var tabFrame = self.frame
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = self.frame.origin.y + self.frame.height - tabBarHeight - 30  // 위로 올림
        self.frame = tabFrame

        // 아이템 위치 조정 - 여기서 subview를 직접 조작하지 않습니다.
    }
}

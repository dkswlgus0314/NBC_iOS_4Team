//
//  ReviewCell.swift
//  MovieReservation_4Team
//
//  Created by ahnzihyeon on 7/29/24.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell {
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainWhite
        label.font = FontNames.mainFont.font()
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainWhite
        label.font = FontNames.subFont2.font()
        label.numberOfLines = 0
        return label
    }()
    
    // 초기화 및 UI 구성
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.mainBlack
        
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(4)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 리뷰 데이터로 셀 구성
    func configure(with review: Review) {
        authorLabel.text = "작성자 : \(review.author)"
        contentLabel.text = "내용 : \(review.content)"
    }
}

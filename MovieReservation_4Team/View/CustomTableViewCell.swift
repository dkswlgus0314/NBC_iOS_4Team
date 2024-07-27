

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    private let customTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainWhite // 텍스트 색상 설정
        label.font = FontNames.mainFont.font() // 서브 폰트 설정
        return label
    }()
    
    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor.mainWhite
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(customTextLabel)
        contentView.addSubview(accessoryImageView)
        
        customTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        
        accessoryImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
        }
        
        contentView.backgroundColor = UIColor.mainBlack // 셀 배경색 설정
    }
    
    func configure(text: String) {
        customTextLabel.text = text
    }
}

import UIKit
import SnapKit

class MainView: UIView {
    
    // MARK: - Properties
    
    let scrollView: UIScrollView = { // 스크롤뷰
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let contentView: UIView = { // MainView의 루트 뷰 역할을 하는 UIView, scrollView의 콘텐츠를 감싸고 스크롤을 가능하게함, 이 안에는 first~fourth컬렉션뷰, first~third버튼이 있음.
        let view = UIView()
        return view
    }()
   
    let firstCollectionView: UICollectionView = { // 최상단 이미지
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FirstCell")
        return collectionView
    }()
    
    let pageLabel: UILabel = { // 최상단 이미지 하단에 현재 페이지/총 페이지를 알려주는 UILabel
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    let firstButton: UIButton = { // Coming Soon버튼
        let button = UIButton()
        button.setTitle("Coming Soon", for: .normal)
        button.setTitleColor(UIColor.mainWhite, for: .normal)
        button.titleLabel?.font = FontNames.mainFont.font()
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    let secondCollectionView: UICollectionView = { // Coming Soon 이미지뷰
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SecondCell")
        return collectionView
    }()
    
    let secondButton: UIButton = { // Latest Movies버튼
        let button = UIButton()
        button.setTitle("Latest Movies", for: .normal)
        button.setTitleColor(UIColor.mainWhite, for: .normal)
        button.titleLabel?.font = FontNames.mainFont.font()
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    let thirdCollectionView: UICollectionView = { // Latest Movies 이미지뷰
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ThirdCell")
        return collectionView
    }()
    
    let thirdButton: UIButton = { // Genre 장르 버튼(컨트롤러 부분에 장르 버튼을 누르면 장르를 고를 수 있게 구현)
        let button = UIButton()
        button.setTitle("Genre", for: .normal)
        button.setTitleColor(UIColor.mainWhite, for: .normal)
        button.titleLabel?.font = FontNames.mainFont.font()
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    let fourthCollectionView: UICollectionView = { // Genre 이미지 뷰
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.mainBlack
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FourthCell")
        return collectionView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
        setupView()
    }

    // MARK: - Setup Methods
    
    func setupScrollView() { // 스크롤 뷰 레이아웃 설정
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }

    func setupView() { // 전체 뷰 설정
        setupBackgroundColor()
        setupFirstCollectionView()
        setupPageLabel()
        setupFirstButton()
        setupSecondCollectionView()
        setupSecondButton()
        setupThirdCollectionView()
        setupThirdButton()
        setupFourthCollectionView()
    }
    
    func setupBackgroundColor() { // 배경 색상 설정
        backgroundColor = UIColor.mainBlack
        contentView.backgroundColor = UIColor.mainBlack
    }

    func setupFirstCollectionView() { // 첫 번째 컬렉션 뷰 레이아웃
        contentView.addSubview(firstCollectionView)
        
        firstCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(0)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(200)
        }
    }
    
    func setupPageLabel() { // 첫번째 하단 페이지 레이블 레이아웃
        contentView.addSubview(pageLabel)
        
        pageLabel.snp.makeConstraints {
            $0.bottom.equalTo(firstCollectionView.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
            $0.width.equalTo(60) // 페이지 레이블 너비 설정
        }
    }
    
    func setupFirstButton() { // 첫 번째 버튼 레이아웃
        contentView.addSubview(firstButton)
        
        firstButton.snp.makeConstraints {
            $0.top.equalTo(firstCollectionView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(30)
        }
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right")) //우측을 가리키는 방향버튼
        arrowImageView.tintColor = UIColor.mainWhite
        firstButton.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(20)
        }
    }
    
    func setupSecondCollectionView() { // 두 번째 컬렉션 뷰 레이아웃
        contentView.addSubview(secondCollectionView)
        
        secondCollectionView.snp.makeConstraints {
            $0.top.equalTo(firstButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(200)
        }
    }
    
    func setupSecondButton() { // 두 번째 버튼 레이아웃
        contentView.addSubview(secondButton)
        
        secondButton.snp.makeConstraints {
            $0.top.equalTo(secondCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(30)
        }
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = UIColor.mainWhite
        secondButton.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(20)
        }
    }
    
    func setupThirdCollectionView() { // 세 번째 컬렉션 뷰 레이아웃
        contentView.addSubview(thirdCollectionView)
        
        thirdCollectionView.snp.makeConstraints {
            $0.top.equalTo(secondButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(200)
        }
    }
    
    func setupThirdButton() { // 세 번째 버튼 레이아웃
        contentView.addSubview(thirdButton)
        
        thirdButton.snp.makeConstraints {
            $0.top.equalTo(thirdCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(30)
        }
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = UIColor.mainWhite
        thirdButton.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(20)
        }
    }
    
    func setupFourthCollectionView() { // 세 번째 컬렉션 뷰 레이아웃
        contentView.addSubview(fourthCollectionView)
        
        fourthCollectionView.snp.makeConstraints {
            $0.top.equalTo(thirdButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(200)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

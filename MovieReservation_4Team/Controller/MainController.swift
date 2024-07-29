import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    // MARK: - Properties
    private var movies: [Movie] = []

    let mainView = MainView() // MainView 인스턴스
    
    // 각 컬렉션 뷰에 표시될 영화 데이터 배열
    var firstCollectionViewMovies: [Movie] = []
    var secondCollectionViewMovies: [Movie] = []
    var thirdCollectionViewMovies: [Movie] = []
    var fourthCollectionViewMovies: [Movie] = []
    var selectedCategoryMovies: [Movie] = []
    
    var slideTimer: Timer? // 첫 번째 컬렉션뷰 자동으로 넘어가게 타이머 설정
    
    let genres = ["Action", "Animation", "Horror", "Romance", "Comedy"] // 장르를 눌렀을 때 나올 목록
    let genreIds = [28, 16, 27, 10749, 35] // 장르 ID번호 목록
    
    var pickerView: UIPickerView! // 장르 선택 피커 뷰
    var pickerToolbar: UIToolbar! // 피커 뷰 툴바
    
    private var lastContentOffset: CGFloat = 0 // 마지막 스크롤 위치를 저장
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView() // 컬렉션 뷰 설정
        setupPickerView() // 피커 뷰 설정
        fetchData() // 데이터 가져오기
        startSlideTimer() // 타이머 시작
        
        setupNavigationBarTitle() // 네비게이션 바 타이틀 설정
        setupProfileButton() // 프로필 이미지 버튼 설정
        setupCategoryButtonActions() // 카테고리 버튼 액션 설정
        
        mainView.scrollView.delegate = self // 스크롤 뷰 델리게이트 설정
    }
    
    func setupCollectionView() {
        mainView.firstCollectionView.dataSource = self // 컬렉션 뷰의 데이터 소스를 결정
        mainView.firstCollectionView.delegate = self // 컬렉션 뷰의 델리게이트를 설정
        
        mainView.secondCollectionView.dataSource = self
        mainView.secondCollectionView.delegate = self
        
        mainView.thirdCollectionView.dataSource = self
        mainView.thirdCollectionView.delegate = self
        
        mainView.fourthCollectionView.dataSource = self
        mainView.fourthCollectionView.delegate = self
    }
    
    func setupPickerView() {
        pickerView = UIPickerView() // 피커 뷰 인스턴스 생성
        pickerView.backgroundColor = .mainBlack
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerToolbar = UIToolbar()
        pickerToolbar.sizeToFit() // 툴바의 크기를 맞춤
        pickerToolbar.barTintColor = .mainBlack
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker)) // 완료 버튼 생성
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([spaceButton, doneButton], animated: false)
        
        pickerToolbar.tintColor = UIColor.mainWhite // done 버튼 텍스트 색상 변경
        
        mainView.addSubview(pickerView) // 메인 뷰에 피커 뷰 추가
        mainView.addSubview(pickerToolbar) // 메인 뷰에 툴바 추가
        
        pickerView.snp.makeConstraints { // 피커 뷰 레이아웃 설정
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        pickerToolbar.snp.makeConstraints { // 피커 툴바 레이아웃 설정
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(pickerView.snp.top)
            $0.height.equalTo(44)
        }
        
        pickerView.isHidden = true // 피커 뷰 숨기기
        pickerToolbar.isHidden = true // 툴바 숨기기
    }
    
    // MARK: - Actions
    
    @objc func profileButtonTapped() { // 프로필 이미지 액션
        let myPageVC = MyPageController() // 이동할 프로필 페이지
        self.navigationController?.pushViewController(myPageVC, animated: true)
    }
    
    @objc func showFirstCategory() { // Coming Soon 눌렀을 때 액션
        selectedCategoryMovies = secondCollectionViewMovies
        showCategoryModal(title: "Coming Soon")
    }
    
    @objc func showSecondCategory() { // Latest Movies 눌렀을 때 액션
        selectedCategoryMovies = thirdCollectionViewMovies
        showCategoryModal(title: "Latest Movies")
    }
    
    @objc func showThirdCategory() { // Genre 버튼 눌렀을 때 나오는 액션
        pickerView.isHidden = false
        pickerToolbar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func donePicker() { // 피커 뷰 Done 눌렀을 때 나오는 액션
        pickerView.isHidden = true // 피커 뷰 숨기기
        pickerToolbar.isHidden = true // 툴바 숨기기
        
        let selectedRow = pickerView.selectedRow(inComponent: 0) // 선택된 피커 뷰의 행을 가져옴
        let selectedGenreId = genreIds[selectedRow] // 선택된 장르 ID를 가져옴
        let selectedGenreName = genres[selectedRow] // 선택된 장르 이름을 가져옴
        
        // 선택된 장르의 영화를 가져옴
        NetworkManager.shared.fetchMoviesByGenre(genreId: selectedGenreId, page: 1) { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            DispatchQueue.main.async {
                self.selectedCategoryMovies = movies // 선택된 카테고리의 영화를 업데이트
                self.updateFourthCollectionView(with: movies) // 네 번째 컬렉션 뷰 업데이트
                self.mainView.thirdButton.setTitle("Genre - \(selectedGenreName)", for: .normal) // thirdButton의 제목 변경
                self.tabBarController?.tabBar.isHidden = false // 탭 바 다시 표시
                self.showCategoryModal(title: selectedGenreName) // 카테고리 모달 표시
            }
        }
    }
    
    // MARK: - Network Calls
    
    // 데이터를 가져옴
    func fetchData() {
        NetworkManager.shared.fetchPopularMovies(page: 1) { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            DispatchQueue.main.async {
                self.firstCollectionViewMovies = movies
                self.mainView.firstCollectionView.reloadData()
                self.updatePageLabel() // 페이지 레이블 업데이트
            }
        }
        
        NetworkManager.shared.fetchUpcomingMovies(page: 2) { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            DispatchQueue.main.async {
                self.secondCollectionViewMovies = movies
                self.mainView.secondCollectionView.reloadData()
            }
        }
        
        // 여기에서 third와 fourth 컬렉션의 데이터 소스를 바꿈
        NetworkManager.shared.fetchNowPlayingMovies(page: 4) { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            DispatchQueue.main.async {
                self.thirdCollectionViewMovies = movies
                self.mainView.thirdCollectionView.reloadData()
            }
        }
        
        NetworkManager.shared.fetchMoviesByGenre(genreId: 27, page: 1) { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            DispatchQueue.main.async {
                self.fourthCollectionViewMovies = movies
                self.mainView.fourthCollectionView.reloadData()
            }
        }
    }
    
    func updateFourthCollectionView(with movies: [Movie]) {
        self.fourthCollectionViewMovies = movies
        self.mainView.fourthCollectionView.reloadData()
    }
    
    // MARK: - Helper Methods
    
    func setupNavigationBarTitle() {
           let titleLabel = UILabel()
           titleLabel.text = "NIGABOX"
           titleLabel.textColor = .mainRed
           titleLabel.font = FontNames.mainFont2.font()
           titleLabel.sizeToFit()
           
           let leftItem = UIBarButtonItem(customView: titleLabel)
           navigationItem.leftBarButtonItem = leftItem
       }
    
    func setupProfileButton() {
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(UIImage(named: "profile"), for: .normal) // "profileImage"는 프로젝트에 추가된 이미지 이름입니다.
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileButton.layer.cornerRadius = 15
        profileButton.clipsToBounds = true
        profileButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        let profileBarButtonItem = UIBarButtonItem(customView: profileButton)
        self.navigationItem.rightBarButtonItem = profileBarButtonItem
    }
    
    func setupCategoryButtonActions() {
        mainView.firstButton.addTarget(self, action: #selector(showFirstCategory), for: .touchUpInside)
        mainView.secondButton.addTarget(self, action: #selector(showSecondCategory), for: .touchUpInside)
        mainView.thirdButton.addTarget(self, action: #selector(showThirdCategory), for: .touchUpInside)
    }
    
    func updatePageLabel() {
        let currentPage = Int(round(mainView.firstCollectionView.contentOffset.x / mainView.firstCollectionView.frame.width))
        let totalPage = firstCollectionViewMovies.count
        mainView.pageLabel.text = "\(currentPage + 1) / \(totalPage)"
    }
    
    func showCategoryModal(title: String) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBlack
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        let modalViewController = UIViewController()
        modalViewController.view.backgroundColor = .mainBlack
        modalViewController.title = title
        modalViewController.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(modalViewController.view.safeAreaLayoutGuide).inset(10)
        }
        
        let navController = UINavigationController(rootViewController: modalViewController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.firstCollectionView:
            return firstCollectionViewMovies.count
        case mainView.secondCollectionView:
            return secondCollectionViewMovies.count
        case mainView.thirdCollectionView:
            return thirdCollectionViewMovies.count
        case mainView.fourthCollectionView:
            return fourthCollectionViewMovies.count
        default:
            return selectedCategoryMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(for: collectionView), for: indexPath)

        // 셀의 컨텐츠 뷰에서 이미지 뷰를 가져옵니다.
        let imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let movie: Movie

        // 데이터 소스에서 영화 정보를 가져옵니다.
        switch collectionView {
        case mainView.firstCollectionView:
            movie = firstCollectionViewMovies[indexPath.item]
        case mainView.secondCollectionView:
            movie = secondCollectionViewMovies[indexPath.item]
        case mainView.thirdCollectionView:
            movie = thirdCollectionViewMovies[indexPath.item]
        case mainView.fourthCollectionView:
            movie = fourthCollectionViewMovies[indexPath.item]
        default:
            movie = selectedCategoryMovies[indexPath.item]
        }

        // 이미지 URL을 설정하고 비동기적으로 이미지를 로드합니다.
        if collectionView == mainView.firstCollectionView, let backdropPath = movie.backdropPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(backdropPath)"
            NetworkManager.shared.loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFill // 가로 이미지의 경우 비율 유지
                }
            }
        } else if let posterPath = movie.posterPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            NetworkManager.shared.loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFill // 세로 포스터의 경우 비율 유지
                }
            }
        }

        return cell
    }

    private func cellIdentifier(for collectionView: UICollectionView) -> String {
        switch collectionView {
        case mainView.firstCollectionView:
            return "FirstCell"
        case mainView.secondCollectionView:
            return "SecondCell"
        case mainView.thirdCollectionView:
            return "ThirdCell"
        case mainView.fourthCollectionView:
            return "FourthCell"
        default:
            return "CategoryCell"
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case mainView.firstCollectionView:
            // 가로 이미지 크기 설정
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 200)
        case mainView.secondCollectionView, mainView.thirdCollectionView, mainView.fourthCollectionView:
            // 세로 포스터 크기 설정
            return CGSize(width: 150, height: 200)
        default:
            let width = (UIScreen.main.bounds.width - 40) / 3 // 3개의 아이템을 한 줄에 배치하고, 아이템 사이의 간격 10을 고려
            return CGSize(width: width, height: width * 1.5) // 높이는 너비의 1.5배로 설정
        }
    }
    
    // 실시간 인기, 최신, 추천, 상위 평점
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie
        let movieInfoVC = MovieInfoViewController()
        
        switch collectionView {
        case mainView.firstCollectionView:
            movie = firstCollectionViewMovies[indexPath.item]
            movieInfoVC.readMovieDetail(movieID: movie.id)
        case mainView.secondCollectionView:
            movie = secondCollectionViewMovies[indexPath.item]
            movieInfoVC.readMovieDetail(movieID: movie.id)
        case mainView.thirdCollectionView:
            movie = thirdCollectionViewMovies[indexPath.item]
            movieInfoVC.readMovieDetail(movieID: movie.id)
        case mainView.fourthCollectionView:
            movie = fourthCollectionViewMovies[indexPath.item]
            movieInfoVC.readMovieDetail(movieID: movie.id)
        default:
            movie = selectedCategoryMovies[indexPath.item]
            movieInfoVC.readMovieDetail(movieID: movie.id)
        }
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.pushViewController(movieInfoVC, animated: true)
        }
    }
    
    // 자동 슬라이드 기능
    func startSlideTimer() {
        slideTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    
    @objc func slideToNext() {
        let collectionView = mainView.firstCollectionView
        let visibleItems = collectionView.indexPathsForVisibleItems
        if let currentItem = visibleItems.first {
            let nextItem = IndexPath(item: (currentItem.item + 1) % firstCollectionViewMovies.count, section: currentItem.section)
            collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
            updatePageLabel() // 페이지 레이블 업데이트
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainView.scrollView {
            let offsetY = scrollView.contentOffset.y
            
            if offsetY > lastContentOffset && offsetY > 0 { // 스크롤을 아래로 내리는 중이고, offsetY가 0보다 클 때
                UIView.animate(withDuration: 0.3) {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                }
                
            } else if offsetY < lastContentOffset { // 스크롤을 위로 올리는 중
                UIView.animate(withDuration: 0.3) {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
            
            lastContentOffset = offsetY
        } else if scrollView == mainView.firstCollectionView {
            updatePageLabel()
        }
    }
    
    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel

        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }

        label.text = genres[row]
        label.textColor = .mainWhite // 원하는 색으로 변경
        label.textAlignment = .center

        return label
    }
}

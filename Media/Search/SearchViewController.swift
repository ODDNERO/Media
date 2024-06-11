//
//  SearchViewController.swift
//  Media
//
//  Created by NERO on 6/11/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class SearchViewController: UIViewController {
    var movieList: [Result] = []
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 40)/3

        layout.itemSize = CGSize(width: width, height: width*1.4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        requestSearchData(text: "테스트")
    }
    
    func configureView() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100 //임시
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as! SearchCollectionViewCell
        return cell
    }
}

//MARK: - Network
extension SearchViewController {
    func requestSearchData(text: String) {
        let url = MovieAPI.searchURL
        let header: HTTPHeaders = ["Authorization": MovieAPI.token]
        let parameter: Parameters = ["query": text]
        
        AF.request(url, method: .get,
                   parameters: parameter,
                   headers: header)
        .responseDecodable(of: MovieDTO.self) { response in
            switch response.result {
            case .success(let movie):
                self.movieList = movie.results
                print("--- success ---\n", movie)
                print("--- movieList ---\n", self.movieList)
            case .failure(let error):
                print("--- error ---\n", error)
            }
        }
    }
}

//MARK: - Cell
class SearchCollectionViewCell: UICollectionViewCell {
    static let id = "SearchCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black //임시
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

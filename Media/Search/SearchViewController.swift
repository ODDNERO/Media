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
    let searchBar = UISearchBar()
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
    }
    
    func configureView() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [searchBar, collectionView].forEach { view.addSubview($0) }
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        
        searchBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestSearchData(text: searchBar.text!)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as! SearchCollectionViewCell
        
        if let posterPath = movieList[indexPath.row].poster_path {
            cell.configureImage(source: posterPath)
        } else {
            cell.posterImageView.image = UIImage(systemName: "popcorn.fill")
        }
        print("posterImageView.image", cell.posterImageView.image)
        
        return cell
    }
}

//MARK: - Network
extension SearchViewController {
    func requestSearchData(text: String) {
        let url = MovieAPI.searchURL
        let header: HTTPHeaders = ["Authorization": MovieAPI.token,
                                   "accept" : "application/json"]
        let parameter: Parameters = ["query": text]
        
        AF.request(url, method: .get,
                   parameters: parameter,
                   headers: header)
        .responseDecodable(of: MovieDTO.self) { response in
            switch response.result {
            case .success(let movie):
                self.movieList = movie.results
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Cell
class SearchCollectionViewCell: UICollectionViewCell {
    static let id = "SearchCollectionViewCell"
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        
        contentView.addSubview(posterImageView)
        posterImageView.tintColor = .white
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.snp.makeConstraints { $0.edges.equalTo(contentView).inset(50) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(source: String){
        let url = URL(string: "\(MovieAPI.imageURL)\(source)")
        posterImageView.kf.setImage(with: url)
    }
}

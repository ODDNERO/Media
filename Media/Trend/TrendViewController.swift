//
//  TrendViewController.swift
//  Media
//
//  Created by NERO on 6/10/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class TrendViewController: UIViewController {
    let movieTableView = UITableView()
    var movieList: [Result] = []
    
    enum TimeWindow {
        static let day = "day"
        static let week = "week"
    }
    var isDay: Bool = true
    var timeWindow: String {
        return isDay ? TimeWindow.day : TimeWindow.week
    }
    
    var page: Int = 1
    var isEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureData()
        configureLayout()
        configureUI()
        settingNavigation()
        requestMovieData(timeWindow)
    }
}

//MARK: - Configure
extension TrendViewController {
    func configureHierarchy() {
        view.addSubview(movieTableView)
    }
    
    func configureData() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
        movieTableView.prefetchDataSource = self
    }
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        cell.movieID = movieList[indexPath.row].id
        cell.movieTitleLabel.text = movieList[indexPath.row].title
        cell.releaseDateLabel.text = movieList[indexPath.row].release_date
        cell.overviewLabel.text = movieList[indexPath.row].overview
        cell.voteAverageLabel.text = "\(movieList[indexPath.row].vote_average)"
        //        cell.posterImageView.image
        //        cell.backdropImageView.image
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 //임시
    }
}

extension TrendViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if movieList.count - 2 == item.row && isEnd == false {
                page += 1
                requestMovieData(timeWindow)
            }
        }
    }
}

//MARK: - Network
extension TrendViewController {
    func requestMovieData(_ timeWindow: String) {
        let url = MovieAPI.trendURL + "/\(timeWindow)"
        let header: HTTPHeaders = ["accept": "application/json",
                                   "Authorization": MovieAPI.token]
        let parameter: Parameters = ["language": "ko-KR",
                                     "page": page]
        
        AF.request(url, method: .get, parameters: parameter, headers: header)
            .responseDecodable(of: MovieDTO.self) { response in
                switch response.result {
                case .success(let movieDTO):
                    
                    if self.page == 1 {
                        self.movieList = movieDTO.results
                    } else {
                        self.movieList.append(contentsOf: movieDTO.results)
                    }
                    self.movieTableView.reloadData()
                    
                    if self.page == 1 {
                        self.movieTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                    self.isEnd = self.page == movieDTO.total_pages
                    
                    self.movieTableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//MARK: - Configure UI
extension TrendViewController {
    func configureLayout() {
        movieTableView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        movieTableView.separatorStyle = .none
    }
}

//MARK: - Switching View
extension TrendViewController {
    func settingNavigation() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "🔥 인기 영화"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        
        let timeWindowButton = UIBarButtonItem(title: timeWindow, style: .plain, target: self, action: #selector(timeWindowButtonClicked))
        navigationItem.rightBarButtonItem = timeWindowButton
        timeWindowButton.tintColor = .customBlue
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonClicked))
        navigationItem.leftBarButtonItem = searchButton
        searchButton.tintColor = .black
    }
    
    @objc func timeWindowButtonClicked() {
        isDay.toggle()
        settingNavigation()
        requestMovieData(timeWindow)
    }
    
    @objc func searchButtonClicked() {
        let searchNaviVC = UINavigationController(rootViewController: SearchViewController())
        searchNaviVC.modalPresentationStyle = .fullScreen
        present(searchNaviVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 값 전달 필요
        navigationController?.pushViewController(CreditViewController(), animated: true)
    }
}

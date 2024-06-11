//
//  TrendViewController.swift
//  Media
//
//  Created by NERO on 6/10/24.
//

import UIKit
import SnapKit
import Alamofire

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureData()
        configureLayout()
        configureUI()
        settingNavigation()
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
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 //임시
    }
}

//MARK: - Network
extension TrendViewController {
    func requestMovieData(_ timeWindow: String) {
        let url = MovieAPI.url + "/\(timeWindow)" + "?" + "api_key=\(MovieAPI.key)" + "&" + "language=ko-KR"
        print(url)
        
        AF.request(url).responseString(completionHandler: { response in
                print("url 테스트", response)
            })
        
        AF.request(url).responseDecodable(of: MovieDTO.self) { response in
                switch response.result {
                case .success(let movieDTO):
                    print("성공", movieDTO)
                    self.movieList = movieDTO.results
                    self.movieTableView.reloadData()
                case .failure(let error):
                    print("실패", error)
                }
            }
        
//        let header: HTTPHeaders = ["accept": "application/json",
//                                   "Authorization": "Bearer \(MovieAPI.key)"]
        
//        AF.request(url, method: .get, headers: header)
//            .responseString(completionHandler: { response in
//                print("테스트", response)
//            })
//        
//        AF.request(url, method: .get, headers: header)
//            .responseDecodable(of: MovieDTO.self) { response in
//                switch response.result {
//                case .success(let movieDTO):
//                    print("성공", movieDTO)
//                    self.movieList = movieDTO.results
//                    self.movieTableView.reloadData()
//                case .failure(let error):
//                    print("실패", error)
//                }
//            }
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
        navigationController?.navigationBar.tintColor = .customBlue
        navigationItem.title = "🔥 인기 영화"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.red
        ]
    }
}

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
        movieTableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
}

//MARK: - Configure UI
extension TrendViewController {
    func configureLayout() {
    }
    
    func configureUI() {
        view.backgroundColor = .white
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

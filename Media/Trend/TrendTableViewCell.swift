//
//  TrendTableViewCell.swift
//  Media
//
//  Created by NERO on 6/10/24.
//

import UIKit

class TrendTableViewCell: UITableViewCell {
    static let identifier = "TrendTableViewCell"
    var movieID = 0
    let cellView = UIView()
    
    let movieTitleLabel = UILabel()
    let releaseDateLabel = UILabel()
    let overviewLabel = UILabel()
    
    let voteAverageView = UIView()
    let starImageView = UIImageView()
    let voteAverageLabel = UILabel()
    
    let posterImageView = UIImageView()
    let backgroundImageView = UIImageView()
    let backdropImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [cellView, movieTitleLabel, releaseDateLabel, overviewLabel, voteAverageView, starImageView, voteAverageLabel, posterImageView, backdropImageView, backgroundImageView].forEach { contentView.addSubview($0) }
        
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: - Configure UI
extension TrendTableViewCell {
    func configureLayout() {
        cellView.snp.makeConstraints { $0.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8) }
        
        [backdropImageView, backgroundImageView].forEach {
            $0.snp.makeConstraints { $0.top.leading.trailing.equalTo(cellView) }
        }
    }
    
    func configureUI() {
        self.selectionStyle = .none
        contentView.layer.cornerRadius = 10
        cellView.backgroundColor = .systemGray5
        
        posterImageView.backgroundColor = .white
        posterImageView.layer.cornerRadius = 5
        backgroundImageView.image = UIImage(resource: .background)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.5
        
        releaseDateLabel.textColor = .systemGray5
        overviewLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        movieTitleLabel.textColor = .black
        movieTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        movieTitleLabel.numberOfLines = 0
        
        voteAverageView.backgroundColor = .customBlue
        voteAverageView.layer.cornerRadius = 25
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        voteAverageLabel.textColor = .white
        voteAverageLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        overviewLabel.textColor = .systemGray3
        overviewLabel.font = .systemFont(ofSize: 13, weight: .medium)
    }
}

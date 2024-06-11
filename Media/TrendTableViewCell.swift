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

    }
    
    func configureUI() {
        self.selectionStyle = .none

    }
}

//
//  BoxOfficeTableViewCell.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/8/24.
//

import UIKit
import SnapKit

final class BoxOfficeTableViewCell: UITableViewCell {
    static let identifier = "BoxOfficeTableViewCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let openDateButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(openDateButton)
        
        posterImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.centerY.equalToSuperview()
            make.leading.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalTo(openDateButton.snp.leading).offset(-10)
        }
        
        openDateButton.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        posterImageView.layer.cornerRadius = 10
        posterImageView.backgroundColor = .systemPink
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        openDateButton.backgroundColor = .lightGray
        openDateButton.layer.cornerRadius = 10
        
    }
    
    func configureData(data: DailyBoxOfficeList){
        titleLabel.text = data.movieNm
        openDateButton.setTitle(data.openDt, for: .normal)
    }
}

//
//  ShopTableViewCell.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShopTableViewCell: UITableViewCell {
    static let identifier = "ShopTableViewCell"
    
    let backView = UIView()
    let checkButton = UIButton()
    let titleLabel = UILabel()
    let starButton = UIButton()

    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureHierarchy(){
        contentView.addSubview(backView)
        backView.addSubview(checkButton)
        backView.addSubview(titleLabel)
        backView.addSubview(starButton)
    }
    
    private func configureLayout(){
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(3)
        }
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(23)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.trailing.equalTo(starButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        starButton.snp.makeConstraints { make in
            make.size.equalTo(23)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureUI(){
        backView.backgroundColor = .systemGray6
        backView.layer.cornerRadius = 10
        
        checkButton.tintColor = .black
        checkButton.setBackgroundImage(UIImage(systemName: "checkmark.rectangle.portrait"), for: .normal)
        starButton.tintColor = .black
        starButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)

    }
    
    func configureData(_ data: Shop){
        let isComplete = data.isComplete ? UIImage(systemName: "checkmark.rectangle.portrait.fill"):  UIImage(systemName: "checkmark.rectangle.portrait")
        let isFavorited = data.isFavorited ? UIImage(systemName: "star.fill"): UIImage(systemName: "star")
        let title = data.title
        
        checkButton.setBackgroundImage(isComplete, for: .normal)
        titleLabel.text = title
        starButton.setBackgroundImage(isFavorited, for: .normal)
    }
}

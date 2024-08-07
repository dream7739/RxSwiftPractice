//
//  ShopCollectionViewCell.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/7/24.
//

import UIKit
import SnapKit

final class ShopCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ShopCollectionViewCell.self)

    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 12)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemGray5
    }
}

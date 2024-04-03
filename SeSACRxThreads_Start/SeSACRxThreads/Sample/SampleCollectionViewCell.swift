//
//  SampleCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 김재석 on 3/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SampleCollectionViewCell: UICollectionViewCell {
    
    let userLabel = {
        
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .systemGray3
        clipsToBounds = true
        layer.cornerRadius = 8
        
        contentView.addSubview(userLabel)
        userLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateUI(_ itemIdentifier: User) {
        
        userLabel.text = itemIdentifier.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

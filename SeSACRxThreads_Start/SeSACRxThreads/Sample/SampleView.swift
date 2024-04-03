//
//  SampleView.swift
//  SeSACRxThreads
//
//  Created by 김재석 on 3/30/24.
//

import UIKit
import SnapKit

final class SampleView: UIView {
    
    let textField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        return view
    }()
    
    lazy var tableView = {
        let view = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        view.backgroundColor = .systemGray5
        view.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "SampleViewCell"
        )
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureHierarchy()
        configureConstraints()
    }
    
    private func configureHierarchy() {
        [
            textField,
            addButton,
            // collectionView,
            tableView,
        ].forEach { addSubview($0) }
    }
    
    private func configureConstraints() {
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-100)
            make.height.equalTo(44)
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
            make.leading.equalTo(textField.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(textField.snp.bottom).offset(12)
//            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
//            make.bottom.equalTo(safeAreaLayoutGuide)
//        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

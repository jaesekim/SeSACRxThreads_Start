//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 김재석 on 3/29/24.
//

import UIKit

class SampleViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }

    let mainView = SampleView()
    
    override func loadView() {
        view = mainView
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    
    var userList: [User] = [User(name: "jess"), User(name: "js")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setDelegate()
        configureDataSource()
        updateSnapshot()
    }
    
    private func bind() {
        
    }
    
    private func setDelegate() {
        mainView.collectionView.delegate = self
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SampleCollectionViewCell, User>
        { cell, indexPath, itemIdentifier in

            cell.updateUI(itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath, 
                    item: itemIdentifier
                )
                
                return cell
            }
        )
    }

    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(userList, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension SampleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = dataSource.itemIdentifier(for: indexPath) else { return }
        print(data.name)

    }
}

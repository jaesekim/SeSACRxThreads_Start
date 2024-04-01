//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 김재석 on 3/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

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
    
    var userTableList = BehaviorSubject<[User]>(value: [])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setDelegate()
        configureDataSource()
        updateSnapshot()
    }
    
    private func bind() {

        mainView.addButton.rx.tap
            .bind(with: self) { owner, _ in

                guard let name = owner.mainView.textField.text else { return }

                if name.isEmpty {
                    owner.view.makeToast("이름을 입력해 주세요")
                } else {
                    do {
                        try owner.userTableList.onNext(
                            owner.userTableList.value() + [User(name: name)]
                        )
                    } catch {
                        print(error)
                    }
                    // textField 초기화
                    owner.mainView.textField.text = ""
                }
            }
            .disposed(by: disposeBag)
        
        userTableList
            .bind(to: mainView.tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "SampleViewCell"
                )!
                cell.textLabel?.text = element.name
                
                return cell
            }
            .disposed(by: disposeBag)
        
        mainView.tableView
            .rx
            .itemSelected
            .bind(with: self) { owner, indexPath in
                do {
                    var users = try owner.userTableList.value()
                    users.remove(at: indexPath.row)
                    owner.userTableList.onNext(users)
                } catch {
                    print(error)
                }
            }
            .disposed(by: disposeBag)
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

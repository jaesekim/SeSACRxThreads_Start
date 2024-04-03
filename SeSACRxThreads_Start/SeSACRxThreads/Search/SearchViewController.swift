//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
      
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    //var data = [ User(name: "js"), User(name: "Jess")]
    
    lazy var items = BehaviorSubject(value: data)
     
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
     
    private func bind() {
        
        items.bind(to: tableView.rx.items(
            cellIdentifier: SearchTableViewCell.identifier,
            cellType: SearchTableViewCell.self)
        ) { (row, element, cell) in
            cell.updateUI(element)
        }
        .disposed(by: disposeBag)
        
        // 데이터 선택될 때 아이템 삭제
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(String.self)
        )
        .bind(with: self) { owner, value in
            // 데이터 삭제 후 subject에 전달하기
            owner.data.remove(at: value.0.row)
            owner.items.onNext(owner.data)
           
        }
        .disposed(by: disposeBag)
        
//        tableView
//            .rx
//            .itemSelected
//            .bind(with: self) { owner, indexPath in
//                print(indexPath)
//            }
//            .disposed(by: disposeBag)
//        
//        tableView
//            .rx
//            .modelSelected(String.self)
//            .bind(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        // 검색 버튼 클릭
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                
                print("Button OnClick:", text)

                let result = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        // searchBar text로 실시간 검색기능
        // 만약 실시간으로 네트워크 통신을 한다면? 값이 변경될 때마다 콜을 보내면 너무 비효율
        // distinctUntilChanged: 데이터가 변경되기 전까지 기존 값으로 처리하지 않는다
        // debounce: 설정한 시간 내에 observable에서 들어오는 요소는 처리하는데 무시한다.
        // 즉, 아래 경우에서는 1초이내에 입력된 text는 처리하지 않고 입력이 끝나고 1초가 지나야
        // observe를 수행한다.
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in

                let result = text.isEmpty ?
                owner.data : owner.data.filter { $0.contains(text) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setSearchController() {
        
        // searchBar navigation에 넣기
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "추가",
//            style: .plain,
//            target: self,
//            action: #selector(plusButtonClicked)
//        )
    }
    
    @objc func plusButtonClicked() {
        let sample = ["1", "2", "3", "4", "5"]
        data.append(sample.randomElement()!)
        items.onNext(data)
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}

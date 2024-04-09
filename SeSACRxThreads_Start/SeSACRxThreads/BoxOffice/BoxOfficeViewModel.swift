//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    
    // 컬렉션 뷰 데이터
    var recent = ["테스트", "테스트1", "테스트2"]
    
    // 테이블 뷰 데이터
    let movie = BehaviorSubject<[DailyBoxOfficeList]>(value: [])
    
    struct Input {
        // 인풋으로 받아올 것 정리
        // 클릭 이벤트(클릭 됐는지 여부 확인)
        let searchTap: ControlEvent<Void>
        
        // SearchBar text(사용자가 검색한 것)
        let searchedText: ControlProperty<String?>
        
        // tableView 개별 셀 클릭했을 때 영화제목
        let tableCellTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let recentList: PublishSubject<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
        
        input.searchTap.
        
        return Output(
            recentList: <#PublishSubject<[DailyBoxOfficeList]>#>
        )
    }
    
    
}





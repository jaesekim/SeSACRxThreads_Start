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
    var recent = Observable.just(["테스트", "테스트1", "테스트2"])
    
    // 테이블 뷰 데이터
    let movie = Observable.just(["테스트10", "테스트11", "테스트12"])
    
    struct Input {
        let searchTap: ControlEvent<Void>
    }
    
    struct Output {
        let recentList: PublishSubject<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
          
        return Output(
            recentList: <#PublishSubject<[DailyBoxOfficeList]>#>
        )
    }
    
    
}





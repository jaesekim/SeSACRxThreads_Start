//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let descriptionLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let initialPhoneNumber = Observable.just("010")
    let validText = BehaviorSubject(value: "핸드폰 번호를 입력해 주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    func bind() {
        
        // 화면 켜지면 textField에 010 보여주기
        initialPhoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        // validText descriptionLabel에 넣어주기
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // nextButton 클릭 시 다음 VC push binding
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(
                    BirthdayViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        let validation = phoneTextField
            .rx  // Reactive<SignTextField>
            .text
            .orEmpty
            .map { value in
                if value.count < 10 {
                    return false
                } else {
                    let stringArr = value.map { String($0) }

                    for element in stringArr {
                        if Int(element) == nil {
                            return false
                        }
                    }
                    return true
                }
            }

        validation
            .bind(to: nextButton.rx.isEnabled,
                  descriptionLabel.rx.isHidden
            )
            .disposed(by: disposeBag)
        
        validation.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .lightGray
            owner.nextButton.backgroundColor = color
        }
        .disposed(by: disposeBag)
    }


    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let descriptionLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let validText = BehaviorSubject(value: "비밀번호는 8자 이상 입력해 주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    func bind() {

        /*
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(
                    PhoneViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(with: self) { owner, value in
                
                guard let value = value else { return }

                if value.count >= 8 {
                    owner.validText.onNext("사용가능한 비밀번호입니다.")
                } else {
                    owner.validText.onNext("비밀번호는 8자 이상 입력해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        validText
            .bind(with: self) { owner, value in
                if value == "비밀번호는 8자 이상 입력해 주세요" {
                    owner.nextButton.backgroundColor = .lightGray
                    owner.nextButton.isEnabled = false
                } else {
                    owner.nextButton.backgroundColor = .systemPink
                    owner.nextButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
         */
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validtaion = passwordTextField
            .rx
            .text  // ControlProperty<String?>
            .orEmpty  // ControlProperty<String>
            .map { $0.count >= 8 }

        validtaion
            .bind(to: nextButton.rx.isEnabled,
                  descriptionLabel.rx.isHidden
            )
            .disposed(by: disposeBag)

        validtaion
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(
                    PhoneViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

//
//  ShareViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import UIKit
import RxCocoa
import RxSwift

class ShareViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let signInButton = PointButton(title: "버튼")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        driveTest()
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(signInButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension ShareViewController {
    private func driveTest() {
        let tap = signInButton.rx.tap
            .map { "랜덤번호\(Int.random(in: 0...100))" }
            .asDriver(onErrorJustReturn: "")
        
        tap
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        tap
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        tap
            .drive(nicknameTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindTest() {
        let tap = signInButton.rx.tap
            .map { "랜덤번호\(Int.random(in: 0...100))" }
            .share()
        
        tap
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        tap
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        tap
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let validText = BehaviorSubject(value: "만 17세 이상만 가입가능합니다.")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }
    
    func bind() {
        
        validText
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = birthDayPicker
            .rx
            .date
            .map { date in
                
                let component = Calendar.current.dateComponents(
                    [.year],
                    from: date,
                    to: Date()
                )
                
                if let age = component.year {
                    if age >= 17 {
                        return true
                    }
                }
                return false
            }
        
        // validation: infoLabel 변경
        validation
            .bind(with: self) { owner, bool in
                let color: UIColor = bool ? .systemBlue : .systemRed
                owner.infoLabel.textColor = color
                owner.validText.onNext(
                    bool ? "가입 가능한 나이입니다" :
                        "만 17세 이상만 가입가능합니다"
                )
            }
            .disposed(by: disposeBag)
        
        // validation: nextButton 변경
        validation
            .bind(with: self) { owner, bool in
                let color: UIColor = bool ? .systemBlue : .lightGray
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = bool
            }
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(
                    SampleViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

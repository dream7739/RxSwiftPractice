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

final class BirthdayViewController: UIViewController {
    private let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let nextButton = PointButton(title: "가입하기")
    
    private let year = BehaviorRelay(value: 0)
    private let month = BehaviorRelay(value: 0)
    private let day = BehaviorRelay(value: 0)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    private func bind(){
        birthDayPicker.rx.date
            .bind(with: self, onNext: { owner, value in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: value)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
            })
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .map { value in
                let compare = Calendar.current.dateComponents([.year], from: value, to: Date())
                let age = compare.year!
                return age > 17
            }
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemRed
                let buttonColor: UIColor = value ? .systemBlue : .lightGray
                let info: String = value ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다"
                
                owner.infoLabel.text = info
                owner.infoLabel.textColor = color
                owner.nextButton.backgroundColor = buttonColor
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "완료", content: nil)
            }
            .disposed(by: disposeBag)
        
        year.bind(with: self, onNext: { owner, value in
            owner.yearLabel.text = "\(value)년"
        })
        .disposed(by: disposeBag)
        
        month.bind(with: self, onNext: { owner, value in
            owner.monthLabel.text = "\(value)월"
        })
        .disposed(by: disposeBag)
        
        day.bind(with: self, onNext: { owner, value in
            owner.dayLabel.text = "\(value)일"
        })
        .disposed(by: disposeBag)
        
        
    }
    
    private func configureLayout() {
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

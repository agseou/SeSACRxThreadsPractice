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
    let nextButton = PointButton(title: "다음")
    
    var vaildatedPhoneNumber = Observable.just("010")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configureBind()
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureBind() {
        
        vaildatedPhoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let validation = phoneTextField.rx.text
            .orEmpty
            .map { $0.count >= 13 } 
        
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .map { $0 ? UIColor.systemPink : UIColor.lightGray}
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        // 전화번호 처리
        phoneTextField.rx.text
            .orEmpty
            .map { $0.filter { $0.isNumber } } //숫자만!
            .map { String($0.prefix(11)) } // 3+4+4 자 제한
            .map { filteredText -> String in
                var formattedString = ""
                for char in filteredText {
                    if formattedString.count == 3 || formattedString.count == 8 {
                        formattedString.append("-")
                    }
                    formattedString.append(char)
                }
                return formattedString
            }
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}

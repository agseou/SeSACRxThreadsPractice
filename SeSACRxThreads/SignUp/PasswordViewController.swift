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


// Case 1)
// passwordTextField에 받아온 값에 대해 조건 처리하여 -> Bool 값 반환
// 왜냐면 password가 유효한지에 대해 참 & 거짓만 받으면 되니까.
// 그렇다면 나는 텍스트가 유효한지에 대해서 하나의 bind { } 안에서 다 처리해야겠어.
class PasswordViewController: UIViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    var validText = Observable.just("8자 이상 입력해야 합니다.")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configureBind()
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
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureBind() {
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text // ControlProperty<String?>
            .orEmpty // [옵셔널 해제] ControlProperty<String>
            .map { $0.count >= 8 } // Bool 값 반환
            .bind(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? .systemPink : .lightGray
                owner.descriptionLabel.isHidden = value
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

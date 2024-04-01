//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    let email = PublishSubject<String>()
    let password = PublishSubject<String>()
    
    var validation = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        Observable
            .combineLatest(email, password)
            .map { email, password -> Bool in
        
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                if password.count >= 8 && NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: validation)
            .disposed(by: disposeBag)
    }
    
}

//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by eunseou on 3/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    let addButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        return button
    }()
    lazy var tableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = BehaviorSubject<[Int]>(value: [])
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureLayout()
        configureBind()
    }
    
    func configureLayout() {
        view.backgroundColor = .gray
        view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func configureBind() {
        addButton.rx.tap
            .bind(with: self) { owner, _ in
                var currentItems = try! owner.items.value()
                currentItems.append((currentItems.last ?? 0) + 1)
                owner.items.onNext(currentItems)
            }
            .disposed(by: disposeBag)
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element)"
            }
            .disposed(by: disposeBag)
    }
    
}

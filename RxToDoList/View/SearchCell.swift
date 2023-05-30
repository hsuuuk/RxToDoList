//
//  SearchCell.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/30.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: SearchCellViewModel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(task: Task) {
        viewModel = SearchCellViewModel(task: task)
        
        viewModel?.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel?.descriptionDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

//
//  MemoCell.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit

class MemoCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel: MemoCellViewModel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(memo: Memo) {
        viewModel = MemoCellViewModel(memo: memo)
        
        viewModel?.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel?.contentDriver
            .drive(contentLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel?.dateDriver
            .drive(dateLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

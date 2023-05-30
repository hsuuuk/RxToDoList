//
//  AddMemoViewController.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit

enum MemoMode {
    case add
    case view
}

class AddMemoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var viewModel: MemoViewModel!
    
    var memo: Memo?
    var memoMode: MemoMode?
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        
        if let memo = memo {
            titleTextField.text = memo.title
            contentTextView.text = memo.content
        }
        
        if memoMode == .view {
            doneButton.image = UIImage(systemName: "trash")
            doneButton.tintColor = .systemRed
            doneButton.action = #selector(didTapDelete)
        }
    }
    
    @objc func didTapDelete() {
        let actionSheet = UIAlertController(title: nil, message: "정말로 삭제하시겠습니까?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            var memos = self.viewModel.memoObservable.value
            guard let index = self.index else { return }
            memos.remove(at: index)
            self.viewModel.memoObservable.accept(memos)
            
            navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            actionSheet.dismiss(animated: true)
        }
        cancelAction.setValue(UIColor(red: 0.478, green: 0.506, blue: 1, alpha: 1), forKey: "titleTextColor")
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let content = contentTextView.text else { return }
        
        let newMemo = Memo(title: title, content: content)
        
        viewModel.addMemo(newMemo: newMemo)
        
        navigationController?.popViewController(animated: true)
    }
}

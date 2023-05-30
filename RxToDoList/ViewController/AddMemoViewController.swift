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
    case edit
}

class AddMemoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var viewModel: MemoViewModel!
    
    var memo: Memo?
    var memoMode: MemoMode?
    
    var index: Int?
    
    var popoverController: UIPopoverPresentationController?
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        
        if let memo = memo {
            titleTextField.text = memo.title
            titleTextField.isEnabled = false
            contentTextView.text = memo.content
            contentTextView.isSelectable = false
        }
        
        if memoMode == .view {
            navigationItem.title = "메모"
            doneButton.image = UIImage(systemName: "ellipsis")
            doneButton.tintColor = .black
            doneButton.action = #selector(didTapDelete)
        }
        
        if memoMode == .edit {
            navigationItem.title = "메모 수정"
            doneButton.image = UIImage(systemName: "pencil")
            doneButton.tintColor = .black
            doneButton.action = #selector(didTapEdit)
        }
    }
    
    @objc func didTapEdit() {
        guard let title = titleTextField.text else { return }
        guard let content = contentTextView.text else { return }
        guard let index = index else { return }
        
        let updatedMemo = Memo(title: title, content: content)
        
        viewModel.updateMemo(updateMemo: updatedMemo, index: index)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func didTapDelete(_ sender: UIBarButtonItem) {
        let popoverVC = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 150, height: 90)
        
        popoverController = popoverVC.popoverPresentationController
        popoverController?.delegate = self
        popoverController?.barButtonItem = sender
        popoverController?.permittedArrowDirections = [] //말풍선 꼬리 삭제 -> 네모
        
        present(popoverVC, animated: true, completion: nil)
        
        popoverVC.viewModel = self.viewModel
        popoverVC.index = self.index
        
        popoverVC.onDismiss = {
            self.navigationController?.dismiss(animated: true)
            self.onDismiss?()
        }
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let content = contentTextView.text else { return }
        
        let newMemo = Memo(title: title, content: content)
        
        viewModel.addMemo(newMemo: newMemo)
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddMemoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//
//  PopoverViewController.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let actionArr = ["편집", "삭제"]
    
    var viewModel: MemoViewModel!
    
    var index: Int?
    
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = false
    }
}

extension PopoverViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = actionArr[indexPath.row]
        if indexPath.row == 1 {
            cell.textLabel?.textColor = .red
        } else {
            cell.textLabel?.textColor = .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let storyboard = UIStoryboard(name: "AddMemoStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AddMemoStoryboard") as! AddMemoViewController
            controller.memoMode = .edit
            let navigation = UINavigationController(rootViewController: controller)
            navigationController?.present(navigation, animated: true)
            
        } else if indexPath.row == 1 {
            
            let actionSheet = UIAlertController(title: nil, message: "정말로 삭제하시겠습니까?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let index = self?.index else { return }
                self?.viewModel.deleteMemo(index: index)
                
                actionSheet.dismiss(animated: true) {
                    self?.onDismiss?()
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                actionSheet.dismiss(animated: true)
            }
            cancelAction.setValue(UIColor(red: 0.478, green: 0.506, blue: 1, alpha: 1), forKey: "titleTextColor")
            
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
}

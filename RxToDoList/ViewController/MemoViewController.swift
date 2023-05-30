//
//  MemoViewController.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class MemoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = MemoViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.memoObservable
            .bind(to: collectionView.rx.items(cellIdentifier: "MemoCell", cellType: MemoCell.self)) { index, item, cell in
                
                cell.bind(memo: item)
                cell.layer.cornerRadius = 10
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let memo = self.viewModel.memoObservable.value[indexPath.item]
                
                let storyboard = UIStoryboard(name: "AddMemoStoryboard", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "AddMemoStoryboard") as! AddMemoViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
                controller.viewModel = self.viewModel
                controller.memo = memo
                controller.memoMode = .view
                controller.index = indexPath.item
                
                controller.onDismiss = {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: rx.disposeBag)
        
//        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - 150)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "메모"
    }
  
    @IBAction func showAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddMemoStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddMemoStoryboard") as! AddMemoViewController
        navigationController?.pushViewController(controller, animated: true)
        
        controller.viewModel = self.viewModel
    }
    
    @IBAction func showXmark(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

extension MemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 5
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

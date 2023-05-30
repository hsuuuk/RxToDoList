//
//  TasksViewController.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")
        
        //🚫 Error: Add missing conformance to 'UIScrollViewDelegate' to class 'DSViewController'
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        //⚒️ Fixed: UITableViewDelegate를 채택하면 사라진다.
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            
            if indexPath.section == 0 {
                cell.stackView.arrangedSubviews[0].isHidden = true
            } else {
                if item.time == "" {
                    cell.stackView.arrangedSubviews[0].isHidden = true
                } else {
                    cell.stackView.arrangedSubviews[0].isHidden = false
                }
            }
            
            // #1
//            cell.titleLabel.text = item.title
//            cell.descriptionLabel.text = item.description
//            cell.timeLabel.text = item.time
            
            // #2
            cell.bind(task: item)
            
            cell.toggleCheckButton = { [weak self] in
                self?.viewModel.toggleIsCompleted(indexPath: indexPath)
            }

            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        viewModel.sectionObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.deleteTask(indexPath: indexPath)
            })
            .disposed(by: rx.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let storyboard = UIStoryboard(name: "AddStoryboard", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "AddStoryboard") as! AddViewController
                controller.taskMode = .edit
                let navigation = UINavigationController(rootViewController: controller)
                navigationController?.present(navigation, animated: true)
                
                controller.viewModel = self.viewModel
                
                let section = viewModel.sectionObservable.value[indexPath.section]
                let task = section.items[indexPath.row]
                controller.task = task
                
                controller.indexPath = indexPath
            })
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CalendarStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarStoryboard") as! CalendarViewController
        //navigationController?.pushViewController(controller, animated: true)
        let navigation = UINavigationController(rootViewController: controller)
        navigationController?.present(navigation, animated: true)
        
        controller.viewModel = self.viewModel
    }
    
    @IBAction func showMemo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MemoStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemoStoryboard") as! MemoViewController
        let navigation = UINavigationController(rootViewController: controller)
        navigationController?.present(navigation, animated: true)
    }
    
    @IBAction func showAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddStoryboard") as! AddViewController
        //🚫 Error: modal 방식으로 화면을 띄우면 네비게이션바가 보이지 않는 에러.
        let navigation = UINavigationController(rootViewController: controller)
        navigationController?.present(navigation, animated: true)
        //💡 Fixed: 모달 방식은 기본적으로 네비게이션바를 띄우지 않기 때문에 화면을 네비게이션 컨트롤러로 래핑한 후에 표시.
        
        controller.viewModel = self.viewModel // ViewModel 인스턴스를 의존성 주입.
    }
    
    @IBAction func showSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchStoryboard") as! SearchViewController
        let navigation = UINavigationController(rootViewController: controller)
        navigationController?.present(navigation, animated: true)
        
        controller.viewModel = self.viewModel
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 18
    }
}

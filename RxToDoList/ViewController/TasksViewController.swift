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
import Action

class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    let viewModel = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        // Error: Add missing conformance to 'UIScrollViewDelegate' to class 'DSViewController'
        // UITableViewDelegate를 채택하면 사라진다.
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section> { dataSource, talbeView, indexPath, item in
            let cell = talbeView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            cell.timeLabel.text = item.time
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        viewModel.sectionObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }

    @IBAction func didTapAdd(_ sender: Any) {
        print("11")
    }
    @IBAction func didTapCalendar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CalendarStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarStoryboard")
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//
//  CalendarViewController.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx
import FSCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var viewModel: TaskViewModel!
    
    var scheduledTasks = BehaviorRelay<[String: [Task]]>(value: [:])
    var filterdTask = [Task]()
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.select(selectedDate)
        
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .red
        
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
                
        let dataSource = RxTableViewSectionedReloadDataSource<Section> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell

            cell.bind(task: item)
            
            cell.toggleCheckButton = { [weak self] in
                let date = self?.viewModel.selectedDate.value ?? Date()
                self?.viewModel.toggleIsCompleted(indexPath: indexPath, date: date)
            }

            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        viewModel.filteredSection
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction func didTapWeek(_ sender: Any) {
        if calendar.scope == .month {
            calendar.scope = .week
            heightConstraint.constant = 120
        } else {
            calendar.scope = .month
            heightConstraint.constant = 300
        }
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectedDate.accept(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let sections = viewModel.sectionObservable.value
        guard let index = sections.firstIndex(where: { $0.headerTitle == date.toStringDate() }) else { return 0 }
        let tasks = sections[index].items.filter ({ $0.date == date.toStringDate() })
        
        if tasks.count > 0 {
            return 1
        }

        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let sections = viewModel.sectionObservable.value
        guard let index = sections.firstIndex(where: { $0.headerTitle == date.toStringDate() }) else { return nil }
        let tasks = sections[index].items.filter ({ $0.date == date.toStringDate() })
        
        if !tasks.isEmpty {
            return [UIColor.systemPink]
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let sections = viewModel.sectionObservable.value
        guard let index = sections.firstIndex(where: { $0.headerTitle == date.toStringDate() }) else { return nil }
        let tasks = sections[index].items.filter ({ $0.date == date.toStringDate() })
        
        if !tasks.isEmpty {
            return [UIColor.systemPink]
        }
        
        return nil
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 18
    }
}

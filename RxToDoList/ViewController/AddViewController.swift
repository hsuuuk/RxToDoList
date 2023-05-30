//
//  AddViewController.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

enum taskMode {
    case add
    case edit
    case view
}

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var dataStack: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var viewModel: TaskViewModel!
    
    var task: Task?
    var taskMode: taskMode?
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var indexPath: IndexPath?
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        dateTextField.text = Date().toStringDate()
        timeTextField.text = Date().toStringTime()
        
        setDatePicker()
        setTimePicker()
        
        if taskMode == .view {
            navigationItem.title = "할일"
            
            guard let task = task else { return }
            titleTextField.text = task.title
            dateTextField.text = task.date
            timeTextField.text = task.time
            descriptionTextField.text = task.description
            
            titleTextField.isEnabled = false
            descriptionTextField.isEnabled = false
            dateTextField.isEnabled = false
            timeTextField.isEnabled = false
            segmentedControl.isEnabled = false
            doneButton.isHidden = true
            
            if task.date == "" {
                segmentedControl.selectedSegmentIndex = 1
            } else {
                segmentedControl.selectedSegmentIndex = 0
            }
        }
        
        if taskMode == .edit {
            navigationItem.title = "할일 수정"
            
            guard let task = task else { return }
            titleTextField.text = task.title
            dateTextField.text = task.date
            timeTextField.text = task.time
            descriptionTextField.text = task.description
            
            let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(didTapEdit))
            let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(didTapDelete))
            editButton.tintColor = .black
            deleteButton.tintColor = .black
            
            navigationItem.rightBarButtonItems = [editButton, deleteButton]
            
            //📌 viewDidLoad는 동기적으로 작동하기 때문에 segmentedControl를 먼저 초기화 후에 액션 구독.
            if task.date == "" {
                segmentedControl.selectedSegmentIndex = 1
            } else {
                segmentedControl.selectedSegmentIndex = 0
            }
        }
        
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let self = self else { return }
                
                if selectedIndex == 0 {
                    self.dataStack.subviews[0].isHidden = false
                    self.dataStack.subviews[1].isHidden = false
                } else {
                    self.dataStack.subviews[0].isHidden = true
                    self.dataStack.subviews[1].isHidden = true
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        let toolBar = UIToolbar()
        let okayButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(dateDoneButton))
        toolBar.items = [okayButton]
        toolBar.sizeToFit()

        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
    }
    
    func setTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "ko-KR")
        
        let toolBar = UIToolbar()
        let okayButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(timeDoneButton))
        toolBar.items = [okayButton]
        toolBar.sizeToFit()
        
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = toolBar
    }
    
    @objc func didTapDelete() {
        let actionSheet = UIAlertController(title: nil, message: "정말로 삭제하시겠습니까?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let indexPath = self?.indexPath else { return }
            self?.viewModel.deleteTask(indexPath: indexPath)
            
            self?.navigationController?.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            actionSheet.dismiss(animated: true)
        }
        cancelAction.setValue(UIColor(red: 0.478, green: 0.506, blue: 1, alpha: 1), forKey: "titleTextColor")
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func didTapEdit() {
        guard let title = titleTextField.text else { return }
        guard let date = dateTextField.text, !date.isEmpty else { return }
        guard let time = timeTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        guard let indexPath = indexPath else { return }
        let updateTask = Task(title: title, description: description, date: date, time: time)
        
        viewModel.updateTask(updateTask: updateTask, indexPath: indexPath)
        
        navigationController?.dismiss(animated: true)
    }
    
    @objc func dateDoneButton() {
        dateTextField.text = datePicker.date.toStringDate()
        dateTextField.resignFirstResponder() //📌 키보드 disappear. 주로 버튼 탭 이후 설정.
    }
    
    @objc func timeDoneButton() {
        timeTextField.text = timePicker.date.toStringTime()
        timeTextField.resignFirstResponder()
    }
    
    @IBAction func didTapCheck(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let date = dateTextField.text, !date.isEmpty else { return }
        guard let time = timeTextField.text else { return }
        guard let description = descriptionTextField.text else { return }

        //🚫 Error: 데이터가 전달은 되지만 UI가 업데이트가 안되는 에러.
//        var task = viewModel.sectionObservable.value
//        task[0].items.append(newTask)
//        viewModel.sectionObservable.accept(task)
        
        //💡 Fixed #1 : 새로운 Observable을 만들어 외부의 TaskViewController에서 구독하고 viewModel에 전달.
        // -> 근본적인 해결이 아님. 코드가 간단할 때는 가능하나 복잡해지면 안됨.
        
        //💡 #2 Fixed: 서로 다른 ViewModel 인스턴스 때문에 동기화가 안되었고, 외부에서 ViewModel을 주입 받아 인스턴스를 동기화. -> 의존성 주입을 통한 ViewModel 인스턴스를 주입함으로서 ViewModel 정보 공유
        // let viewModel = TaskViewModel() -> var viewModel: TaskViewModel!
        
        //viewModel.addTask(newTask: newTask)
        
        //💡 #3 Fixed: ViewModel에 저장 기능을 구현해 코드 간소화

        if segmentedControl.selectedSegmentIndex == 0 {
            let newTask = Task(title: title, description: description, date: date, time: time)
            viewModel.addTask(newTask: newTask)
        } else  {
            let newTask = Task(title: title, description: description)
            viewModel.addTask(newTask: newTask)
        }
        
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func didTapCancle(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}


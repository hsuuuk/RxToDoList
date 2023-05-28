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

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var dataStack: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: TaskViewModel!
    
    let dateOn: Int = 0
    let anytimeOn: Int = 1
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    let newTaskObservable = PublishSubject<Task>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDatePicker()
        setTimePicker()
        
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
        let okayButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapOkayButton))
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
        let okayButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapOkayButton2))
        toolBar.items = [okayButton]
        toolBar.sizeToFit()
        
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = toolBar
    }
    
    @IBAction func segmentAction(_ sender: Any) {
        
    }
    
    @objc func didTapOkayButton() {
        dateTextField.text = datePicker.date.toDateString()
        dateTextField.resignFirstResponder()
    }
    
    @objc func didTapOkayButton2() {
        timeTextField.text = datePicker.date.toTimeString()
        timeTextField.resignFirstResponder()
    }
    
    @IBAction func didTapCheck(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let date = dateTextField.text else { return }
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
            viewModel.addTask(newTask: newTask, sectionIndex: 0)
        } else  {
            let newTask = Task(title: title, description: description)
            viewModel.addTask(newTask: newTask, sectionIndex: 1)
        }
        
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func didTapCancle(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

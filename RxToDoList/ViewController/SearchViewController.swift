//
//  SearchViewController.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var viewModel: TaskViewModel!
    
    //📌 viewWillAppear에 설정하지 않은 이유는, 뷰 컨트롤러의 뷰가 화면에 나타나기 직전에 호출되기 때문에 안전하게 firstResponder를 설정하기 위해 뷰 컨트롤러의 뷰가 화면에 완전히 나타난 직후에 호출되는 viewDidAppear에 설정
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.searchFilteredSection.accept([])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
        
        let nib = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchCell")
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell

            cell.bind(task: item)

            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        viewModel.searchFilteredSection
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
            
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                let storyboard = UIStoryboard(name: "AddStoryboard", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "AddStoryboard") as! AddViewController
                controller.taskMode = .view
                let navigation = UINavigationController(rootViewController: controller)
                navigationController?.present(navigation, animated: true)
                
                controller.viewModel = self.viewModel
                
                let section = viewModel.searchFilteredSection.value[indexPath.section]
                let task = section.items[indexPath.row]
                controller.task = task
                
                controller.indexPath = indexPath
            })
            .disposed(by: rx.disposeBag)
    }
    
    func setSearchController() {
        var searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "키워드"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.automaticallyShowsCancelButton = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @IBAction func didTapXmark(_ sender: Any) {
        viewModel.searchFilteredSection.accept([])
        
        dismiss(animated: true)
    }
}

extension SearchViewController: UISearchControllerDelegate ,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            infoLabel.isHidden = true
            
            let sections = viewModel.sectionObservable.value
            let filteredSections = sections.filter { $0.items.contains { $0.title.contains(text) || $0.description.contains(text) } }
            viewModel.searchFilteredSection.accept(filteredSections)
        } else {
            infoLabel.isHidden = false
            
            viewModel.searchFilteredSection.accept([])
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

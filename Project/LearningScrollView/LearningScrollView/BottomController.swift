////
////  BottomController.swift
////  LearningScrollView
////
////  Created by Long Bảo on 10/05/2023.
////
//
//import UIKit
//
//class BottomController: UIViewController {
//    //MARK: - Properties
//    let tableView = UITableView()
//    private var numberRowInSection: Int!
//    let titleController: String
//    
//    
//    //MARK: - View Lifecycle
//    init(numberRow: Int, title: String) {
//        self.numberRowInSection = numberRow
//        self.titleController = title
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureUI()
//    }
//    
//    
//    //MARK: - Helpers
//    func configureUI() {
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.identifier)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    //MARK: - Selectors
//    
//}
////MARK: - delegate
//extension BottomController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.numberRowInSection
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as! BottomTableViewCell
//        cell.configureUI()
//        cell.numberLabel.text = String(indexPath.row)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//}
//
//

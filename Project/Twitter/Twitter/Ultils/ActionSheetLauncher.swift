//
//  ActionSheetLauncher.swift
//  Twitter
//
//  Created by Long Bảo on 24/02/2023.
//

import Foundation
import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    //MARK: - Properties
    private let user: User
    private lazy var viewModel = ActionSheetViewModel(user: user)
    private let tableView =  UITableView()
    private var window: UIWindow?
    var delegate: ActionSheetLauncherDelegate?
    
    private lazy var blackView: UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(hanldeDissmiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        cancelButton.layer.cornerRadius = 34 / 2
        return view
    }()
    
    
    //MARK: Life Cycle
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    // MARK: Helpers
    func show() {
        print("DEBUG: Show action Sheet for user: \(user.userName)")
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
        self.window = window
        window.addSubview(blackView)
        window.addSubview(tableView)
        
        blackView.frame = window.frame
        let height = CGFloat(viewModel.options.count * 60) + 80
        
        tableView.frame = CGRect(x: 0, y: window.frame.height , width: window.frame.width, height: height)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= height
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            let height = CGFloat(3 * 60) + 80
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += height
        }
    }
    
    @objc func hanldeDissmiss() {
        blackView.removeFromSuperview()
    }
    
}

//MARK: - TableViewDelegate,DataSource
extension ActionSheetLauncher: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        UIView.animate(withDuration: 0.5) {
            let height = CGFloat(3 * 60) + 80
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += height
            self.delegate?.didSelect(option: option)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}

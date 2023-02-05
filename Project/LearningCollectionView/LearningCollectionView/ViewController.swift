//
//  ViewController.swift
//  LearningCollectionView
//
//  Created by Long Bảo on 20/01/2023.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    let layout = UICollectionViewFlowLayout()
    let  identifierCollectionViewCell = "cellId"
    let  identifierHeaderView = "headerView"
    let  identifierFooterView = "footerView"
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        layout.minimumLineSpacing = 10 //Thay đổi khoảng cách giữa các Line trong collection View
        layout.minimumInteritemSpacing = 1  //Thay đổi khoảng cách giữa các element trong cùng 1 Line
        
        layout.footerReferenceSize = CGSize(width: 0, height: 100)
        layout.headerReferenceSize = CGSize(width: 0, height: 60)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: identifierCollectionViewCell)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifierHeaderView)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifierFooterView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 50)           // Size của Header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 30)           //Size của Footer
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 38, left: 0, bottom: 38, right: 0)  //Khoảng cách giữa header, footer với các element bên trong
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2.1, height: 65)     // Size của Element
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = layout.collectionView?.dequeueReusableCell(withReuseIdentifier: identifierCollectionViewCell, for: indexPath) as! CollectionViewCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         print("DEBUG: \(kind)")
         if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierHeaderView, for: indexPath) as! HeaderView
            view.label.text = "Hello ae Header"
            return view
         } else {
             let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierFooterView, for: indexPath) as! FooterView
             view.label.text = "Hello ae Footer"
             return view
         }
    }
}


//
//  HomeController.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case UpcomingMovies = 3
    case Toprated = 4
}

class HomeViewController: UIViewController {
    //MARK: - Properties
    let sectionTilte: [String] = ["Trending Movies", "Popular", "Trending TV", "Upcoming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped) //.grouped: Mỗi Section có một footer và header
        table.register(CollectionViewCellTableViewCell.self, forCellReuseIdentifier: CollectionViewCellTableViewCell.identifier)
        return table
    }()
    
    private lazy var headerTableView : HeroHeaderView = {
        let heroHeader = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        return heroHeader
    }()
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.translatesAutoresizingMaskIntoConstraints = false
        homeFeedTable.frame = view.frame
        homeFeedTable.tableHeaderView = headerTableView
        
        configureHeadertableView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)   // Nếu không sử dụng cái này thì cái logo kia bị chuyển sang màu xanh
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: .none)
        
        navigationItem.rightBarButtonItems = [              // rightBarButtonItems có chữ s
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: .none),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: .none)
        ]
        
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    private func configureHeadertableView() {
        APICaller.shared.getTrendingMovies { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let data):
                    guard let randomData = data.randomElement() else {return}
                    self.headerTableView.configureHeaderView(with: randomData)
                case .failure(let error):
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
        }
    }
    
    ///  Khi scroll xuống ko bị navigationBar che
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y     //Khi scroll xuống sẽ lấy được vị trí của HomeViewController trong ScollView
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    //MARK: - Selectors


}

//MARK: - Extension UiTableViewDelegate and Datasourc
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTilte.count
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Selected >>>")
        if navigationController == nil {
            print("DEBUG: navigationController = nil")
        }
        navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTilte[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.text = header.textLabel?.text?.convertSectionTitle()
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 60, y: header.bounds.origin.y, width: 100, height: header.bounds.height)  //Dùng chưa thấy tác dụng
//        header.layer.borderWidth = 2
//        header.layer.borderColor = UIColor.white.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewCellTableViewCell.identifier, for: indexPath) as! CollectionViewCellTableViewCell
        configureCell(indexPath: indexPath, cell: cell)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    private func configureCell(indexPath: IndexPath, cell: CollectionViewCellTableViewCell) {
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case.success(let data):
                    cell.resultsAPICaller = data
                case .failure(let error):
                    print("DEBUG: \(error)")
                    return
                }
            }
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result{
                case.success(let data):
                    cell.resultsAPICaller = data
                    
                case .failure(let error):
                    print("DEBUG: \(error)")
                    return
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularFilm { result in
                switch result{
                case.success(let data):
                    cell.resultsAPICaller = data
                   
                case .failure(let error):
                    print("DEBUG: \(error)")
                    return
                }
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingFilms { result in
                switch result{
                case.success(let data):
                    cell.resultsAPICaller = data
                    
                case .failure(let error):
                    print("DEBUG: \(error)")
                    return
                }
            }
        case Sections.Toprated.rawValue:
            APICaller.shared.getTopratedFilm { result in
                switch result{
                case.success(let data):
                    cell.resultsAPICaller = data
                    
                case .failure(let error):
                    print("DEBUG: \(error)")
                    return
                }
            }
        default:
            return
        }
    }

}

//MARK: - Delegate CollectionViewCellTableViewCellDelegate
extension HomeViewController: CollectionViewCellTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewCellTableViewCell, viewModel: FilmPreviewViewModel) {
        DispatchQueue.main.async {
            let trailerVC = TrailerPreviewController()
            trailerVC.updateSubView(with: viewModel)
            self.navigationController?.pushViewController(trailerVC, animated: true)
        }
    }
}

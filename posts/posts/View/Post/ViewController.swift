
import UIKit

class ViewController: UIViewController{

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = UIRefreshControl()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var viewModel: ViewModel = .init(service: .shared)
    private var posts: [CellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        createTable()
        bindToVM()
        fetchData()
    }
    
    private func createTable() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(PostTableViewCell.nibName, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func bindToVM() {
        viewModel.posts.bind { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(posts):
                    self?.posts = posts
                    self?.tableView.backgroundView = nil
                case .failure:
                    self?.posts = []
                    let label = UILabel()
                    label.text = "Network Error"
                    label.sizeToFit()
                    self?.tableView.backgroundView = label
                }
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    private func fetchData() {
        tableView.refreshControl?.beginRefreshing()
        viewModel.fetchData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showSecondVC()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.initialize(with: self.posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

extension ViewController {
    func showSecondVC() {
        let viewController = SecondViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

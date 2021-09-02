
import Foundation

final class ViewModel {
    let service: NetworkService

    init(service: NetworkService = .shared) {
        self.service = service
    }

    var posts = Observable<Result<[CellViewModel], Error>?>(nil)

    func fetchData() {
        let endpoint = EndPoint(methodName: "posts", httpMethod: .get)
        service.withRequest(endpoint: endpoint, parameters: DefaultParameters(), resultData: [Post].self) { [posts] result in
            switch result {
            case let .success(value):
                let cellViewModels = value.map { CellViewModel(id: $0.id, cellText: $0.title) }
                posts.value = .success(cellViewModels)
            case let .failure(error):
                posts.value = .failure(error)
            }
        }
    }
}

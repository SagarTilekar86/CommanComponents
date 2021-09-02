
import UIKit
import Combine

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    private var viewModel: CellViewModel!

    func initialize(with viewModel: CellViewModel) {
        self.viewModel = viewModel
        cellLabel.text = viewModel.cellText
    }
    
    static var nibName: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

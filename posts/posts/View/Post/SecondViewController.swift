
import UIKit

final class SecondViewController: UIViewController {

    convenience init() {
        self.init(nibName: "SecondViewController", bundle: .main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func facebookTapped(_ sender: Any) {
        let vc = FacebookViewController(nibName: "FacebookViewController", bundle: .main)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func twitterTapped(_ sender: Any) {
        let vc = TwitterViewController(nibName: "TwitterViewController", bundle: .main)
        navigationController?.pushViewController(vc, animated: true)
    }
}


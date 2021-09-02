
import UIKit
import Swifter
class TwitterViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jsonResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = jsonResult[indexPath.row]["text"].string ?? "" + "\n\n\n\n 0000" + jsonResult[indexPath.row]["created_at"].string!
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    var jsonResult: [JSON] = []
    @IBOutlet weak var twitter: UITableView!
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        twitter.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.twitter?.rowHeight = UITableView.automaticDimension
        twitter.dataSource = self
        self.twitter.isHidden = true
        self.title = "Tweets"

    }

    @IBAction func getTwittersFee() {
         let swifter = Swifter(
        consumerKey: "KNS6Ff937wFHuKddu1ib7Wjc7",
        consumerSecret: "AF7vzCKjnlmbfvAM6fk9qvQSimyEjjVwG4Wo0DReGrvGR1OgVi")        // Do any additional setup after loading the view.
        if let url = URL(string: "SocialIntegrationApp://") {
            swifter.authorize(withCallback: url, presentingFrom: self, success: { (token, res) in
            print("it worked---------")
                swifter.getHomeTimeline(count: 1, success: { json in
                  // ...
                    self.jsonResult = json.array ?? []
                    swifter.getTimeline(for: .screenName("maddyforeverfor"), customParam: [:], count: 50, sinceID: "187273736", maxID: nil, trimUser: false, excludeReplies: false, includeRetweets: true, contributorDetails: true, includeEntities: true, tweetMode: .default, success: { (json) in
                             self.jsonResult = json.array ?? []
                        self.twitter.reloadData()
                        self.twitter.isHidden = false
                         }) { (err) in

                         }

                }, failure: { error in
                  // ...
                })
            },failure: {(Error)in

            }
        ) }
    }

}



import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit


class FacebookViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var facebookButton: UIButton!
    var id = ""
    @IBOutlet weak var fbTableview: UITableView!
    var arrMessage = [["":""]]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Facebook post"
        fbTableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fbTableview?.rowHeight = UITableView.automaticDimension
        fbTableview.dataSource = self
        self.fbTableview.isHidden = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrMessage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var str : String = (arrMessage[indexPath.row]["message"] ?? "") as String
        str = str + "\n" + (arrMessage[indexPath.row]["story"] ?? "") as String + "\n " + (arrMessage[indexPath.row]["created_time"] ?? "")
        cell.textLabel?.text = str
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func getPosts() {
        var request: GraphRequest?
        let accessToken = AccessToken.current?.tokenString
        let params = ["access_token" : accessToken ?? ""]
        request = GraphRequest.init(graphPath: "/\(self.id)/posts/", parameters: params, httpMethod: HTTPMethod(rawValue: "GET"))
        request?.start(completionHandler: { (_, result, _) in
            let fbDetails = result as! NSDictionary
                self.arrMessage = fbDetails.object(forKey: "data") as! [[String : String]]
            self.fbTableview.reloadData()
            self.fbTableview.isHidden = false
        })
    }
    func getPageFeed() {
         var request: GraphRequest?
        let params = ["access_token" : "EAAD2sQZAqKqkBALIPZCsUQFi6UrMdq1aBVta3ZCeaag3fa0xgdOhWqxaZBVmwNudxHjsTiyRhf2ycVoo3YpdDryZCeuQZACym8ADXbZBaHUnNpZBReBiYWfIKGsuXZBdo05EksskPBW2AusBQ8FE6jHesnNBAUz8cBeofZBJpcdRikEgZDZD" ]
        request = GraphRequest.init(graphPath: "/\(105279807987793)/feed/", parameters: params, httpMethod: HTTPMethod(rawValue: "GET"))
                request?.start(completionHandler: { (connection, result, err) in
                let fbDetails = result as! NSDictionary
                    self.arrMessage = fbDetails.object(forKey: "data") as! [[String : String]]
                    self.fbTableview.reloadData()
                    self.fbTableview.isHidden = false
                })
     }

    @IBAction func loginClicked(_ sender: Any) {
        LoginManager().logOut()
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("failed to start graph request: \(String(describing: error))")
                return
            }
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, relationship_status,email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as! NSDictionary
                    print(fbDetails)
                    self.id = fbDetails.object(forKey: "id") as! String
                    self.getPosts()
                    LoginManager().logOut()
                    GraphRequest(graphPath: "/\(self.id)?fields=business_discovery.username(madhava36){followers_count,media_count}", httpMethod: HTTPMethod.get).start { (connection, result, error) in
                           }
                }
            })

        }
    }
}


//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//

import UIKit
import EmitterKit

enum LeftMenu: Int {
    case Main = 0
    case Artists
    case Swift
    case Go
    case NonMenu
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {

    @IBOutlet weak var tableView: UITableView!
    // below is the order and naming
    var menus = ["Home", "Dashboard", "Artists", "Go", "NonMenu"]
    var mainViewController: UIViewController!
    var artistsViewController: UIViewController!
    var swiftViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewControllerWithIdentifier("SwiftViewController") as! SwiftViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)

        let artistsViewController = storyboard.instantiateViewControllerWithIdentifier("ArtistsViewController") as! ArtistsViewController
        self.artistsViewController = UINavigationController(rootViewController: artistsViewController)

        let goViewController = storyboard.instantiateViewControllerWithIdentifier("GoViewController") as! GoViewController
        self.goViewController = UINavigationController(rootViewController: goViewController)

        let nonMenuController = storyboard.instantiateViewControllerWithIdentifier("NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)

        self.tableView.registerCellClass(BaseTableViewCell.self)

        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    var listener: Listener!

    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Swift:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .Artists:
            self.slideMenuController()?.changeMainViewController(self.artistsViewController, close: true)
            
            // need to keep reference here
            EventEmitter.shared.listener = EventEmitter.shared.menu.on { msg in print("\(msg)")}
            
            EventEmitter.shared.menu.emit("hello")
            EventEmitter.shared.menu.emit("hello2")
            self.slideMenuController()?.closeLeft()
        case .Go:
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
        case .NonMenu:
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Artists, .Swift, .Go, .NonMenu:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension LeftViewController : UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Artists, .Swift, .Go, .NonMenu:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                cell.textLabel!.font = UIFont(name:"Avenir", size:22)
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}

extension LeftViewController: UIScrollViewDelegate {


    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {

        }
    }
}

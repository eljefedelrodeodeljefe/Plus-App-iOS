//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//

import UIKit
import EmitterKit

enum LeftMenu: Int {
    case Main = 0
    case Dashboard
    case Artists
    case Settings
//    case NonMenu
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {

    @IBOutlet weak var tableView: UITableView!
    // below is the order and naming
    var menus = ["Home", "Dashboard", "Artists", "Settings", "NonMenu"]
    var mainViewController: UIViewController!
    var artistsViewController: UIViewController!
    var dashboardViewController: UIViewController!
    var settingsViewController: UIViewController!
//    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardViewController = storyboard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
        self.dashboardViewController = UINavigationController(rootViewController: dashboardViewController)

        let artistsViewController = storyboard.instantiateViewControllerWithIdentifier("ArtistsViewController") as! ArtistsViewController
        self.artistsViewController = UINavigationController(rootViewController: artistsViewController)

        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController)

//        let nonMenuController = storyboard.instantiateViewControllerWithIdentifier("NonMenuController") as! NonMenuController
//        nonMenuController.delegate = self
//        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)

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
            EventEmitter.shared.menu.emit("home")
        case .Dashboard:
            EventEmitter.shared.menu.emit("dashboard")
            self.slideMenuController()?.closeLeft()
        case .Artists:
            EventEmitter.shared.menu.emit("artists")
            self.slideMenuController()?.closeLeft()
        case .Settings:
            EventEmitter.shared.menu.emit("settings")
            self.slideMenuController()?.closeLeft()
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Dashboard, .Artists, .Settings/*, .NonMenu*/:
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
            case .Main, .Dashboard, .Artists, .Settings/*, .NonMenu*/:
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

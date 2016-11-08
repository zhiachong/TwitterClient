//
//  MenuViewController.swift
//  Twitter
//
//  Created by Zhia Chong on 11/6/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit
import SwiftIconFont
import SlideMenuControllerSwift

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var twitterBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var envelopeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var plusBarButtonItem: UIBarButtonItem!
    
    @IBAction func settingsTapped(_ sender: Any) {
        print ("seetings tapped")
    }
    
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController:
    UIViewController!
    private var homeNavigationController:
    UIViewController!
    private var viewControllers: [UIViewController]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Menu is loaded")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        twitterBarButtonItem.icon(from: .FontAwesome, code: "cog", ofSize: 20)
        envelopeBarButtonItem.icon(from: .FontAwesome, code: "envelope", ofSize: 20)
        plusBarButtonItem.icon(from: .FontAwesome, code: "plus", ofSize: 20)
        
        let profileVc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVc.user = User.currentUser
        profileNavigationController = UINavigationController(rootViewController: profileVc)
        
//        profileNavigationController = storyboard?.instantiateViewController(withIdentifier: "ProfileNavigationController")
        let homeVc = storyboard?.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        homeNavigationController = UINavigationController(rootViewController: homeVc)
//        homeNavigationController = storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController")
        
        let mentionsVc = storyboard?.instantiateViewController(withIdentifier: "MentionsViewController") as! MentionsViewController
        mentionsNavigationController = UINavigationController(rootViewController: mentionsVc)
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(homeNavigationController)
        viewControllers.append(mentionsNavigationController)
    }
    
    func loadSettings() {
        print("Loading settings")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        cell.iconLabelText = getViewControllerLabel(indexPath: indexPath) as String!
        cell.descriptionLabelText = getViewControllerName(indexPath: indexPath) as String!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController as! SlideMenuController
        viewController.changeMainViewController(viewControllers[indexPath.row], close: true)
    }
    
    func getViewControllerLabel(indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0:
            return "user"
        case 1:
            return "home"
        case 2:
            return "retweet"
        default:
            return "twitter"
        }
    }
    
    func getViewControllerName(indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0:
            return "Profile"
        case 1:
            return "Home"
        case 2:
            return "Mentions"
        default:
            return "Mentions"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

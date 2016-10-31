//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Zhia Chong on 10/31/16.
//  Copyright © 2016 Zhia Chong. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    @objc optional func composeViewController(composeViewController: ComposeViewController, didSendText text: String)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    weak var delegate : ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0, green: 0.67, blue: 0.929, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSendTapped(_ sender: AnyObject) {
        if (isValidTweet(tweetTextView.text)) {
            print ("Delegating it out! \(tweetTextView.text)" )
            delegate?.composeViewController!(composeViewController: self, didSendText: tweetTextView.text)
            dismiss(animated: true, completion: nil)
        } else {
            self.throwAlert(alertMessage: "The tweet is not valid!")
        }
    }
    
    func throwAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // do something to handle the action
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func onCancelTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func isValidTweet(_ str: String) -> Bool {
        // Tweets are only 140 characters long!
        return str.characters.count > 0 && str.characters.count <= 140
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

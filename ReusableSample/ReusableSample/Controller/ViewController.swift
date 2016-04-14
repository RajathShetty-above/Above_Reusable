//
//  ViewController.swift
//  UnitTestSample
//
//  Created by Rajath Shetty on 25/02/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    //model items
    var searchResponse: SearchResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func searchNews(sender: UIButton) {
        activityIndicator.startAnimating()
        let searchText = self.textField.text
        if let searchText = searchText where RequestManager.sharedInstance.validateSearchString(searchText) {
            RequestManager.sharedInstance.getNewsRelatedToQueryText(searchText, completionHandler: { [weak self] (response, error) -> Void in
                self?.activityIndicator.stopAnimating()
                if let error = error {
                    print(error)
                } else {
                    self?.searchResponse = response
                    self?.tableView.reloadData()
                    
                }
            })
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.responseEntries?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TableCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableCell
        
        if let news = searchResponse?.responseEntries?[indexPath.row] {
            cell.configureCellWithNews(news)
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        ABAlertController.showAlertWithMessage("Table tapped", title: "error")
        
//        ABAlertController.showAlertWithMessage("Message", title: "Error", actionButtonTitle: "Ok", cancelButtonTitle: "Cancel", actionButtonHandler: { (controller, action) -> Void in
//            
//            }) { (controller: UIAlertController, action: UIAlertAction) -> Void in
//                controller.dismissViewControllerAnimated(true, completion: nil)
//        }
//        let controller = ABAlertController()
//        self.presentViewController(controller, animated: false, completion: nil)
        
//        UIAlertController.showAlertWithMessage("Message", title: "Error", actionButtonTitle: "Ok", destructiveButtonTitle: "Cancel", actionButtonHandler: nil, destructiveButtonHandler: nil)

    }
}



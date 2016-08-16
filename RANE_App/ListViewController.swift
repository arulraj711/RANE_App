//
//  ListViewController.swift
//  RANE_App
//
//  Created by cape start on 11/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // self.navigationItem.setHidesBackButton(true, animated:true);
        let imageName = "nav_logo"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.navigationItem.titleView = imageView
        
        self.navigationItem.hidesBackButton = true
        
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                       style: UIBarButtonItemStyle.Plain ,
                                       target: self, action: Selector("OnMenuClicked"))
        
        self.navigationItem.leftBarButtonItem = menu_button_
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView!
    {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 52))
        //if (section == integerRepresentingYourSectionOfInterest) {
            headerView.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: CGRectMake(20, 0, tableView.bounds.size.width-20, 52))
        if(section == 0) {
            label.text = "COMPANY NEWS"
        } else if(section == 1) {
            label.text = "INDUSTRY NEWS"
        }
        
        label.font = UIFont(name:"OpenSans-Semibold", size: 14)
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        return headerView
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    
    func OnMenuClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

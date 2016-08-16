//
//  MenuViewController.swift
//  RANE_App
//
//  Created by cape start on 10/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var menuTableView: UITableView!
    var items: [String] = ["Daily Digest", "RiskBook", "Company News","Industry News","Legal & Market Intelligence","Regulatory","Daily Digest Archive","Saved For Later","Marked Important"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
//        if let url = NSURL(string: "https://s3.amazonaws.com/ranecloudwp/blog/wp-content/uploads/2016/06/09191314/rane_horz-1-2.png") {
//            if let data = NSData(contentsOfURL: url) {
//                let logo = UIImage(data: data)
//                let imageView = UIImageView(image:logo)
//                imageView.contentMode = UIViewContentMode.ScaleAspectFit;
//                self.navigationItem.titleView = imageView
//            }
//        }
        
        
        let imageName = "nav_logo"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.navigationItem.titleView = imageView
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.init(colorLiteralRed: 199/255, green: 199/255, blue: 205/255, alpha: 1).CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomMenuCell
        
        
//        if let url = NSURL(string: "http://res.cloudinary.com/capestart/image/upload/v1470824285/octicons_4-3-0_star_360_0_000000_none_dprawn.png") {
//            if let data = NSData(contentsOfURL: url) {
//                cell.menuIconImage.image = UIImage(data: data)
//            }
//        }
        
        
        let menuImage = UIImage(named: items[indexPath.row])
        cell.menuIconImage.image = menuImage
//        let imageView = UIImageView(image: image!)
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        
        
        cell.menuName.text = items[indexPath.row]
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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

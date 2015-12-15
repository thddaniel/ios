//
//  ObjectsTableViewController.swift
//  Memory
//
//  Created by tanghao on 14/12/2015.
//  Copyright © 2015 tanghao. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import LocalAuthentication //touch id

class ObjectsTableViewController: PFQueryTableViewController
{
    
    var hasIdentified = false
    
    //override func objectsDidLoad(error: NSError?) {    //this function will stuck
         //self.TouchIDCall()
    //}
    
    /*Override to construct your own custom PFQuery to get the objects.*/
    override func queryForTable() -> PFQuery
    {
        let query = PFQuery(className: "object")
        query.cachePolicy = .NetworkElseCache //CacheThenNetwork,CacheElseNetwork
        query.orderByAscending("createdAt")
        
        if hasIdentified == false{
            self.TouchIDCall() //everytimes load PFtable, execute this..
            hasIdentified = true
        }
        
        return query
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BaseTableViewCell
        
        let imageFile = object?.objectForKey("image") as? PFFile
        cell.cellImageView?.image = UIImage(named: "launchImage")
        cell.cellImageView?.file = imageFile
        cell.cellImageView.loadInBackground()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row + 1 > self.objects?.count
        {
            return 44
        }
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row + 1 > self.objects?.count
        {
            self.loadNextPage()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else
        {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail"
        {
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailVC = segue.destinationViewController as! PreviewViewController
            let object = self.objectAtIndexPath(indexPath)
            detailVC.imageFile = object?.objectForKey("image") as! PFFile
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    
    
    
    func TouchIDCall(){
        let authContext : LAContext = LAContext()
        var error : NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Personal Information", reply: {
                (success: Bool , policyerror : NSError? ) in
                if success{
                    NSLog("success log in")
                }else{
                    
                    NSLog("failed log in")
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                    
                    /* switch policyerror!.code
                    {
                    case LAError.SystemCancel.rawValue:
                    exit(0)
                    case LAError.UserCancel.rawValue:
                    exit(0)
                    case LAError.UserFallback.rawValue:
                    NSOperationQueue.mainQueue().addOperationWithBlock({() -> void in self.showPasswordAlert()
                    
                    })
                    default:
                    NSLog("failed log in")
                    
                    }*/
                    
                }
            })
        }else{
            //device without touch id
        }
    }
    
    func showPasswordAlert()
    {
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "xuziqing"
                {
                    print("Authentication successful! :) ")
                }
                else
                {
                    self.showPasswordAlert()
                }
            }
        }
        alertController.addAction(defaultAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
        }
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
}

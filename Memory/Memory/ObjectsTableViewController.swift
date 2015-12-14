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

class ObjectsTableViewController: PFQueryTableViewController
{
    override func queryForTable() -> PFQuery
    {
        let query = PFQuery(className: "object")
        query.cachePolicy = .CacheElseNetwork
        query.orderByDescending("createdAt")
        return query
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BaseTableViewCell
        
        let imageFile = object?.objectForKey("image") as? PFFile
        //cell.cellImageView?.image = UIImage(named: "placeholder")
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
    
}

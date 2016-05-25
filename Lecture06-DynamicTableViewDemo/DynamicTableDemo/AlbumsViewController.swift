//
//  AlbumsViewController.swift
//  DynamicTableDemo
//
//  Created by Jonathan Engelsma on 5/24/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit
import AssetsLibrary

class AlbumsViewController: UITableViewController {
    
    var albums : [ALAssetsGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.loadAlbums()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func refreshScreen(sender: UIRefreshControl) {
        
        self.loadAlbums()
        sender.endRefreshing()
    }
    
    func loadAlbums()
    {
        self.albums.removeAll()
        let lib = MyAssetsLibrary.defaultInstance()
        lib.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupAll),
                                     usingBlock: { (group: ALAssetsGroup?, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                                        if group != nil {
                                            self.albums.append(group!)
                                        } else {
                                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                                self.tableView.reloadData()
                                            }
                                        }
        }) {(error: NSError!) -> Void in
            print("oops error!")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.albums.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MyAlbumTableViewCell
            let group : ALAssetsGroup = self.albums[indexPath.row]
        
            cell.setFromAlbumGroup(group)
//        cell.textLabel!.text = group.valueForProperty(ALAssetsGroupPropertyName) as? String
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

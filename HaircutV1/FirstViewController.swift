//
//  FirstViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 1/29/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: Extra Variables
    var userUUID = ""
    var arrayHaircuts = [PFObject]()
    
    @IBOutlet var table: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(arrayHaircuts.count)
        return arrayHaircuts.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = arrayHaircuts[indexPath.row]["userUUID"] as! String
        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // CoreData code
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext // we can use context to access CoreData
        
        // core data retrieval
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecords")
        request.returnsObjectsAsFaults = false
        // by default, when request is run, instead of returning actual data, it'll return faults. we usually want this set to false.
        
        do { // this person is an existing user... let's just retrieve the stored userUUID.
            
            let results = try context.fetch(request)
            if results.count > 0 {
                // we already have a UserRecord
                for result in results as! [NSManagedObject] {
                    
                    print(result)
                    if let userID = result.value(forKey: "userID") as? String {
                        userUUID = userID
                    }
                }
                
            } else { // this person is a brand new user!
                // let's create a UserRecord
                print("No results, so this is a new user")
                
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserRecords", into: context)
                
                // generate random UUID
                let uuid = UUID().uuidString
                newUser.setValue(uuid, forKey: "userID")
                userUUID = uuid
                
                // generate current date
                let date = NSDate()
                newUser.setValue(date, forKey: "dateCreated")
                
                // save new userRecord
                do {
                    print("Saved")
                    try context.save()
                    
                } catch {
                    print("There was an error")
                }
                
            }
            
        } catch {
            print("Couldn't fetch results")
        }
        
        // retrieve user's Haircuts from Parse Server using userUUID.
        let query = PFQuery(className:"Haircut")
        query.whereKey("userUUID", equalTo: userUUID)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                // print error
                print("Error: \(error!.localizedDescription)")
            } else {
                // success
                print("Successfully retrieved \(objects!.count) haircuts!")
                
                if let objects = objects {
                    self.loadHaircutViews(objects)
                
                } else {}
            }
            
        } // end findObjectsInBackground
        
    } // end viewDidLoad

    func loadHaircutViews(_ haircuts: [PFObject]) {
        
        for haircut in haircuts {
          //  print(haircut)
            arrayHaircuts.append(haircut as! PFObject)
        }
        table.reloadData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


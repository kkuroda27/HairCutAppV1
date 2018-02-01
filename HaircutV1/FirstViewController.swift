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
import os.log

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: Extra Variables
    var userUUID = ""
    var arrayHaircuts = [PFObject]()
    
    @IBOutlet var table: UITableView!
    
    
    // MARK: Helper Functions

    func loadHaircutViews(_ haircuts: [PFObject]) {
        
        for haircut in haircuts {
            arrayHaircuts.append(haircut)
        }
        table.reloadData()
        
    }

    // MARK: Table View Functions

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHaircuts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyHaircutsFeedTableViewCell
        cell.haircutTitle.text = arrayHaircuts[indexPath.row]["title"] as? String
        cell.haircutDescription.text = arrayHaircuts[indexPath.row]["description"] as? String
        
        if arrayHaircuts[indexPath.row]["frontImage"] != nil {
            let tempImage = arrayHaircuts[indexPath.row]["frontImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        cell.haircutImage.image = imageToDisplay
                        
                    }
                    
                }
                
            }
        } else {
            print("Image on row \(indexPath.row) has no image!")
        }
        
        //cell.haircutImage.image = UIImage(named: "museum.jpg")
        
        
        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem": // if the user is adding a new haircut, you don't need to change the appearnce of the screen.
            os_log("Adding a new haircut.", log: OSLog.default, type: .debug)
        
        case "showDetail":
            guard let mealDetailViewController = segue.destination as? SecondViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MyHaircutsFeedTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = table.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = arrayHaircuts[indexPath.row]
            mealDetailViewController.haircut = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        
        }

    }
    
    
    
    // MARK: viewDidLoad()

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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


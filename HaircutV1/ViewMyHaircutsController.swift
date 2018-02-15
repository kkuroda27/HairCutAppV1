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

class ViewMyHaircutsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: Extra Variables
    var userUUID = ""
    var arrayHaircuts = [PFObject]()
    
    @IBOutlet var table: UITableView!
    
    // MARK: User Functions

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // spinner + disable activity code.
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
        if editingStyle == UITableViewCellEditingStyle.delete {
            if let haircutObjectId = arrayHaircuts[indexPath.row].objectId {
                print(haircutObjectId)
                arrayHaircuts[indexPath.row].deleteInBackground(block: { (success, error) in
                    
                    if error != nil {
                        print("error deleting the object")
                        print(error!.localizedDescription)
                    } else {
                        print("deleting successful!")
                        self.arrayHaircuts.remove(at: indexPath.row)
                        self.table.reloadData()
                    }
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()

                })
            } else {
                print("Something's wrong")
            }
        }
        
    }
    
    // MARK: Helper Functions

    func loadHaircutViews(_ haircuts: [PFObject]) {
        print("running loadHaircutViews")
        self.arrayHaircuts.removeAll()
        for haircut in haircuts {
            arrayHaircuts.append(haircut)
        }
        table.reloadData()
        print("table reloaded!")
    }

    func updateTable() {
        
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
                } else {
                    print("Error occurred in updateTable()")
                }
            }
            
        } // end findObjectsInBackground

    }
    
    // MARK: Table View Functions

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHaircuts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyHaircutsFeedTableViewCell
        cell.haircutTitle.text = arrayHaircuts[indexPath.row]["title"] as? String
        if cell.haircutTitle.text == "" {
            print("empty title")
            cell.haircutTitle.text = "No Title"
        } else {
            //print("not empty title, leave it be.")
        }
        
        // convert from String -> date
        let stringDate = arrayHaircuts[indexPath.row]["dateCreated"]
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        guard let date = dateFormatter1.date(from: stringDate as! String) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        // convert date -> localized date for viewing
        let dateLocalized = DateFormatter.localizedString(
            from: date,
            dateStyle: .short,
            timeStyle: .short)
        
        cell.haircutDescription.text = "\(dateLocalized)"

        
        if arrayHaircuts[indexPath.row]["frontImage"] != nil {
            let tempImage = arrayHaircuts[indexPath.row]["frontImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        cell.haircutImage.image = imageToDisplay

                        // this code deletes the whitespace on each imageView so there's not a huge gap on the left and right side of the imageView.
                        cell.haircutImage.widthAnchor.constraint(equalTo: cell.haircutImage.heightAnchor, multiplier: (cell.haircutImage.image?.size.width)! / (cell.haircutImage.image?.size.height)!).isActive = true
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
        var numOfSections: Int = 0
        if arrayHaircuts.count > 0 {
            print("# of items is NOT empty")
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        
        } else {
            print("# of items IS empty so display 'no data available' label")
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "You have no haircuts!"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addItem": // if the user is adding a new haircut, you don't need to change the appearnce of the screen.
            os_log("Adding a new haircut.", log: OSLog.default, type: .debug)
        
        case "showDetail":
            guard let haircutDetailViewController = segue.destination as? CreateEditHaircutController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHaircutCell = sender as? MyHaircutsFeedTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = table.indexPath(for: selectedHaircutCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHaircut = arrayHaircuts[indexPath.row]
            haircutDetailViewController.haircut = selectedHaircut
            
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
        
        updateTable()
        
    } // end viewDidLoad

    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        updateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


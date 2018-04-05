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
import SystemConfiguration

class ViewMyHaircutsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: - Outlets + Variables
    var userUUID = ""
    var arrayHaircuts = [PFObject]()
    @IBOutlet var table: UITableView!
    let btnRefresh = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))

    // MARK: - Table View Functions
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("FUNCTION START: numberOfRowsInSection")
        return arrayHaircuts.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("FUNCTION START: forRowAt")

        // enable spinner + disable activity.
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            if arrayHaircuts[indexPath.row].objectId != nil {
                
                let alert = UIAlertController(title: "Are you sure you want to delete this Haircut?", message: "It won't come back once you do!", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Delete!", style: .default, handler: { action in
                    print("DELETE!")
                    activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()

                    self.arrayHaircuts[indexPath.row].deleteInBackground(block: { (success, error) in
                        
                        if error != nil {
                            print("ERROR: \(error!.localizedDescription)")
                        } else {
                            print("STATUS: Table Row Deleting successful!")
                            self.arrayHaircuts.remove(at: indexPath.row)
                            self.table.reloadData()
                        }
                        
                        // disable spinner + enable activity.
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()

                    })

                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    print("Cancel!")
                }))

                //  self.dismiss(animated: true, completion: nil)
                
                self.present(alert, animated: true, completion: nil)

            } else {
                print("Something's wrong")
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("FUNCTION START: cellForRowAt")

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyHaircutsFeedTableViewCell
        cell.haircutTitle.text = arrayHaircuts[indexPath.row]["haircutName"] as? String
        if cell.haircutTitle.text == "" {
            //print("STATUS: Title IS empty")
            cell.haircutTitle.text = "No Title"
        } else {
            //print("STATUS: Title is NOT empty, leave it be.")
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
        
        cell.haircutDate.text = "\(dateLocalized)"
        
        if let textDateSet = arrayHaircuts[indexPath.row]["dateSet"] as? String {
            cell.haircutDate.text = textDateSet
        } else {
            
        }

        if let textSalonCity = arrayHaircuts[indexPath.row]["salonCity"] as? String {
            cell.haircutSalonTitle.text = textSalonCity
        } else {
            
        }
        
        if arrayHaircuts[indexPath.row]["frontImage"] != nil {
            let tempImage = arrayHaircuts[indexPath.row]["frontImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        cell.haircutImage.image = imageToDisplay
                        // this code deletes the whitespace on each imageView so there's not a huge gap on the left and right side of the imageView.
                        //cell.haircutImage.widthAnchor.constraint(equalTo: cell.haircutImage.heightAnchor, multiplier: (cell.haircutImage.image?.size.width)! / (cell.haircutImage.image?.size.height)!).isActive = true
                    }
                    
                }
                
            }
        } else {
            //print("STATUS: Image on row \(indexPath.row) has no image!")
        }
        
        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        print("FUNCTION START: numberOfSections")
        var numOfSections: Int = 0
        
        // check to see if we have any items to load. If not, display "You have no haircuts!" label.
        if arrayHaircuts.count > 0 {
            print("STATUS: We have at least 1 item in the Table")
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        
        } else {
            print("STATUS: We have 0 items in the Table")
            print("STATUS: Displaying 'no data available' label")

            // If tableData is NOT empty, then we're definitely connected to Internet so we follow if statement above.
            // If tableData IS empty, it's because user has no haircuts OR user is not connected to internet. Let's check now.
            
            // Code for checking if we have valid internet connection.
            print("STATUS: Check if there's a valid internet connection")
            if Reachability.isConnectedToNetwork(){
                print("STATUS: Internet Connection Available!")
                print("STATUS: Displaying 'no data available' label")

                // Create modified text
                let modifiedText = NSMutableAttributedString.init(string: "No haircuts here, yet! \n \n Create one using the + button above to the right!")
                
                // set the custom font and color for a range in string
                modifiedText.setAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25),
                                          NSAttributedStringKey.foregroundColor: UIColor.black],
                                         range: NSMakeRange(0, 22))
                
                // if you want, you can add more attributes for different ranges calling .setAttributes many times

                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.attributedText = modifiedText     // set the attributed string to the UILabel object
                noDataLabel.numberOfLines = 0
                noDataLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none

                
            }else{
                print("STATUS: Internet Connection not Available!")
                // No Internet, so lets show refresh button and ask user to connect to internet.
                // perhaps we should disable "Create" button in this case?
                
                // add label above button
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No Internet! Please connect and try again!" // "You have no haircuts, OR you may be offline!"
                noDataLabel.numberOfLines = 0
                noDataLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                
                // Modify existing "refresh" button
                btnRefresh.backgroundColor = UIColor.blue
                btnRefresh.setTitle("Refresh!", for: .normal)
                btnRefresh.addTarget(self, action: #selector(clickRefresh), for: .touchUpInside)
                self.view.addSubview(btnRefresh)
                
            }
        }
        return numOfSections

    }
    
    // MARK: -  User Functions

    @objc func clickRefresh(sender: UIButton!) {
        print("FUNCTION START: clickRefresh")
        sender.isHidden = true
        updateTable()

    }

    // MARK: -  Table Helper Functions
    func loadHaircutViews(_ haircuts: [PFObject]) {
        print("FUNCTION START: loadHaircutViews")
        self.arrayHaircuts.removeAll()
        for haircut in haircuts {
            arrayHaircuts.append(haircut)
        }
        table.reloadData()
        print("STATUS: Table reloaded!")
    }
    
    func updateTable() {
        print("FUNCTION START: updateTable")
        
        // retrieve user's Haircuts from Parse Server using userUUID.
        let query = PFQuery(className:"Haircut")
        query.whereKey("userUUID", equalTo: userUUID)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                // print error
                print("ERROR: \(error!.localizedDescription)")
                self.btnRefresh.isHidden = false
            } else {
                // success
                print("STATUS: Successfully retrieved \(objects!.count) haircuts!")
                self.btnRefresh.isHidden = true
                if let objects = objects {
                    self.loadHaircutViews(objects)
                } else {
                    print("ERROR: Error occurred in updateTable()")
                }
                
            }
            
        } // end findObjectsInBackground
        
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")

        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "addItem": // if the user is adding a new haircut, you don't need to change the appearnce of the screen.
            print("STATUS: Segue case = addItem")
            guard let destinationNavigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            let newHaircutVC = destinationNavigationController.topViewController as? CreateHaircutPg1ViewController
            newHaircutVC?.modelController = ModelController()
            newHaircutVC?.previousVC = "ViewMyHaircutsController"

        
        case "showDetail":
            print("STATUS: Segue case = showDetail")

            guard let destinationNavigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let viewOptionsVC = destinationNavigationController.topViewController as? ViewOptionsViewController

            guard let selectedHaircutCell = sender as? MyHaircutsFeedTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = table.indexPath(for: selectedHaircutCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHaircut = arrayHaircuts[indexPath.row]
            viewOptionsVC?.modelController = ModelController()
            viewOptionsVC?.modelController.haircut = selectedHaircut
            
        case "showHelp":
            //os_log("Showing help screen", log: OSLog.default, type: .debug)
            print("STATUS: Segue case = showHelp")

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }

    }
    

    
    // MARK: - viewDidAppear / viewDidLoad Functions

    override func viewDidAppear(_ animated: Bool) {
        print("---NEW SCREEN--- FUNCTION START: viewDidAppear - ViewMyHaircutsController.swift")
        updateTable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - ViewMyHaircutsController.swift")

        // CoreData code
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext // we can use context to access CoreData
        
        // core data retrieval
        print("STATUS: Fetching CoreData results for entityName: UserRecords")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecords")
        request.returnsObjectsAsFaults = false
        // by default, when request is run, instead of returning actual data, it'll return faults. we usually want this set to false.
        
        // Let's do-try catch a context.fetch to see if we get any UserRecord results from CoreData
        do {
            
            let results = try context.fetch(request)
            // now let's see if this is an existing user or not.
            if results.count > 0 {
                print("STATUS: Existing User, since we have a UserRecord in CoreData")
                // we already have a UserRecord, which means this IS an existing user. Let's just retrieve the stored userUUID.
                for result in results as! [NSManagedObject] {
                    
                    if let userID = result.value(forKey: "userID") as? String {
                        userUUID = userID
                    }
                }
                
            } else { // this person is a brand new user!
                print("STATUS: New User, since we have no entries for UserRecord in CoreData")

                // Instead, let's create a new UserRecord Entity for this new user.
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserRecords", into: context)
                
                print("STATUS: Generating new user UUID and saving to CoreData + Global Variable for saving in PFObject later.")
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
                    print("ERROR: There was an error trying to save to CoreData")
                }
                
            }
            
        } catch {
            print("ERROR: Couldn't fetch results from CoreData")
        }
        
        updateTable()
        
    } // end viewDidLoad

    // MARK: - Helper Functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("FUNCTION START: didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }


} // end View Controller Class


// Code to detect if internet is working. Got code from https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        print("FUNCTION START: isConnectedToNetwork")

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}


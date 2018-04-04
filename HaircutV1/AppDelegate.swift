//
//  AppDelegate.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 1/29/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import CoreData
import Parse
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Nav Bar Customizations
        // Nav Bar Items Color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Nav Bar Background Color
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: "#35B18E")

        // Nav Bar Text Color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        
        // custom font setup for Nav Bar Item and Nav Bar
        var barButtonItemTextAttributes: [NSAttributedStringKey:Any]
        var navBarTextAttributes: [NSAttributedStringKey:Any]

        let fontColor = UIColor.white
        let barItemCustomFont = UIFont(name: "Avenir-Medium", size: 18)  //note we're not forcing anything here
        let navBarCustomFont = UIFont(name: "Avenir-Heavy", size: 18)  //note we're not forcing anything here
        
        //can we use our custom font 🤔
        if let customFont1 = barItemCustomFont, let customFont2 = navBarCustomFont {
            //hooray we can use our font 💪
            barButtonItemTextAttributes = [NSAttributedStringKey.foregroundColor: fontColor, NSAttributedStringKey.font: customFont1] as [NSAttributedStringKey : Any]
            navBarTextAttributes = [NSAttributedStringKey.foregroundColor: fontColor, NSAttributedStringKey.font: customFont2] as [NSAttributedStringKey : Any]

        } else {
            //👎 not found -> omit setting font name and proceed with system font
            barButtonItemTextAttributes = [NSAttributedStringKey.foregroundColor: fontColor]
            navBarTextAttributes = [NSAttributedStringKey.foregroundColor: fontColor]

        }
        
        //finally set nav bar and bar item text attributes.
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonItemTextAttributes, for: .normal)
        UINavigationBar.appearance().titleTextAttributes = navBarTextAttributes

        // Set status bar to white, not black
        UIApplication.shared.statusBarStyle = .lightContent


        // Enable keyboardmanager from cocoapods.
        IQKeyboardManager.sharedManager().enable = true

        // parse stuff
        let configuration = ParseClientConfiguration {
            $0.applicationId = "214ad04b2f476d6e1b9d132b477469c85c9910b3"
            $0.clientKey = "9a2d29a80b4b97abf44d98ec4fb848261752bf47"
            $0.server = "http://ec2-54-196-178-16.compute-1.amazonaws.com/parse"
        }
        Parse.initialize(with: configuration)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HaircutV1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

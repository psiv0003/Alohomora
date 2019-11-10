//
//  AppDelegate.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 30/10/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var notificationCenter: UNUserNotificationCenter!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let db = Firestore.firestore()
        self.notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        //user notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        // request permission
        notificationCenter.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let viewController = window?.rootViewController as? HomeViewController {
            viewController.listenForChanges()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if let viewController = window?.rootViewController as? HomeViewController {
            viewController.listenForChanges()
        }
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
        let container = NSPersistentContainer(name: "Alohomora")
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
  
    
    //    func notification(forRegion region: CLRegion){
    //
    //
    //        let content = UNMutableNotificationContent()
    //        content.title = "Melbourne Sights"
    //        content.subtitle = "Sight Alert!"
    //        content.body = "Hey Looks like you just left a historical sight!"
    //        let imageName = "logo"
    //        // guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
    //
    //        //  let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
    //
    //        //  content.attachments = [attachment]
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    //        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
    //
    //        // 4
    //
    //        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    //    }
    
}
//extension AppDelegate: CLLocationManagerDelegate {
//    // called when user Exits a monitored region
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            let content = UNMutableNotificationContent()
//            content.title = "Melbourne Sights"
//            content.subtitle = "Sight Alert!"
//            content.body = "Hey Looks like you just left a historical sight!"
//            let imageName = "logo"
//            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//            let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
//            
//            // 4
//            
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            // self.notification(forRegion: region)
//        }
//    }
//    
//    // called when user Enters a monitored region
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            // Do what you want if this information
//            let content = UNMutableNotificationContent()
//            content.title = "Melbourne Sights"
//            content.subtitle = "Sight Alert!"
//            content.body = "Hey Looks like you have entered a place of interest!"
//            let imageName = "logo"
//            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//            let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
//            
//            // 4
//            
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
//    }
//}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }
}

//
//  AppDelegate.swift
//  Duffy
//
//  Created by Patrick Rills on 6/28/16.
//  Copyright © 2016 Big Blue Fly. All rights reserved.
//

import UIKit
import DuffyFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate //, HealthEventDelegate
{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        let _ = WCSessionService.getInstance()
        HealthKitService.getInstance().initializeBackgroundQueries()
        //HealthKitService.getInstance().setEventDelegate(self)
        //CoreMotionService.getInstance().initializeBackgroundUpdates()
        //NotificationService.maybeAskForNotificationPermission()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        //NSLog("Entered foreground")
        
        if let w = window
        {
            if let root = w.rootViewController as? ViewController
            {
                root.refresh()
            }
        }

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //NSLog("Application will TERMINATE")
        //CoreMotionService.getInstance().stopBackgroundUpdates()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        //NSLog("Background fetch")
        
        HealthKitService.getInstance().cacheTodaysStepsAndUpdateComplication({
            (success: Bool) in
            completionHandler(success ? .newData : .noData)
        })
    }
    
    //func dailyStepsGoalWasReached()
    //{
    //    NotificationService.sendDailyStepsGoalNotification()
    //}
}


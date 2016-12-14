//
//  AppDelegate.swift
//  2020
//
//  Created by Miriam Hendler on 12/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let recArray: [String] = ["can", "tin", "box", "card", "carton", "milk", "glass", "lid", "plastic", "bottle", "container", "steel", "aluminum", "jar", "tub", "tray", "pot", "newspaper", "magazine", "envelope", "mail", "shampoo", "water", "bleach", "cup", "drink", "beverage", "liquid", "tea", "coffee", "bag", "basket", "hamper", "box", "vessel", "pill bottle", "water bottle", "drink", "tissue", "book", "napkin", "towel", "wrap", "paper bag", "metal container", "beer", "jug", "plate", "newspaper", "cardboard", "utensil", "steel", "magazine", "foil", "spoon"]
    let comArray: [String] = ["meal", "cuisine","cream","sauce","vegetable", "pizza box", "leave", "flower", "weed"]
    let lanArray: [String] = ["chip bag", "wrapper", "candy wrapper","ceramic","microwave","battery"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
    }


}


//
//  AppDelegate.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-27.
//

import UIKit

let emojis = ["๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐คฃ", "๐ฅฒ", "โบ๏ธ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ฅฐ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐คช", "๐คจ", "๐ง", "๐ค", "๐", "๐ฅธ", "๐คฉ", "๐ฅณ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "โน๏ธ", "๐ฃ", "๐", "๐ซ", "๐ฉ", "๐ฅบ", "๐ข", "๐ญ", "๐ค", "๐ ", "๐ก", "๐คฌ", "๐คฏ", "๐ณ", "๐ฅต", "๐ฅถ", "๐ฑ", "๐จ", "๐ฐ", "๐ฅ", "๐", "๐ค", "๐ค", "๐คญ", "๐คซ", "๐คฅ", "๐ถ", "๐", "๐", "๐ฌ", "๐", "๐ฏ", "๐ฆ", "๐ง", "๐ฎ", "๐ฒ", "๐ฅฑ", "๐ด", "๐คค", "๐ช", "๐ต", "๐ค", "๐ฅด", "๐คข", "๐คฎ", "๐คง", "๐ท", "๐ค", "๐ค", "๐ค", "๐ค ", "๐", "๐ฟ"]

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


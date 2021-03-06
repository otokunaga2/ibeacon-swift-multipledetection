//
//  AppDelegate.swift
//  iBeaconTemplateSwift
//
//  Created by James Nick Sears on 7/1/14.
//  Copyright (c) 2014 iBeaconModules.us. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
                            
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        let uuidStringList:Array<NSString> = ["DFE7A87B-F80B-1801-BF45-001C4D79EA56","D2D4C07E-F80B-1801-B452-001C4DB02A1F"]
        let beaconIdentifierList:Array<NSString> = ["beaconUSB.jp","pen.cs.kobe-u.jp"]
        //let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        //let beaconUUID2:NSUUID = NSUUID(UUIDString: uuidString)!
         var beaconUUID:Array<NSUUID> = [NSUUID]()
        for(var i=0;i<uuidStringList.count;i++){
            var temp =  NSUUID(UUIDString: uuidStringList[i])
            beaconUUID.append(temp!)
                
        }
        var beaconRegion:Array<CLBeaconRegion> = [CLBeaconRegion]()
        for(var i=0;i<beaconIdentifierList.count; i++){
            var temp = CLBeaconRegion(proximityUUID: beaconUUID[i], identifier: beaconIdentifierList[i])
            beaconRegion.append(temp)
        }
        /*let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)*/
        
        locationManager = CLLocationManager()

        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
            
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        /*locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)*/
        for(var i = 0; i < uuidStringList.count; i++){
            locationManager!.startMonitoringForRegion(beaconRegion[i])
            locationManager!.startRangingBeaconsInRegion(beaconRegion[i])
        }
        locationManager!.startUpdatingLocation()
        locationManager!.requestAlwaysAuthorization() /* バックグラウンドでも動作する */
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: CLLocationManagerDelegate {
	func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
	    	
		/*if(playSound) {
			// classic star trek communicator beep
			//	http://www.trekcore.com/audio/
			//
			// note: convert mp3 and wav formats into caf using:
			//	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
			// http://stackoverflow.com/a/10388263

			notification.soundName = "tos_beep.caf";
		}*/
		
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    /*func sendSimpleRequest(url: String, parameters: [String: AnyObject])-> Void{
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = NSURL(string:"\(url)?\(parameterString)")!
        
        var request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data:NSData!,response: NSURLResponse!, error: NSError!) -> Void in
            switch (data, response, error) {
            case (_, _, .Some(error)):
                // エラー処理
                println(error.localizedDescription)
            case (.Some(data), .Some(response), _):
                if (response as NSHTTPURLResponse).statusCode == 200 {
                    // なんか処理
                    var error: NSError?
                    let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as NSArray
                    println(jsonArray)
                } else {
                    // 処理
                }
            default:
                break
            }
          })
        
        task.resume()
    }*/
    /*func getAsyncRequestToHost(bodyData2:NSString){
        var myURL:NSURL = NSURL(string: "http://192.168.100.177:8080/BeaconStationController/webapi/myresource?")!
       // var myRequest:NSURLRequest = NSURLRequest(URL: myURL)
        var myRequest:NSMutableURLRequest = NSMutableURLRequest(URL: myURL)
        //var bodyData:NSString = "date=2015-04-16%2017:54&uuid=DFE7A87B-F80B-1801-BF45-001C4D79EA56&major=1&minro=2&rssi=-71&stationid=1&proximity=mecha"
        myRequest.HTTPBody = bodyData2.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: NSOperationQueue.mainQueue(),completionHandler:
            { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            switch (data, response, error) {
            case (_, _, .Some(error)):
            // エラー処理
            println(error.localizedDescription)
            case (.Some(data), .Some(response), _):
            if (response as NSHTTPURLResponse).statusCode == 200 {
            // なんか処理
            var error: NSError?
            let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as NSArray
            println(jsonArray)
            } else {
            // 処理
            }
            default:
            break
        }
        
        
        })
        
    }*/
    func getHttp(res:NSURLResponse?,data:NSData?,error:NSError?){
        
        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        // TextViewにセット.
        //myTextView.text = myData
    }
    func getRandom() {
        let url = NSURL(string: "http://192.168.100.177:8080/BeaconStationController/webapi/myresource?date=2015-04-16%2017:54&uuid=DFE7A87B-F80B-1801-BF45-001C4D79EA56&major=1&minro=2&rssi=-71&stationid=1&proximity=mecha")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let request = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            switch (data, response, error) {
            case (_, _, .Some(error)):
                // エラー処理
                println(error.localizedDescription)
            case (.Some(data), .Some(response), _):
                if (response as NSHTTPURLResponse).statusCode == 200 {
                    // なんか処理
                    var error: NSError?
                    let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as NSArray
                    println(jsonArray)
                } else {
                    // 処理
                }
            default:
                break
            }
        })
        
        task.resume()
    }
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            let viewController:ViewController = window!.rootViewController as ViewController
            viewController.beacons = beacons as [CLBeacon]?
            viewController.tableView!.reloadData()
            
            //NSLog("didRangeBeacons");
            var message:String = ""
			
			var playSound = false
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
                //var beacon_parameter:NSString = "?uuid="+"tokunaga&"+"rid=1"+"date="+now
                let dateFormatter = NSDateFormatter()
                var proximityLabel = ""
                //"&major="+(nearestBeacon.major.stringValue)+"&minor=" + (nearestBeacon.minor.stringValue)
                let now = NSDate() // 現在日時の取得
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 日付フォーマットの設定
                dateFormatter.locale = NSLocale(localeIdentifier: "jp_JP") // ロケールの設定
            
            
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                var beacon_uuid:NSString? = nearestBeacon.proximityUUID.UUIDString as NSString
                var proximity_label:NSString
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    proximity_label = "far"
                case CLProximity.Near:
                    proximity_label = "near"
                case CLProximity.Immediate:
                    proximity_label = "immediate"
                case CLProximity.Unknown:
                    return
                }
                var detailLabel: [String: AnyObject] =
                [
                    "uuid": nearestBeacon.proximityUUID.UUIDString as AnyObject!,
                    "rid": 1,
                    "date": dateFormatter.stringFromDate(now) as AnyObject!,
                    "major": nearestBeacon.major.integerValue as AnyObject!,
                    "minor": nearestBeacon.minor.integerValue as AnyObject!,
                    "proximity": proximity_label as NSString,
                    "rssi": nearestBeacon.rssi as AnyObject!,
                    "accuracy": nearestBeacon.accuracy as AnyObject!,
                    "stationid":2
                ]
                let json = JSON(detailLabel)
                let post_to_fluent_to_mongo : NSString = "http://192.168.100.108:8888/beaconmonger"
                let post_rails : NSString = "http://192.168.100.159:3000/currents"
                if (proximity_label == "near" || proximity_label == "immediate"){
                    //postAsync(detailLabel,urlString: post_rails)
                    post(post_rails,params: detailLabel)
                    
                }
                //postAsync(detailLabel,urlString: post_to_fluent_to_mongo)
                
            
                
            } else {
				
				if(lastProximity == CLProximity.Unknown) {
					return;
				}
				
                message = "No beacons are nearby"
				playSound = true
				lastProximity = CLProximity.Unknown
            }
			
			sendLocalNotificationWithMessage(message, playSound: playSound)
    }
    
    
    
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
            sendLocalNotificationWithMessage("You entered the region", playSound: false)
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            sendLocalNotificationWithMessage("You exited the region", playSound: true)
    }
    
    func getCurrentTime()-> String{
            let now = NSDate() // 現在日時の取得
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 日付フォーマットの設定
            dateFormatter.locale = NSLocale(localeIdentifier: "jp_JP") // ロケールの設定
            return dateFormatter.stringFromDate(now)
    }
    func post(url: String, params:[String: AnyObject]){
        var URL: NSURL = NSURL(string: url)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
        //request.HTTPBody = request.HTTPBody.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
           response, data, error in
            var output: NSString!
            if error != nil{
                println("posted")
                //output = NSString(data:data, encoding: NSUTF8StringEncoding)
            }
            //completionHandler(responseString: output, error: error)
        }
        
    }
    func postAsync(params:[String: AnyObject],
        urlString: NSString) {
            //let urlString = "http://133.30.159.3:8888/beacon"
            var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            let myUrl:NSURL = NSURL(string: urlString)!
            // set the method(HTTP-POST)
            request.HTTPMethod = "POST"
            // set the header(s)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
            
            // use NSURLSession
            var task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                    //var result = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    //println(result)
                    //println(error)
            task.resume()
            
    }

}
extension String {
    
    /// Percent escape value to be added to a URL query value as specified in RFC 3986
    ///
    /// This percent-escapes all characters besize the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Return precent escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        var parameterArray = [String]()
        for (key, value) in self {
            let percentEscapedKey = (key as String).stringByAddingPercentEncodingForURLQueryValue()
            let percentEscapedValue = (value as String).stringByAddingPercentEncodingForURLQueryValue()
            parameterArray.append("\(percentEscapedKey!)=\(percentEscapedValue!)")
        }
        
        return join("&", parameterArray)
    }
    
}
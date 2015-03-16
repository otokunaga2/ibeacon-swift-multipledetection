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
        let uuidString = "DFE7A87B-F80B-1801-BF45-001C4D79EA56"
        let beaconIdentifier = "iBeaconModules.us"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        locationManager = CLLocationManager()

        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
            
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
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
    func getAsyncRequestToHost(){
        var myURL:NSURL = NSURL(string: "http://192.168.100.177:8080/BeaconStationController/webapi/myresource?")!
       // var myRequest:NSURLRequest = NSURLRequest(URL: myURL)
        var bodyData = "date=2015-04-16%2017:54&uuid=DFE7A87B-F80B-1801-BF45-001C4D79EA56&major=1&minro=2&rssi=-71&stationid=1&proximity=mecha"
        myRequest.HTTPBody = bodyData.dataUsingEocoding(NSUTF8StringEncoding)
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
        
    }
                /* Your code */
      /*      switch (data, response, error) {
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
    task.resume()
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
            
            NSLog("didRangeBeacons");
            var message:String = ""
			
			var playSound = false
            
            if(beacons.count > 0) {
                println("hi")
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
             /*      var detailLabel: [String: AnyObject] =
              [
                    "uuid":  "",
                    "rid": 1,
                    "date": dateFormatter.stringFromDate(now) as AnyObject!,
                    "major": nearestBeacon.major.integerValue as AnyObject!,
                    "minor": nearestBeacon.minor.integerValue as AnyObject!,
                    "proximity": proximityLabel as AnyObject!,
                    "rssi": nearestBeacon.rssi as AnyObject!,
                    "accuracy": nearestBeacon.accuracy as AnyObject!
                ]*/
            
               /*
              [
                    "uuid": nearestBeacon.proximityUUID.UUIDString as AnyObject!,
                    "rid": 1,
                    "date": dateFormatter.stringFromDate(now) as AnyObject!,
                    "major": nearestBeacon.major.integerValue as AnyObject!,
                    "minor": nearestBeacon.minor.integerValue as AnyObject!,
                    "proximity": proximityLabel as AnyObject!,
                    "rssi": nearestBeacon.rssi as AnyObject!,
                    "accuracy": nearestBeacon.accuracy as AnyObject!
                ]*/
            
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                var beacon_uuid:NSString? = nearestBeacon.proximityUUID.UUIDString as NSString
                
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    println("far")
                case CLProximity.Near:
                    //requestGet(beacon_uuid!,locationId: "ima")
                   getRandom()
                   getAsyncRequestToHost()
                case CLProximity.Immediate:
                    //requestGet(beacon_uuid!,locationId: "ima")
                    println("imeediate")
                    getAsyncRequestToHost()
                     /*HTTPGet("http://www.google.com") {
                        (data: String, error: String?) -> Void in
                        if error != nil {
                            println(error)
                        } else {
                            println(data)
                        }
                     }*/
                case CLProximity.Unknown:
                    return
                }
            
                
            } else {
				
				if(lastProximity == CLProximity.Unknown) {
					return;
				}
				
                message = "No beacons are nearby"
				playSound = true
				lastProximity = CLProximity.Unknown
            }
			
           // NSLog("%@", message)
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
    
    
    /*func sendRequest(url: String, parameters: [String: AnyObject]) -> NSURL {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = NSURL(string:"\(url)?\(parameterString)")!
        
        var request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler:loadedData)
        task.resume()
    }*/
    
    
    func HTTPsendRequest(request: NSMutableURLRequest,
    callback: (String, String?) -> Void) {
    let task = NSURLSession.sharedSession().dataTaskWithRequest(
    request,
    {
    data, response, error in
    if error != nil {
    callback("", error.localizedDescription)
    } else {
    callback(
    NSString(data: data, encoding: NSUTF8StringEncoding)!,
    nil
    )
    }
    })
    
    task.resume()
    }
    func HTTPGet(url: String, callback: (String, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        HTTPsendRequest(request, callback)
    }
    
    /*func HTTPsendRequest(request:NSMutableURLRequest, callback: (String, String?) -> Void){
       let task = NSURLSession.sharedSession().dataTaskWithRequest(
        request,
        {
            data, response, error in
            if error != nil{
                callback("", error.localizedDescription)
            }else{
                callback(NSString(data:data, encoding: NSUTF8StringEncoding)!,
                nil
            )
            }
       })
        task.resume()
    }*/
    /*func requestGet(uuid: NSString, locationId: NSString){
        let net = Net()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 日付フォーマットの設定
        dateFormatter.locale = NSLocale(localeIdentifier: "jp_JP") // ロケールの設定
        let now = NSDate() // 現在日時の取得
        var header = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp"
        var url = "http://192.168.100.177:8080/BeaconStationController/webapi/myresource"
       // http://192.168.100.177:8080/BeaconStationController/webapi/myresource?date=2015-04-16%2017:54&uuid=DFE7A87B-F80B-1801-BF45-001C4D79EA56&major=1&minro=2&rssi=-71&stationid=1&proximity=mecha
        //http://192.168.100.177:8080/BeaconStationController/webapi/myresource?date=2015-04-16%2017:54&uuid=DFE7A87B-F80B-1801-BF45-001C4D79EA56&major=1&minro=2&rssi=-71&stationid=1&proximity=mecha
        //var url = "http://192.168.100.180:4567/beacon/update/"+uuid+"/"+locationId
        let params: [String: AnyObject] = ["stationid": 1, "uuid": "DFE7A87B-F80B-1801-BF45-001C4D79EA56", "proximity": "nenene", "rssi" : "-13", "accuracy": 0.56586,"userid":"tokunaga","major":1,"minor":1,"date":dateFormatter.stringFromDate(now) as AnyObject!]
       // http://192.168.100.177:8080/BeaconStationController/webapi/myresource?date=2015-04-16%2017:54&uuid=DFE7A87B-F80B-1801-BF45-001C4D79EA56&major=1&minro=2&rssi=-71&stationid=1&proximity=mecha
        
/*        let params: [String: AnyObject] = ["date": "2014-04-14 17:54:32", "stationid": 1, "uuid": "DFE7A87B-F80B-1801-BF45-001C4D79EA56", "proximity": "nenene", "rssi" : "-13", "accuracy": 0.56586,"userid":"tokunaga"]*/
        net.GET(absoluteUrl: url, params: params, successHandler: { responseData in
            let result = responseData.json(error: nil)
            NSLog("result \(result)")
            }, failureHandler: { error in
                NSLog("Error")
        })
        
    }*/
    
    
    
    func postAsync(params:[String: AnyObject],
        urlString: NSString) {
            //let urlString = "http://133.30.159.3:8888/beacon"
            var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            
            // set the method(HTTP-POST)
            request.HTTPMethod = "POST"
            // set the header(s)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
            
            // use NSURLSession
            var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
                if (error == nil) {
                    var result = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    println(result)
                } else {
                    println(error)
                }
            })
            task.resume()
            
    }

}


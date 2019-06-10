//
//  EIQNotiName.swift
//  EIQSmart
//
//  Created by 盘国权 on 2018/6/4.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import AVFoundation

public enum PQSystemSupportNotification {
    
    // MARK: - UIApplication
    case didEnterBackground
    case willEnterForeground
    case didFinishLaunching
    case didBecomeActive
    case willResignActive
    case didReceiveMemoryWarning
    case willTerminate
    case significantTimeChange
    case willChangeStatusBarOrientation
    case didChangeStatusBarOrientation
    case willChangeStatusBarFrame
    case didChangeStatusBarFrame
    case backgroundRefreshStatusDidChange
    case protectedDataWillBecomeUnavailable
    case protectedDataDidBecomeAvailable
    case userDidTakeScreenshot
    
    // MARK: - AVAudio
    
    public var name: NSNotification.Name {
        switch self {
        case .didEnterBackground:
            return UIApplication.didEnterBackgroundNotification
        case .willEnterForeground:
            return UIApplication.willEnterForegroundNotification
        case .didFinishLaunching:
            return UIApplication.didFinishLaunchingNotification
        case .didBecomeActive:
            return UIApplication.didBecomeActiveNotification
        case .willResignActive:
            return UIApplication.willResignActiveNotification
        case .didReceiveMemoryWarning:
            return UIApplication.didReceiveMemoryWarningNotification
        case .willTerminate:
            return UIApplication.willTerminateNotification
        case .significantTimeChange:
            return UIApplication.significantTimeChangeNotification
        case .willChangeStatusBarOrientation:
            return UIApplication.willChangeStatusBarFrameNotification
        case .didChangeStatusBarOrientation:
            return UIApplication.didChangeStatusBarFrameNotification
        case .willChangeStatusBarFrame:
            return UIApplication.willChangeStatusBarFrameNotification
        case .didChangeStatusBarFrame:
            return UIApplication.didChangeStatusBarFrameNotification
        case .backgroundRefreshStatusDidChange:
            return UIApplication.backgroundRefreshStatusDidChangeNotification
        case .protectedDataWillBecomeUnavailable:
            return UIApplication.protectedDataDidBecomeAvailableNotification
        case .protectedDataDidBecomeAvailable:
            return UIApplication.protectedDataDidBecomeAvailableNotification
        case .userDidTakeScreenshot:
            return UIApplication.userDidTakeScreenshotNotification
        }
    }
}

public enum PQNotify: String {
    case none = "none"
    
    public var name: Notification.Name {
        return NSNotification.Name(self.rawValue)
    }
    
    public static func listen(_ observer: Any,
                       selector: Selector,
                       type: PQSystemSupportNotification,
                       object: Any? = nil) {
        NotificationCenter.default
            .addObserver(observer,
                         selector: selector,
                         name: type.name,
                         object: object)
    }
    
    public static func listen(_ observer: Any,
                       selector: Selector,
                       name: String,
                       object: Any? = nil) {
        NotificationCenter.default
            .addObserver(observer,
                         selector: selector,
                         name: NSNotification.Name(name),
                         object: object)
    }
    
    public static func listen(type: PQNotify,
                       object: Any? = nil,
                       queue: OperationQueue? = nil,
                       using: @escaping (Notification) -> Void)  {
        NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name(type.rawValue),
                object: object,
                queue: queue,
                using: using)
    }
    
    public static func post(type:
        PQSystemSupportNotification,
                            object: Any? = nil,
                            userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default
            .post(
                name: type.name,
                object: object,
                userInfo: userInfo)
        
    }
    
    public static func post(type: PQNotify,
                     object: Any? = nil,
                     userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default
            .post(
                name: NSNotification.Name(type.rawValue),
                object: object,
                userInfo: userInfo)
    }
    
    public static func remove(observer: Any,
                       type: String,
                       object: Any? = nil){
        NotificationCenter.default
            .removeObserver(
                observer, name: NSNotification.Name(type),
                object: object)
    }
}


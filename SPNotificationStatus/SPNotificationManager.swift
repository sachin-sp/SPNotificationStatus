//
//  SPNotificationManager.swift
//  SPNotificationStatus
//
//  Created by Sachin Pampannavar on 12/25/19.
//  Copyright © 2019 Sachin Pampannavar. All rights reserved.
//

import UIKit

public class SPNotificationManager: NSObject {
    
    public static let shared = SPNotificationManager()
    private override init() {}
        
    public func showNotification(isUserInteractionDisabled: Bool = false, notificationImageName name: String = "notificationImagePlaceholder", notificationTilte title: String = "Title", notificationDetail detail: String = "Detail") {
        
        guard let window = UIApplication.shared.windows.first else { print("SPNotificationManagerError: failed to get: UIApplication.shared.windows.first")
            return
        }
        guard let firsView =  window.subviews.first else { print("SPNotificationManagerError: failed to get: UIApplication.shared.windows.first.subviews.first")
            return
        }
        
        var isNotificationAleardyAdded = false
        for view in firsView.subviews  {
            if view.isKind(of: SPNotificationView.self) {
                isNotificationAleardyAdded = true
                break
            }
        }
        
        if !isNotificationAleardyAdded {
            let notificationView = SPNotificationView(frame: window.bounds)
            notificationView.isUserInteractionDisabled = isUserInteractionDisabled
            firsView.addSubview(notificationView)
            notificationView.set(notificationImageName: name, notificationTitle: title, notificationDetail: detail)
        } else {
            print("SPNotificationManagerError: Notification status is in transition")
        }
        
    }
}

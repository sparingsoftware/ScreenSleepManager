//
//  ScreenSleepManager.swift
//  ising
//
//  Created by Ufos on 02/05/2019.
//  Copyright © 2019 Panowie-Programisci. All rights reserved.
//

import Foundation
import UIKit

class ScreenSleepManager: IScreenSleepManager {
    
    
    static let instance = ScreenSleepManager()
    
    
    //
    
    var isDisabled: Bool {
        return timerDisable.isDisabled
    }
    
    //
    
    private var timerDisable: IIdleTimerDisable
    
    private var requests: [String] = []
    
    
    //
    
    init(timerDisable: IIdleTimerDisable = UIApplicationIdleTimerDisable()) {
        self.timerDisable = timerDisable
    }
    
    func requestToDisableSleep(withKey key: String) {
        requests.append(key)
        timerDisable.isDisabled = true
    }
    
    func removeRequest(forKey key: String) {
        requests.removeAll { (request) -> Bool in
            request == key
        }
        
        if (requests.count == 0) {
            timerDisable.isDisabled = false
        }
    }
}

//

protocol IScreenSleepManager {
    
    // if there is at least 1 request to disable - let it be
    func requestToDisableSleep(withKey key: String)
    
    // we don't require no-sleep mode anymore (for this key)
    // enable sleep only if there are no requests
    func removeRequest(forKey key: String)
    
}


//

class UIApplicationIdleTimerDisable: IIdleTimerDisable {
    
    var isDisabled: Bool {
        get {
            return UIApplication.shared.isIdleTimerDisabled
        }
        set(value) {
            DispatchQueue.main.async {
                UIApplication.shared.isIdleTimerDisabled = value
            }
        }
    }
    
}

//

protocol IIdleTimerDisable {
    var isDisabled: Bool { get set }
}

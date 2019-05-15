//
//  ScreenSleepManagerTests.swift
//  isingTests
//
//  Created by Ufos on 02/05/2019.
//  Copyright © 2019 Panowie-Programisci. All rights reserved.
//
@testable import ScreenSleepTest
import XCTest

class ScreenSleepManagerTests: XCTestCase {
    
    class MyMockIIdleTimerDisable: IIdleTimerDisable {
        var current = false
        var isDisabled: Bool {
            get {
                return current
            }
            set(value) {
                current = value
            }
        }
    }
    
    //
    
    var manager: ScreenSleepManager!
    
    override func setUp() {
        let mockIdleDisable = MyMockIIdleTimerDisable()
        manager = ScreenSleepManager(timerDisable: mockIdleDisable)
    }
    
    
    ///////
    
    func testMultipleRequestsRemoveToDisable() {
        manager.requestToDisableSleep(withKey: "test1")
        manager.requestToDisableSleep(withKey: "test2")
        manager.removeRequest(forKey: "test1")
        manager.requestToDisableSleep(withKey: "test3")
        manager.removeRequest(forKey: "test3")
        manager.removeRequest(forKey: "test2")
        
        XCTAssert(manager.isDisabled == false)
    }
    
    func testMultipleRequestsRemoveDoubleCalls() {
        manager.requestToDisableSleep(withKey: "test1")
        manager.requestToDisableSleep(withKey: "test2")
        manager.requestToDisableSleep(withKey: "test2")
        manager.requestToDisableSleep(withKey: "test2")
        manager.removeRequest(forKey: "test1")
        manager.removeRequest(forKey: "test1")
        manager.requestToDisableSleep(withKey: "test3")
        manager.removeRequest(forKey: "test3")
        manager.removeRequest(forKey: "test2")
        
        XCTAssert(manager.isDisabled == false)
    }
    
    func testMultipleRequestsRemove() {
        manager.requestToDisableSleep(withKey: "test1")
        manager.requestToDisableSleep(withKey: "test2")
        manager.removeRequest(forKey: "test1")
        manager.requestToDisableSleep(withKey: "test3")
        manager.removeRequest(forKey: "test3")
        
        XCTAssert(manager.isDisabled == true)
    }
    
    
    func testMultipleRequests() {
        manager.requestToDisableSleep(withKey: "test1")
        manager.requestToDisableSleep(withKey: "test2")
        manager.requestToDisableSleep(withKey: "test3")
        
        XCTAssert(manager.isDisabled == true)
    }
    
    func testSingleRequestRemove() {
        manager.requestToDisableSleep(withKey: "test1")
        manager.removeRequest(forKey: "test1")
        
        XCTAssert(manager.isDisabled == false)
    }
    
    func testSingleRequest() {
        manager.requestToDisableSleep(withKey: "test1")
        
        XCTAssert(manager.isDisabled == true)
    }
    
    func testEnableDefault() {
        XCTAssert(manager.isDisabled == false)
    }
    
    
}

//
//  CoreMotionService.swift
//  Duffy
//
//  Created by Patrick Rills on 7/24/16.
//  Copyright © 2016 Big Blue Fly. All rights reserved.
//

import CoreMotion

open class CoreMotionService
{
    static let instance = CoreMotionService()
    var pedometer: CMPedometer?
    
    init()
    {
        if (CMPedometer.isStepCountingAvailable())
        {
            pedometer = CMPedometer()
        }
    }
    
    open class func getInstance() -> CoreMotionService
    {
        return instance
    }
    
    open func initializeBackgroundUpdates()
    {
        if let ped = pedometer
        {
            ped.startUpdates(from: Date(), withHandler: {
                data, error in
                if let stepData = data {
                    
                    NSLog("CMPedometer - Steps Taken: \(stepData.numberOfSteps)")
                    
                    HealthKitService.getInstance().getSteps(Date(),
                        onRetrieve: {
                            (steps: Int, forDay: Date) in
                            
                            if (HealthCache.saveStepsToCache(steps, forDay: forDay))
                            {
                                WCSessionService.getInstance().updateWatchFaceComplication(["stepsdataresponse" : HealthCache.getStepsDataFromCache() as AnyObject])
                            }
                            
                        },
                        onFailure: nil)
                }
            })
        }
    }
    
    open func stopBackgroundUpdates()
    {
        if let ped = pedometer
        {
            ped.stopUpdates()
        }
    }
}

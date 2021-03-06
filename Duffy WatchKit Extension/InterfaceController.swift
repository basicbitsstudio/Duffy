//
//  InterfaceController.swift
//  Duffy WatchKit Extension
//
//  Created by Patrick Rills on 6/28/16.
//  Copyright © 2016 Big Blue Fly. All rights reserved.
//

import WatchKit
import Foundation
import DuffyWatchFramework

class InterfaceController: WKInterfaceController
{
    @IBOutlet weak var stepsValueLabel : WKInterfaceLabel?
    @IBOutlet weak var stepsGoalLabel : WKInterfaceLabel?
    @IBOutlet weak var infoButton: WKInterfaceButton?

    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        
        infoButton?.setHidden(!Constants.isDebugMode)
    }
    
    override func didAppear()
    {
        super.didAppear()
        
        askForHealthKitPermission()
    }
    
    fileprivate func askForHealthKitPermission()
    {
        //reset display if day turned over
        if (HealthCache.cacheIsForADifferentDay(Date()))
        {
            display(steps: 0)
        }
        
        HealthKitService.getInstance().authorizeForSteps({
            
            DispatchQueue.main.async(execute: {
                [weak self] in
                    self?.refresh()
                })
            
            }, onFailure: { })
    }
    
    fileprivate func refresh()
    {
        showLoading()
        displayTodaysStepsFromHealth()
        if let d = WKExtension.shared().delegate as? ExtensionDelegate
        {
            d.scheduleNextBackgroundRefresh()
            d.scheduleSnapshotNow()
        }
    }
    
    func displayTodaysStepsFromHealth()
    {
        HealthKitService.getInstance().getSteps(Date(),
            onRetrieve: {
                (stepsCount: Int, forDate: Date) in
                
                DispatchQueue.main.async(execute: {
                    [weak self] in
                    self?.display(steps: stepsCount)
                })
            },
            onFailure: {
                (error: Error?) in
                
                DispatchQueue.main.async(execute: {
                    [weak self] in
                    self?.displayTodaysStepsFromCache()
                })
            })
    }
    
    func displayTodaysStepsFromCache()
    {
        DispatchQueue.main.async(execute: {
            [weak self] in
            
            if let weakSelf = self
            {
                var steps = 0
                
                if (!HealthCache.cacheIsForADifferentDay(Date()))
                {
                    let cacheData = HealthCache.getStepsDataFromCache()
                    if let savedVal = cacheData["stepsCacheValue"] as? Int
                    {
                        steps = savedVal
                    }
                }
                
                weakSelf.display(steps: steps)
            }
        })
    }
    
    func showLoading()
    {
        setTitle("Getting...")
    }
    
    func hideLoading()
    {
        setTitle("Duffy")
    }
    
    private func display(steps: Int)
    {
        hideLoading()
        stepsValueLabel?.setText(InterfaceController.getNumberFormatter().string(from: NSNumber(value: steps)))
        updateGoalDisplay(stepsForDay: steps)
    }
    
    private func updateGoalDisplay(stepsForDay: Int)
    {
        if let lbl = stepsGoalLabel
        {
            let goalValue = HealthCache.getStepsDailyGoal()
            if goalValue > 0, let formattedValue = InterfaceController.getNumberFormatter().string(from: NSNumber(value: goalValue))
            {
                lbl.setHidden(false)
                lbl.setText(String(format: "of %@ %@", formattedValue, HealthKitService.getInstance().getAdornment(for: stepsForDay)))
            }
            else
            {
                lbl.setHidden(true)
            }
        }
    }
    
    @IBAction func refreshPressed()
    {
        refresh()
    }
    
    @IBAction func infoPressed()
    {
        refresh()
        
        let cancel = WKAlertAction(title: "Cancel", style: WKAlertActionStyle.cancel, handler: { () in })
        let cacheData = HealthCache.getStepsDataFromCache()
        var date = "Unknown"
        var steps = -1
        if let savedDay = cacheData["stepsCacheDay"] as? String
        {
            date = savedDay
        }
        if let savedVal = cacheData["stepsCacheValue"] as? Int
        {
            steps = savedVal
        }
        
        let wasSentToday = NotificationService.dailyStepsGoalNotificationWasAlreadySent()
        let wasSentString = wasSentToday ? "today" : "n/a"
        
        let message = String(format: "Saved in cache:\n Steps: %d\n For day: %@\n Last note sent: %@", steps, date, wasSentString)
        presentAlert(withTitle: "Info", message: message, preferredStyle: WKAlertControllerStyle.alert, actions: [cancel])
    }
    
    @IBAction func changeGoalMenuItemPressed()
    {
        presentController(withName: "editGoalInterfaceController", context: nil)
    }
    
    open class func getNumberFormatter() -> NumberFormatter
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
}

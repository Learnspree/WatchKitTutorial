//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by David Jackson on 24/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import WatchKit
import Foundation
import BitWatchKit


class InterfaceController: WKInterfaceController {

    let tracker = Tracker()
    var updating = false
    
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var upDownImage: WKInterfaceImage!
    @IBOutlet weak var lastUpdatedLabel: WKInterfaceLabel!
    
    @IBAction func refreshPrice() {
        update()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        updatePrice(tracker.cachedPrice())
        upDownImage.setHidden(true)
        updateDate(tracker.cachedDate())
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        update()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func updatePrice(price: NSNumber) {
        priceLabel.setText(Tracker.priceFormatter.stringFromNumber(price))
    }
    
    private func update() {
        // 1
        if !updating {
            updating = true
            
            // 2
            let originalPrice = tracker.cachedPrice()
            // 3
            tracker.requestPrice { (price, error) -> () in
                // 4
                if error == nil {
                    self.updatePrice(price!)
                    self.updateDate(NSDate())
                    self.updateImage(originalPrice, newPrice: price!)
                }
                self.updating = false
            }
        }
    }
    
    private func updateDate(date: NSDate) {
        self.lastUpdatedLabel.setText("Last updated \(Tracker.dateFormatter.stringFromDate(date))")
    }
    
    private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
        if originalPrice.isEqualToNumber(newPrice) {
            // 1
            upDownImage.setHidden(true)
        } else {
            // 2
            if newPrice.doubleValue > originalPrice.doubleValue {
                upDownImage.setImageNamed("Up")
            } else {
                upDownImage.setImageNamed("Down")
            }
            upDownImage.setHidden(false)
        }
    }

}

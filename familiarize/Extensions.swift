//
//  File.swift
//  familiarize
//
//  Created by Alex Oh on 6/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation

extension NSDate {
    
    // This shows us how recent the user was added. I.E. "12 Minutes Ago"
    func getElapsedTime() -> String {
        
        // Hard coded to always show numeric values (:
        let numericDates:Bool = true
        
        let calendar = NSCalendar.current
        let now = NSDate()
        let earliest = now.earlierDate(self as Date)
        let latest = (earliest == now as Date) ? self : now
        //let components = calendar.dateComponents(, from: earliest as Date)
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) yrs"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 yr"
            }
//            else {
//                return "Last year"
//            }
        } else if (components.month! >= 2) {
            return "\(components.month!) mos"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 mo"
            }
//            else {
//                return "Last month"
//            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) wks"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            }
//            else {
//                return "Last week"
//            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day"
            }
//            else {
//                return "Yesterday"
//            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hrs"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hr"
            }
//            else {
//                return "An hour ago"
//            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) mins"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 min"
            }
//            else {
//                return "A minute ago"
//            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}

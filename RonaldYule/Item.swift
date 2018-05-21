//
//  Item.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 06/08/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import Foundation
import UIKit

class Item {
    //MARK: Properties
    var name: String
    var price: NSDecimalNumber
    
    //MARK: Initialization
    init?(name: String, price: NSDecimalNumber) {
        self.name = name
        self.price = price
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
}

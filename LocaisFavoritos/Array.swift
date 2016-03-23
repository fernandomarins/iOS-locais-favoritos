//
//  Array.swift
//  LocaisFavoritos
//
//  Created by Fernando Augusto de Marins on 16/02/16.
//  Copyright © 2016 Fernando Augusto de Marins. All rights reserved.
//

import UIKit

struct Array {
    
    var places = [Dictionary<String, String>]()
    
    var activePlace = -1
    
    static var sharedInstance = Array()
    
}

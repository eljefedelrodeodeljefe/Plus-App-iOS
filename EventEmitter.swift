//
//  EventEmitter.swift
//  plus-app
//
//  Created by Robert Lindstädt on 28.05.16.
//  Copyright © 2016 plus. All rights reserved.
//

import Foundation
import EmitterKit

class EventEmitter {
    
    static let shared = EventEmitter()
    var menu: Event<String>!
    var listener: Listener!
    
    private init() {
        print("initted")
        self.menu = Event<String>()
    }
}
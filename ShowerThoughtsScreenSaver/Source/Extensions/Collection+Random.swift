//
//  Collection+Random.swift
//  ShowerThoughtsScreenSaver
//
//  Created by Red Davis on 14/04/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import Foundation


internal extension Collection where Index == Int
{
    func randomElement() -> Iterator.Element?
    {
        if self.isEmpty
        {
            return nil
        }
        
        let index = Int(arc4random_uniform(UInt32(self.endIndex)))
        return self[index]
    }
}

//
//  Thought.swift
//  ShowerThoughtsScreenSaver
//
//  Created by Red Davis on 14/04/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import Foundation


internal extension ShowerThoughtsAPIClient
{
    internal struct Thought: Codable
    {
        // Internal
        internal let value: String
        internal let author: String
        
        // MARK: Initialization
        
        internal init(value: String, author: String)
        {
            self.value = value
            self.author = author
        }
    }
}


// MARK: Coding keys

internal extension ShowerThoughtsAPIClient.Thought
{
    internal enum CodingKeys: String, CodingKey
    {
        case value = "thought"
        case author
    }
}

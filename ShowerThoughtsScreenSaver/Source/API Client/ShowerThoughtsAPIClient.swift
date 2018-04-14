//
//  ShowerThoughtsAPIClient.swift
//  ShowerThoughtsScreenSaver
//
//  Created by Red Davis on 14/04/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import Foundation


internal final class ShowerThoughtsAPIClient
{
    // Private
    private let session: URLSession
    private let baseURL = URL(string: "https://shower-thought-api-production.herokuapp.com")!
    
    // MARK: Initialization
    
    internal required init(session: URLSession = URLSession(configuration: .default))
    {
        self.session = session
    }
    
    // MARK: Request
    
    private func perform(request: URLRequest, completionHandler: @escaping (_ json: Any?, _ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)
    {
        // Perform request
        let task = self.session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            let json: Any?
            
            if let unwrappedData = data
            {
                json = try? JSONSerialization.jsonObject(with: unwrappedData, options: [])
            }
            else
            {
                json = nil
            }
            
            completionHandler(json, data, httpResponse, error)
        }
        
        task.resume()
    }
}


internal extension ShowerThoughtsAPIClient
{
    internal func fetchThoughts(_ completionHandler: @escaping (_ thoughts: [Thought]?, _ error: Error?) -> Void)
    {
        let requestPath = "/threads"
        let url = self.baseURL.appendingPathComponent(requestPath)
        let request = URLRequest(url: url)
        
        self.perform(request: request) { (json, data, response, error) in
            guard let unwrappedData = data else
            {
                completionHandler(nil, error)
                return
            }
            
            do
            {
                let decoder = JSONDecoder()
                let thoughts = try decoder.decode([Thought].self, from: unwrappedData)
                
                completionHandler(thoughts, nil)
            }
            catch let error
            {
                completionHandler(nil, error)
            }
        }
    }
}

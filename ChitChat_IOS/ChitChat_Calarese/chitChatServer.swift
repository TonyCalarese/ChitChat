//
//  contentLoader.swift
//  ChitChat_Calarese
//
//  Created by Tony Calarese on 4/25/20.
//  Copyright © 2020 Tony Calarese. All rights reserved.
//

//Content Refernced from the WIkipedia Lab, Week 12 on canvas
//Code originated from David Kopec, Please give credit where it is due

import Foundation

class chitChatServer{
    var data: Data?
    let API_KEY: String = "e781c246-6636-4e06-acd9-f5047b312508"
    let API_EMAIL: String = "anthony.calarese@mymail.champlain.edu"
    let URL: String = "https://www.stepoutnyc.com/chitchat"
    let LIKE_URL: String = "https://www.stepoutnyc.com/chitchat/like/"
    let DISLIKE_URL: String = "https://www.stepoutnyc.com/chitchat/dislike/"

    //Creating all the URLS
    func concatURL() -> String{
        return URL + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY
    }
    func concatLIKEURL(id: String) -> String {
        return LIKE_URL + id + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY
    }
    func concatDISLIKEURL(id: String) -> String {
        return DISLIKE_URL + id + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY
        
    }
    func concatMESSAGEURL(message: String) -> String {
           return URL + "?" + "client=" + API_EMAIL + "&key=" + API_KEY + "&message=" + message
       }
     

    func downloadContent() -> Void{
          let chitchat = concatURL() //Concat the URL
          guard let textURL = Foundation.URL(string: chitchat) else {
              print("ERROR WITH URL")
              return
          } //convert string to url
          //get either data, response, or error message
          URLSession.shared.dataTask(with: textURL) { (data: Data?, response: URLResponse?, error: Error?) in
              if let error = error { // error is nil if there was none
                  print(" Error Getting Data: \(error.localizedDescription)")
              }
              
              if let data = data {
                  DispatchQueue.main.async {
                      print("Got Data")
                      print(data)
                      self.data = data
                  }
              }
          //This should give the usr back the JSON Text
          }.resume()
      }

       func parseJSON(data: Data, completion: @escaping (Error?, [MESSAGE]?) -> Void) {
           print("Made it to the ParseJson")
           do {
               let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
               print(jsonObj)
               print((type(of: jsonObj)))
               
               //Code Refernced from Wikipedia lab
               let JSON_Decoder = JSONDecoder()
                   struct MessageService: Decodable{
                       let count: Int
                       let date: String
                       let messages: [MESSAGE]
                       
                   }
                 

                let messageService = try JSON_Decoder.decode(MessageService.self, from: data)
                completion(nil, messageService.messages)
                   print("Completed the parsing")
         
           } catch let error{
               print("Error Creating JSON Object : \(error) ")
           }
        
           
    }
}

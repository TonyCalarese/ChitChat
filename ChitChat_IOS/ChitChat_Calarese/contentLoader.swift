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

class contentLoader{
    var data: Data?
    let API_KEY: String = "e781c246-6636-4e06-acd9-f5047b312508"
    let API_EMAIL: String = "anthony.calarese@mymail.champlain.edu"
    let URL: String = "https://www.stepoutnyc.com/chitchat"
    let LIKE_URL: String = "https://www.stepoutnyc.com/chitchat/like/"
    let DISLIKE_URL: String = "https://www.stepoutnyc.com/chitchat/dislike/"

     var messages: [String] = []
     var ids: [String] = []
     var dates: [String] = []
     var dislikes: [String] = []
     var likes: [String] = []
     var clients: [String] = []
     
    func getCount() -> Int{
         return messages.count // getting the size for number of cells
     }
    //Creating all the URLS
    func concatURL() -> String{
        //Translate to:https://www.stepoutnyc.com/chitchat?client=anthony.calarese@mymail.champlain.edu&key=e781c246-6636-4e06-acd9-f5047b312508
        return URL + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY
    }
    func concatLIKEURL(id: String) -> String {
        return LIKE_URL + id + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY
        
    }
    func concatDISLIKEURL(id: String) -> String {
        return DISLIKE_URL + id + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY
        
    }
     
     func getAllItems(index: Int) -> (String, String, String, String, String, String) {
         return (messages[index], ids[index], dates[index], dislikes[index], likes[index], clients[index])
     }
    func getAllItems() -> [String]{
        return messages
        
    }
     func addContent(message: String, id: String, date: String, dislikes: String, likes: String, client: String) {
         
         self.messages.append(message)
         self.ids.append(id)
         self.dates.append(date)
         self.dislikes.append(String(dislikes))
         self.likes.append(String(likes))
         self.clients.append(client)
         
     }
 //Asynchronous Functions
    func downloadContentURLs() -> Void{
          let chitchat = concatURL() //My special URL
          guard let textURL = Foundation.URL(string: chitchat) else {
              print("ERROR WITH URL")
              print(chitchat)
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

    
    //Code heavily refernces wikipedia lab from week 12
       func parseJSON(data: Data, completion: @escaping (Error?, [MESSAGE]?) -> Void) {
           print("Made it to the ParseJson")
           do {
               let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
               print(jsonObj)
               print((type(of: jsonObj)))
               
               //Code Refernced from Wikipedia lab
               let JSON_Decoder = JSONDecoder()
               
                   //Helpful code from Kopec
                   struct MessageService: Decodable{
                       let count: Int
                       let date: String
                       let messages: [MESSAGE]
                       

                   }
                 

                let messageService = try JSON_Decoder.decode(MessageService.self, from: data)
                completion(nil, messageService.messages)
                   print("Completed the parsing")
            /*
                   let size = messageService.count
                   //func addContent(message: String, id: String, date: String, dislikes_label: String, likes: String, client: String)
                   
                   for index in 0...size-1 {
                       //<#T##String#>messageService.messages[index]._id
                    //print(messageService.messages[index].message)
                    self.addContent(message: messageService.messages[index].message, id: messageService.messages[index]._id,
                                  date: messageService.messages[index].date, dislikes: String(messageService.messages[index].dislikes),
                                  likes: String(messageService.messages[index].likes), client: messageService.messages[index].client )
            
            
                   }
 */
           } catch let error{
               print("Error Creating JSON Object : \(error) ")
           }
        
           
    }
}

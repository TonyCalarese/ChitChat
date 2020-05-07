//
//  ChitChatTableViewController.swift
//  ChitChat_Calarese
//
//  Created by Tony Calarese on 4/20/20.
//  Copyright © 2020 Tony Calarese. All rights reserved.
//

import UIKit

class ChitChatTableViewController: UITableViewController {
    //Data Structure
    var server = contentLoader() //Declare the class for the items
    var messages: [MESSAGE] = []
    
    let API_KEY: String = "e781c246-6636-4e06-acd9-f5047b312508"
    let API_EMAIL: String = "anthony.calarese@mymail.champlain.edu"
    let URL: String = "https://www.stepoutnyc.com/chitchat"
    let LIKE_URL: String = "https://www.stepoutnyc.com/chitchat/like/"
    let DISLIKE_URL: String = "https://www.stepoutnyc.com/chitchat/dislike/"
    
    @IBOutlet weak var msgText: UITextField!
    
    @IBAction func sendMessage(_ sender: Any) {
        print("Posting to server")
        post()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadContent()
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
    func concatMESSAGEURL(message: String) -> String {
        return URL + "?" + "client=" + API_EMAIL + "&key=" + API_KEY + "&message=" + message
        
    }
   
   
    // MARK: - Table view data source
    //Table View Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count

    }
    
    
    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "chitchatcell", for: indexPath) as! ChitChatTableViewCell
         
       // let (message, id, date, dislikes, likes, client) = server.getAllItems(index: indexPath.row)
        let message = messages[indexPath.row]
        cell.message_label.text = message.message
        cell.id = message._id
        cell.date_label.text = message.date
        cell.dislikes_label.text = String(message.dislikes)
        cell.likes_label.text = String(message.likes)
        cell.client = message.client
        
        return cell
    }
    
    //Download the JSON
    func downloadContent() -> Void{
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
                    //Here is where we parse the JSON
                    self.server.parseJSON(data: data) { [unowned self] (error, messages) in
                        if error != nil {
                            print(error.debugDescription)
                        }
                        if let messages = messages {
                            print(messages)
                            self.messages = messages
                            self.tableView.reloadData()
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        //This should give the usr back the JSON Text
        }.resume()
         self.tableView.reloadData()
    }
    
    //Source for making sure the posting will work properly: https://stackoverflow.com/questions/24551816/swift-encode-url
    //Nulling spaces
    func post() -> Void{
        //Sending string for post request
        if let sendingMsg = msgText.text{
           let postMsg = sendingMsg.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let MsgURL = concatMESSAGEURL(message: postMsg!) //Getting url
        print(MsgURL)
        guard let postURL = Foundation.URL(string: MsgURL) else {
            print("Cannot get URL")
            return }
        
        //Helpful code from kopec
        var urlRequest = URLRequest(url: postURL)
        urlRequest.httpMethod = "POST"
        URLSession.shared.dataTask(with: urlRequest) {(data: Data?, response: URLResponse?, error: Error?) in
            if let error = error { // error is nil if there was none
                print(" Error Getting Data: \(error.localizedDescription)")
            }
            if let data = data {
                print(data)
            }
            if let response = response{
                print(response)
            }
            DispatchQueue.main.async {
                print("Re-getting the data")
                self.downloadContent()
                
            }
        //This should give the usr back the JSON Text
        }.resume()
    }
    }


}

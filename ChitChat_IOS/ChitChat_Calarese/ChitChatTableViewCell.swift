//
//  ChitChatTableViewCell.swift
//  ChitChat_Calarese
//
//  Created by Tony Calarese on 4/20/20.
//  Copyright © 2020 Tony Calarese. All rights reserved.
//

import UIKit

class ChitChatTableViewCell: UITableViewCell {
    let server = chitChatServer()
    
    
    var id = ""
    var client = ""
    @IBOutlet weak var message_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var likes_label: UILabel!
    @IBOutlet weak var like_button: UIButton!
    @IBOutlet weak var dislike_button: UIButton!
    @IBOutlet weak var dislikes_label: UILabel!
    
    
    @IBAction func like_message(_ sender: Any) {
        let ChatURL = server.concatLIKEURL(id: self.id)
        (sender as! UIButton).isHidden = true
        guard let likeURL = Foundation.URL(string: ChatURL) else { return }
            URLSession.shared.dataTask(with: likeURL) { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error { // error is nil if there was none
                    print("Error: \(error.localizedDescription)")
                }
                    DispatchQueue.main.async {
                       //Add the like and go to the next one
                        let currentLikes: Int = Int(self.likes_label.text!)!
                        self.likes_label.text = String(currentLikes + 1)
                }
            }.resume()
        
        }
        
    
    @IBAction func dislike_message(_ sender: Any) {
        let ChatURL = server.concatDISLIKEURL(id: self.id)
               (sender as! UIButton).isHidden = true
               guard let likeURL = Foundation.URL(string: ChatURL) else { return }
                   URLSession.shared.dataTask(with: likeURL) { (data: Data?, response: URLResponse?, error: Error?) in
                       if let error = error { // error is nil if there was none
                           print("Image Download Error: \(error.localizedDescription)")
                       }
                           DispatchQueue.main.async {
                              //Add the like and go to the next one
                               let currentLikes: Int = Int(self.dislikes_label.text!)!
                               self.dislikes_label.text = String(currentLikes + 1)
                           }
                   }.resume()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

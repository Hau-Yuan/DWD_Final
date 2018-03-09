//
//  ViewController.swift
//  mobile-lab-websockets
//
//  Created by Hau Yuan on 2/28/18.
//  Copyright © 2018 Hau Yuan. All rights reserved.

import UIKit
import Starscream    // Socket library


// An enumeration for direction commands.

enum DirectionCode: String {
    case up = "0"
    case right = "1"
    case down = "5"
    case left = "2"
    case TouchUp = "3"
    case fire = "4"
}

let playerIdKey = "PLAYER_ID";

class ViewController: UIViewController, WebSocketDelegate, UITextFieldDelegate {

    // User UserDefaults for simple storage.
    var defaults: UserDefaults!
    
    // Object for managing the web socket.
    var socket: WebSocket?
    

    @IBAction func UpTouchDown(_ sender: UIButton) {
        sendDirectionMessage(.up)
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func upTouchUp(_ sender: UIButton) {
        sendDirectionMessage(.TouchUp)
    }
   
    @IBAction func rightTouchDown(_ sender: UIButton) {
        sendDirectionMessage(.right)
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func rightTouchUp(_ sender: UIButton) {
        sendDirectionMessage(.TouchUp)
    }
    
    
    @IBAction func leftTouchDown(_ sender: UIButton) {
        sendDirectionMessage(.left)
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func leftTouchUp(_ sender: UIButton) {
        sendDirectionMessage(.TouchUp)
    }
    
    @IBAction func fireLaser(_ sender: UIButton) {
        sendDirectionMessage(.fire)
        feedbackGenerator.impactOccurred()
    }
    // Input text field.
    @IBOutlet weak var playerIdTextField: UITextField!
    
    // Generator for haptic feedback.
    var feedbackGenerator: UIImpactFeedbackGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // URL of web server.
        let urlString = "ws://198.199.72.139:1024/"
    
        // Create a WebSocket.
        socket = WebSocket(url: URL(string: urlString)!)
        
        // Assign WebSocket delegate to self
        socket?.delegate = self
        
        // Connect.
        socket?.connect()
        
        // Assigning notifications to when the app becomes active or inactive.
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    
        // Set delegate for text field to conform to protocol.
        playerIdTextField.delegate = self

        // Init user defaults object for storage.
        defaults = UserDefaults.standard

        // Get USER DEFAULTS data. ////////////
        // If there is a player id saved, set text field.
        if let playerId = defaults.string(forKey: playerIdKey) {
            playerIdTextField.text = playerId
        }
        
        feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)

    }


    // Textfield delegate method.
    // Update player id in user defaults when "Done" is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)

        // Check text field is not empty, otherwise save to user defaults.
        if (textField.text?.isEmpty)! {
            presentAlertMessage(message: "Enter Valid Player Id")
            textField.text = defaults.string(forKey: playerIdKey)!
        } else {

            // Set USER DEFAULTS data. ////////////
            defaults.set(textField.text!, forKey: playerIdKey)
            presentAlertMessage(message: "Player Id Saved!")
            //////////////////////////////////////
        }

        return false
    }
    

    // Helper method for displaying a alert view.
    func presentAlertMessage(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    // WebSocket delegate methods
    func websocketDidConnect(socket: WebSocketClient) {
        print("✅ Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("🛑 Disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        // print("⬇️ websocket did receive message:", text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        // print("<<< Received data:", data)
    }

    func sendDirectionMessage(_ code: DirectionCode) {
        // Get the raw string value from the DirectionCode enum
        // that we created at the top of this program.
        sendMessage(code.rawValue)
    }

    func sendMessage(_ message: String) {
        // Check if there is a valid player id set.
        guard let playerId = defaults.string(forKey: playerIdKey) else {
            presentAlertMessage(message: "Enter Player Id")
            return
        }

        // Construct server message and write to socket. ///////////
        let message = "\(playerId), \(message)"
        socket?.write(string: message) {
            // This is a completion block.
            // We can write custom code here that will run once the message is sent.
            print("⬆️ sent message to server: ", message)
        }
        ///////////////////////////////////////////////////////////

    }
    
    @objc func willResignActive() {
        print("💡 Application will resign active. Disconnecting socket.")
        socket?.disconnect()
    }
    
    @objc func didBecomeActive() {
        print("💡 Application did become active. Connecting socket.")
        socket?.connect()
    }
}


// Some helpers using extensions
extension Date{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


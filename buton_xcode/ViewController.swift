//
//  ViewController.swift
//  buton_xcode
//
//  Created by SSSakib on 22/4/24.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make buttons to call the showFlutter function with different data when pressed.
        let button1 = createButton(title: "Enamul", yPosition: 200.0, data: "mailId=enamul@gmail.com")
        let button2 = createButton(title: "Wasit", yPosition: 300.0, data: "mailId=wasit@gmail.com")
        let button3 = createButton(title: "None", yPosition: 400.0, data: "")

        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
    }

    @objc func showFlutter(data: String) {
        // Get reference to the FlutterEngine
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flutterEngine = appDelegate.flutterEngine

        // Create a FlutterViewController with the FlutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)

        // Initialize a MethodChannel to communicate with Flutter
        let methodChannel = FlutterMethodChannel(name: "my_channel_name", binaryMessenger: flutterViewController.binaryMessenger)

        // Create a data dictionary to pass to Flutter
        let dataDict: [String: Any] = [
            "data": data
        ]

        // Invoke the method on the MethodChannel with the data
        methodChannel.invokeMethod("setData", arguments: dataDict)

        // Present the FlutterViewController
        present(flutterViewController, animated: true, completion: nil)
    }

    func createButton(title: String, yPosition: CGFloat, data: String) -> UIButton {
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.setTitle("Show Flutter: \(title)", for: UIControl.State.normal)
        button.frame = CGRect(x: 80.0, y: yPosition, width: 200.0, height: 40.0)
        button.backgroundColor = UIColor.blue
        button.tag = 0 // Tag is not used for passing data, set to 0
        button.setTitleColor(.white, for: .normal) // Make text white for better visibility
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Adjust font size and weight
        button.layer.cornerRadius = 10 // Apply corner radius for rounded corners
        button.clipsToBounds = true // Clip content to bounds for rounded corners
        button.titleLabel?.adjustsFontSizeToFitWidth = true // Adjust title font size to fit button width
        button.titleLabel?.minimumScaleFactor = 0.5 // Set minimum scale factor for text fitting
        button.titleLabel?.lineBreakMode = .byTruncatingTail // Truncate text if it doesn't fit
        
        button.accessibilityIdentifier = data // Set accessibility identifier to pass data

        return button
    }

    @objc func buttonPressed(sender: UIButton) {
        // Extract data from the button's accessibility identifier
        guard let data = sender.accessibilityIdentifier else {
            return
        }

        // Call showFlutter function with the extracted data
        showFlutter(data: data)
    }
}

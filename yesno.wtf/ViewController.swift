//
//  ViewController.swift
//  yesno.wtf
//
//  Created by Yakov Kadosh on 17/10/17.
//  Copyright © 2017 Kobi Kadosh. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class ViewController: UIViewController {
	//MARK: Properties
	@IBOutlet weak var answerTextView: UITextView!
	@IBOutlet weak var imageView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		Alamofire.request("https://yesno.wtf/api").responseJSON { response in
			if
				let json = response.result.value as? [String: Any],
				let imageUrl = json["image"] as? String,
				let answer = json["answer"] as? String
			{
				print("JSON: \(json)") // serialized json response
				let url = URL.init(string: imageUrl)

				self.downloadImage(url: url!, callback: { (data) in
					self.renderAnimation(data: data)
				})
				
//				UIImageView(frame: CGRectMake(100, 150, 150, 100))
//				self.image.image = UIImage(named: "Image")
				
				self.answerTextView.text = answer
				
//				text-shadow: 0 0 20px rgba(0, 0, 0, 0.25), 0 2px 2px rgba(0, 0, 0, 0.5);
				
				self.answerTextView.layer.shadowColor = UIColor.black.cgColor
				self.answerTextView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
				self.answerTextView.layer.shadowOpacity = 0.25
				self.answerTextView.layer.shadowRadius = 0
				self.answerTextView.layer.backgroundColor = UIColor.clear.cgColor
			}
		}
	}
	
	func renderAnimation(data: Data?) {
		/* Create AImage with URL */
		let image = AImage(data: data!)
		
		/* Create AImageView */
		let screenSize: CGRect = UIScreen.main.bounds
		let screenWidth = screenSize.width
		let screenHeight = screenSize.height
		let screenframe = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
		let imageview = AImageView(frame: screenframe/*, contentMode: UIViewContentMode.scaleToFill*/)
//		let imageview = AImageView(frame:CGRect(x: 0.0, y: 50.0, width: 380.0, height: 212.0))
//		let imageview = AImageView(frame: screenSize)
		
		/* Add AImage to AImageView */
		imageview.add(image: image!)
		
		/* Start displaying animated image */
		imageview.play = true
		
//		self.image.image = imageview
		self.imageView.addSubview(imageview)
	}
	
	func downloadImage(url: URL?, callback: @escaping (Data?) ->()) {
		// Creating a session object with the default configuration.
		// You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
		let session = URLSession(configuration: .default)
		
		// Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
		let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
			// The download has finished.
			if let e = error {
				print("Error downloading cat picture: \(e)")
			} else {
				// No errors found.
				// It would be weird if we didn't have a response, so check for that too.
				if let res = response as? HTTPURLResponse {
					print("Downloaded cat picture with response code \(res.statusCode)")
					if let imageData = data {
						// Finally convert that Data into an image and do what you wish with it.
						callback(imageData)
						// Do something with your image.
					} else {
						print("Couldn't get image: Image is nil")
					}
				} else {
					print("Couldn't get response code for some reason")
				}
			}
		}
		
		downloadPicTask.resume()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


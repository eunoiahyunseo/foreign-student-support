//
//  IntentViewController.swift
//  OpenSiriKitUI
//
//  Created by 한의진 on 2023/05/24.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"


/*
class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    var AnswerData: String = ""
    @IBOutlet weak var tblView: UILabel
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
*/

//
//  IntentViewController.swift
//  BillTrackerIntentUI
//
//  Created by Ami Intwala on 26/05/21.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"
import SwiftUI
class IntentViewController: UIViewController, INUIHostedViewControlling {
    @IBOutlet var LblText: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LblText = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 30))

        
            //let Answ = OpenSiriKitIntentAIntentResponse
        //let Answer = UserDefaults.standard.object(forKey: "asr") as? String


//        LblText.text = "The OpenAI Says \(Answer)"
               LblText.textAlignment = .center
               view.addSubview(LblText)
    
        LblText.setNeedsLayout()
        LblText.setNeedsDisplay()
        
       
        
        
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
       
        let intent  = interaction.intent as! OpenSiriKitIntentAIntent
        //interaction.intentResponse.answer
        let Answer = interaction.intentResponse?.value(forKey: "answer") as? String
        //intent.ThingsToAsk
        UserDefaults.standard.object(forKey: "asr") as? String
        LblText.text = Answer
        
        
        
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext?.hostedViewMaximumAllowedSize ?? CGSize.zero
    }
}
/*
 extension IntentViewController: UITableViewDelegate, UITableViewDataSource {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return self.billData.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
 return UITableViewCell()
 }
 let bill = billData[indexPath.row]
 if let billName = bill["title"] as? String, let price = bill["price"] as? Int {
 cell.textLabel?.text = billName
 cell.detailTextLabel?.text = price.description
 }
 return cell
 }
 
 
 }
 
 */

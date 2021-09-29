//
//  NineHoleTableViewController.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/29/21.
//

import UIKit

class NineHoleTableViewController: UITableViewController {
    // Par Outlets
    @IBOutlet weak var hole1: UITextField!
    @IBOutlet weak var hole2: UITextField!
    @IBOutlet weak var hole3: UITextField!
    @IBOutlet weak var hole4: UITextField!
    @IBOutlet weak var hole5: UITextField!
    @IBOutlet weak var hole6: UITextField!
    @IBOutlet weak var hole7: UITextField!
    @IBOutlet weak var hole8: UITextField!
    @IBOutlet weak var hole9: UITextField!
    @IBOutlet weak var parTotal: UITextField!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    //Score Outlets
    @IBOutlet weak var score1: UITextField!
    @IBOutlet weak var score2: UITextField!
    @IBOutlet weak var score3: UITextField!
    @IBOutlet weak var score4: UITextField!
    @IBOutlet weak var score5: UITextField!
    @IBOutlet weak var score6: UITextField!
    @IBOutlet weak var score7: UITextField!
    @IBOutlet weak var score8: UITextField!
    @IBOutlet weak var score9: UITextField!
    @IBOutlet weak var scoreTotal: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.isEnabled = false
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        
        // par
        let one = hole1.text!
        let two = hole2.text!
        let three = hole3.text!
        let four = hole4.text!
        let five = hole5.text!
        let six = hole6.text!
        let seven = hole7.text!
        let eight = hole8.text!
        let nine = hole9.text!
        
        // scores
        let oneS = score1.text!
        let twoS = score2.text!
        let threeS = score3.text!
        let fourS = score4.text!
        let fiveS = score5.text!
        let sixS = score6.text!
        let sevenS = score7.text!
        let eightS = score8.text!
        let nineS = score9.text!
        
        guard let oneInt = Int(one), let twoInt = Int(two), let threeInt = Int(three), let fourInt = Int(four), let fiveInt = Int(five), let sixInt = Int(six), let sevenInt = Int(seven), let eightInt = Int(eight), let nineInt = Int(nine), let oneSInt = Int(oneS), let twoSInt = Int(twoS), let threeSInt = Int(threeS), let fourSInt = Int(fourS), let fiveSInt = Int(fiveS), let sixSInt = Int(sixS), let sevenSInt = Int(sevenS), let eightSInt = Int(eightS), let nineSInt = Int(nineS) else { return }
        
        let totalPar = oneInt + twoInt + threeInt + fourInt + fiveInt + sixInt + sevenInt + eightInt + nineInt
        
        let totalScore = oneSInt + twoSInt + threeSInt + fourSInt + fiveSInt + sixSInt + sevenSInt + eightSInt + nineSInt
        parTotal.text = "\(totalPar)"
        scoreTotal.text = "\(totalScore)"
    }
    
    @IBAction  func editindDidChanged(_ sender: UITextField) {
        refreshButton.isEnabled = true
    }
}

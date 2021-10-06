//
//  NineHoleTableViewController.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/29/21.
//

import UIKit

class NineHoleTableViewController: UITableViewController {
    
    //MARK: - Par Outlets
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

    
//MARK: - Score Outlets
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
    
    //MARK: - Other
    @IBOutlet weak var finalScore: UITextField!
    @IBOutlet weak var golfCourseLocationText: UITextField!
    
    //MARK: - Properties
    var scoreboard: ScoreBoard?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupViews()
        
        UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
    }
    
    //MARK: - Helper Funcs
    func setupViews() {
        hole1.delegate = self
        hole2.delegate = self
        hole3.delegate = self
        hole4.delegate = self
        hole5.delegate = self
        hole6.delegate = self
        hole7.delegate = self
        hole8.delegate = self
        hole9.delegate = self
        
        score1.delegate = self
        score2.delegate = self
        score3.delegate = self
        score4.delegate = self
        score5.delegate = self
        score6.delegate = self
        score7.delegate = self
        score8.delegate = self
        score9.delegate = self
        
    }
    
    func calculateFinal() {
        let finalPar = parTotal.text!
        let finalScores = scoreTotal.text!
        
        let par = Int(finalPar) ?? 0
        let score = Int(finalScores) ?? 0
        
        finalScore.text = "\(score - par)"
    }
    
    func calculatePar() {
        let one = hole1.text!
        let two = hole2.text!
        let three = hole3.text!
        let four = hole4.text!
        let five = hole5.text!
        let six = hole6.text!
        let seven = hole7.text!
        let eight = hole8.text!
        let nine = hole9.text!
        
        let parOne = Int(one) ?? 0
        let parTwo = Int(two) ?? 0
        let parThree = Int(three) ?? 0
        let parFour = Int(four) ?? 0
        let parFive = Int(five) ?? 0
        let parSix = Int(six) ?? 0
        let parSeven = Int(seven) ?? 0
        let parEight = Int(eight) ?? 0
        let parNine = Int(nine) ?? 0
        
        let totalPar = parOne + parTwo + parThree + parFour + parFive + parSix + parSeven + parEight + parNine
        parTotal.text = "\(totalPar)"
        print(totalPar)
    }
    
    func calculateScore() {

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
        
        
        
        let scoreOne = Int(oneS) ?? 0
        let scoreTwo = Int(twoS) ?? 0
        let scoreThree = Int(threeS) ?? 0
        let scoreFour = Int(fourS) ?? 0
        let scoreFive = Int(fiveS) ?? 0
        let scoreSix = Int(sixS) ?? 0
        let scoreSeven = Int(sevenS) ?? 0
        let scoreEight = Int(eightS) ?? 0
        let scoreNine = Int(nineS) ?? 0
        
    
        
        let totalScore = scoreOne + scoreTwo + scoreThree + scoreFour + scoreFive + scoreSix + scoreSeven + scoreEight + scoreNine
        

        scoreTotal.text = "\(totalScore)"

    }
    
    //MARK: - Actions
 
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("tapped")
        
        guard let finalScore = finalScore.text, !finalScore.isEmpty, let golfLocation = golfCourseLocationText.text, !golfLocation.isEmpty else { return }
        let date = Date()
        let finalScoreInt = Int(finalScore)
        
        ScoreBoardController.sharedInstance.createScoreCard(score: finalScoreInt!, location: golfLocation, timestamp: date)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction  func editindDidChanged(_ sender: UITextField) {
        calculateScore()
    }
    
    func updateViews() {
        guard let scoreboard = scoreboard else { return }
        
        finalScore.text = "\(scoreboard.score)"

    }
    //MARK: - Table delegate
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 
    }
}

extension NineHoleTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case hole1:
            calculatePar()
            if !score1.text!.isEmpty {
                calculateFinal()
            }
        case hole2:
            calculatePar()
            if !score2.text!.isEmpty {
                calculateFinal()
            }
        case hole3:
            calculatePar()
            if !score3.text!.isEmpty {
                calculateFinal()
            }
        case hole4:
            calculatePar()
            if !score4.text!.isEmpty {
                calculateFinal()
            }
        case hole5:
            calculatePar()
            if !score5.text!.isEmpty {
                calculateFinal()
            }
        case hole6:
            calculatePar()
            if !score6.text!.isEmpty {
                calculateFinal()
            }
        case hole7:
            calculatePar()
            if !score7.text!.isEmpty {
                calculateFinal()
            }
        case hole8:
            calculatePar()
            if !score8.text!.isEmpty {
                calculateFinal()
            }
        case hole9:
            calculatePar()
            if !score9.text!.isEmpty {
                calculateFinal()
            }
        case score1:
            calculateScore()
            if !hole1.text!.isEmpty {
                calculateFinal()
            }
        case score2:
            calculateScore()
            if !hole2.text!.isEmpty {
                calculateFinal()
            }
        case score3:
            calculateScore()
            if !hole3.text!.isEmpty {
                calculateFinal()
            }
        case score4:
            calculateScore()
            if !hole4.text!.isEmpty {
                calculateFinal()
            }
        case score5:
            calculateScore()
            if !hole5.text!.isEmpty {
                calculateFinal()
            }
        case score6:
            calculateScore()
            if !hole6.text!.isEmpty {
                calculateFinal()
            }
        case score7:
            calculateScore()
            if !hole7.text!.isEmpty {
                calculateFinal()
            }
        case score8:
            calculateScore()
            if !hole8.text!.isEmpty {
                calculateFinal()
            }
        case score9:
            calculateScore()
            if !hole9.text!.isEmpty {
                calculateFinal()
            }
        default:
            break
        }
        textField.resignFirstResponder()
    }
}

//
//  EighteenHoleTableViewController.swift
//  UGolf
//
//  Created by Bryan Gomez on 10/4/21.
//

import UIKit

class EighteenHoleTableViewController: UITableViewController {
    
    //MARK: - Par Outlets
    @IBOutlet weak var parOne: UITextField!
    @IBOutlet weak var parTwo: UITextField!
    @IBOutlet weak var parThree: UITextField!
    @IBOutlet weak var parFour: UITextField!
    @IBOutlet weak var parFive: UITextField!
    @IBOutlet weak var parSix: UITextField!
    @IBOutlet weak var parSeven: UITextField!
    @IBOutlet weak var parEight: UITextField!
    @IBOutlet weak var parNine: UITextField!
    @IBOutlet weak var parTen: UITextField!
    @IBOutlet weak var parEleven: UITextField!
    @IBOutlet weak var parTwelve: UITextField!
    @IBOutlet weak var parThirteen: UITextField!
    @IBOutlet weak var parFourteen: UITextField!
    @IBOutlet weak var parFifteen: UITextField!
    @IBOutlet weak var parSixteen: UITextField!
    @IBOutlet weak var parSeventeen: UITextField!
    @IBOutlet weak var parEighteen: UITextField!
    @IBOutlet weak var parTotal: UITextField!
    
    //MARK: - Score Outlets
    @IBOutlet weak var scoreOne: UITextField!
    @IBOutlet weak var scoreTwo: UITextField!
    @IBOutlet weak var scoreThree: UITextField!
    @IBOutlet weak var scoreFour: UITextField!
    @IBOutlet weak var scoreFive: UITextField!
    @IBOutlet weak var scoreSix: UITextField!
    @IBOutlet weak var scoreSeven: UITextField!
    @IBOutlet weak var scoreEight: UITextField!
    @IBOutlet weak var scoreNine: UITextField!
    @IBOutlet weak var scoreTen: UITextField!
    @IBOutlet weak var scoreEleven: UITextField!
    @IBOutlet weak var scoreTwelve: UITextField!
    @IBOutlet weak var scoreThirteen: UITextField!
    @IBOutlet weak var scoreFourteen: UITextField!
    @IBOutlet weak var scoreFifteen: UITextField!
    @IBOutlet weak var scoreSixteen: UITextField!
    @IBOutlet weak var scoreSeventeen: UITextField!
    @IBOutlet weak var scoreEighteen: UITextField!
    @IBOutlet weak var scoreTotal: UITextField!
    
    //MARK: - Other
    @IBOutlet weak var finalScore: UITextField!
    @IBOutlet weak var golfCourseNameText: UITextField!
    
//MARK: - Properties
    var scoreboard: ScoreBoard?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupViews()
        UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
    }
    //MARK: - Helper functions
    func setupViews() {
        
        parOne.delegate = self
        parTwo.delegate = self
        parThree.delegate = self
        parFour.delegate = self
        parFive.delegate = self
        parSix.delegate = self
        parSeven.delegate = self
        parEight.delegate = self
        parNine.delegate = self
        parTen.delegate = self
        parEleven.delegate = self
        parTwelve.delegate = self
        parThirteen.delegate = self
        parFourteen.delegate = self
        parFifteen.delegate = self
        parSixteen.delegate = self
        parSeventeen.delegate = self
        parEighteen.delegate = self
        
        scoreOne.delegate = self
        scoreTwo.delegate = self
        scoreThree.delegate = self
        scoreFour.delegate = self
        scoreFive.delegate = self
        scoreSix.delegate = self
        scoreSeven.delegate = self
        scoreEight.delegate = self
        scoreNine.delegate = self
        scoreTen.delegate = self
        scoreEleven.delegate = self
        scoreTwelve.delegate = self
        scoreThirteen.delegate = self
        scoreFourteen.delegate = self
        scoreFifteen.delegate = self
        scoreSixteen.delegate = self
        scoreSeventeen.delegate = self
        scoreEighteen.delegate = self
        
        
        
    }
    
    func calculateFinal() {
        let finalPar = parTotal.text!
        let finalScores = scoreTotal.text!
        
        let par = Int(finalPar) ?? 0
        let score = Int(finalScores) ?? 0
        
        finalScore.text = "\(score - par)"
    }
    
    func calculatePar() {
        
        let one = parOne.text!
        let two = parTwo.text!
        let three = parThree.text!
        let four = parFour.text!
        let five = parFive.text!
        let six = parSix.text!
        let seven = parSeven.text!
        let eight = parEight.text!
        let nine = parNine.text!
        let ten = parTen.text!
        let eleven = parEleven.text!
        let twelve = parTwelve.text!
        let thirteen = parThirteen.text!
        let fourteen = parFourteen.text!
        let fifteen = parFifteen.text!
        let sixteen = parSixteen.text!
        let seventeen = parSeventeen.text!
        let eighteen = parEighteen.text!
        
        let parOne = Int(one) ?? 0
        let parTwo = Int(two) ?? 0
        let parThree = Int(three) ?? 0
        let parFour = Int(four) ?? 0
        let parFive = Int(five) ?? 0
        let parSix = Int(six) ?? 0
        let parSeven = Int(seven) ?? 0
        let parEight = Int(eight) ?? 0
        let parNine = Int(nine) ?? 0
        let parTen = Int(ten) ?? 0
        let parEleven = Int(eleven) ?? 0
        let parTwelve = Int(twelve) ?? 0
        let parThirteen = Int(thirteen) ?? 0
        let parFourteen = Int(fourteen) ?? 0
        let parFifteen = Int(fifteen) ?? 0
        let parSixteen = Int(sixteen) ?? 0
        let parSeventeen = Int(seventeen) ?? 0
        let parEighteen = Int(eighteen) ?? 0
        
        
        let totalPar = parOne + parTwo + parThree + parFour + parFive + parSix + parSeven + parEight + parNine + parTen + parEleven + parTwelve + parThirteen + parFourteen + parFifteen + parSixteen + parSeventeen + parEighteen
        
        parTotal.text = "\(totalPar)"
    }
    
    func calculateScore() {
        
        let oneS = scoreOne.text!
        let twoS = scoreTwo.text!
        let threeS = scoreThree.text!
        let fourS = scoreFour.text!
        let fiveS = scoreFive.text!
        let sixS = scoreSix.text!
        let sevenS = scoreSeven.text!
        let eightS = scoreEight.text!
        let nineS = scoreNine.text!
        let tenS = scoreTen.text!
        let elevenS = scoreEleven.text!
        let twelveS = scoreTwelve.text!
        let thirteenS = scoreThirteen.text!
        let fourteenS = scoreFourteen.text!
        let fifteenS = scoreFifteen.text!
        let sixteenS = scoreSixteen.text!
        let seventeenS = scoreSeventeen.text!
        let eighteenS = scoreEighteen.text!
        
        let scoreOne = Int(oneS) ?? 0
        let scoreTwo = Int(twoS) ?? 0
        let scoreThree = Int(threeS) ?? 0
        let scoreFour = Int(fourS) ?? 0
        let scoreFive = Int(fiveS) ?? 0
        let scoreSix = Int(sixS) ?? 0
        let scoreSeven = Int(sevenS) ?? 0
        let scoreEight = Int(eightS) ?? 0
        let scoreNine = Int(nineS) ?? 0
        let scoreTen = Int(tenS) ?? 0
        let scoreEleven = Int(elevenS) ?? 0
        let scoreTwelve = Int(twelveS) ?? 0
        let scoreThirteen = Int(thirteenS) ?? 0
        let scoreFourteen = Int(fourteenS) ?? 0
        let scoreFifteen = Int(fifteenS) ?? 0
        let scoreSixteen = Int(sixteenS) ?? 0
        let scoreSeventeen = Int(seventeenS) ?? 0
        let scoreEighteen = Int(eighteenS) ?? 0
        
        
        let totalScore =  scoreOne + scoreTwo + scoreThree + scoreFour + scoreFive + scoreSix + scoreSeven + scoreEight + scoreNine + scoreTen + scoreEleven + scoreTwelve + scoreThirteen + scoreFourteen + scoreFifteen + scoreSixteen + scoreSeventeen + scoreEighteen
        
        scoreTotal.text = "\(totalScore)"
        
        
        
    }
    
    //MARK: - Action Outlets
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("tapped")
        guard let finalScore = finalScore.text, !finalScore.isEmpty, let golfLocation = golfCourseNameText.text, !golfLocation.isEmpty else { return }
        
        let date = Date()
        let finalScoreInt = Int(finalScore)
        
        ScoreBoardController.sharedInstance.createScoreCard(score: finalScoreInt!, location: golfLocation, timestamp: date)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func editinDidChanged(_ sender: UITextField) {
        calculateScore()
    }
    
    func updateViews() {
        guard let scoreboard = scoreboard else { return }
        finalScore.text = "\(scoreboard.score)"
    }
    
//MARK: - Table delegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: - UITextFieldDelegate

extension EighteenHoleTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            
        case parOne:
            calculatePar()
            if !scoreOne.text!.isEmpty {
                calculateFinal()
            }
        case parTwo:
            calculatePar()
            if !scoreTwo.text!.isEmpty {
                calculateFinal()
            }
        case parThree:
            calculatePar()
            if !scoreThree.text!.isEmpty {
                calculateFinal()
            }
        case parFour:
            calculatePar()
            if !scoreFour.text!.isEmpty {
                calculateFinal()
            }
        case parFive:
            calculatePar()
            if !scoreFive.text!.isEmpty {
                calculateFinal()
            }
        case parSix:
            calculatePar()
            if !scoreSix.text!.isEmpty {
                calculateFinal()
            }
        case parSeven:
            calculatePar()
            if !scoreSeven.text!.isEmpty {
                calculateFinal()
            }
        case parEight:
            calculatePar()
            if !scoreEight.text!.isEmpty {
                calculateFinal()
            }
        case parNine:
            calculatePar()
            if !scoreNine.text!.isEmpty {
                calculateFinal()
            }
        case parTen:
            calculatePar()
            if !scoreTen.text!.isEmpty {
                calculateFinal()
            }
        case parEleven:
            calculatePar()
            if !scoreEleven.text!.isEmpty {
                calculateFinal()
            }
        case parTwelve:
            calculatePar()
            if !scoreTwelve.text!.isEmpty {
                calculateFinal()
            }
        case parThirteen:
            calculatePar()
            if !scoreThirteen.text!.isEmpty {
                calculateFinal()
            }
        case parFourteen:
            calculatePar()
            if !scoreFourteen.text!.isEmpty {
                calculateFinal()
            }
        case parFifteen:
            calculatePar()
            if !scoreFifteen.text!.isEmpty {
                calculateFinal()
            }
        case parSixteen:
            calculatePar()
            if !scoreSixteen.text!.isEmpty {
                calculateFinal()
            }
        case parSeventeen:
            calculatePar()
            if !scoreSeventeen.text!.isEmpty {
                calculateFinal()
            }
        case parEighteen:
            calculatePar()
            if !scoreEight.text!.isEmpty {
                calculateFinal()
            }
            
        case scoreOne:
            calculatePar()
            if !parOne.text!.isEmpty {
                calculateFinal()
            }
        case scoreTwo:
            calculatePar()
            if !parTwo.text!.isEmpty {
                calculateFinal()
            }
        case scoreThree:
            calculatePar()
            if !parThree.text!.isEmpty {
                calculateFinal()
            }
        case scoreFour:
            calculatePar()
            if !parFour.text!.isEmpty {
                calculateFinal()
            }
        case scoreFive:
            calculatePar()
            if !parFive.text!.isEmpty {
                calculateFinal()
            }
        case scoreSix:
            calculatePar()
            if !parSix.text!.isEmpty {
                calculateFinal()
            }
        case scoreSeven:
            calculatePar()
            if !parSeven.text!.isEmpty {
                calculateFinal()
            }
        case scoreEight:
            calculatePar()
            if !parEight.text!.isEmpty {
                calculateFinal()
            }
        case scoreNine:
            calculatePar()
            if !parNine.text!.isEmpty {
                calculateFinal()
            }
        case scoreTen:
            calculatePar()
            if !parTen.text!.isEmpty {
                calculateFinal()
            }
        case scoreEleven:
            calculatePar()
            if !parEleven.text!.isEmpty {
                calculateFinal()
            }
        case scoreTwelve:
            calculatePar()
            if !parTwelve.text!.isEmpty {
                calculateFinal()
            }
        case scoreThirteen:
            calculatePar()
            if !parThirteen.text!.isEmpty {
                calculateFinal()
            }
        case scoreFourteen:
            calculatePar()
            if !parFourteen.text!.isEmpty {
                calculateFinal()
            }
        case scoreFifteen:
            calculatePar()
            if !parFifteen.text!.isEmpty {
                calculateFinal()
            }
        case scoreSixteen:
            calculatePar()
            if !parSixteen.text!.isEmpty {
                calculateFinal()
            }
        case scoreSeventeen:
            calculatePar()
            if !parSeventeen.text!.isEmpty {
                calculateFinal()
            }
        case scoreEighteen:
            calculatePar()
            if !parEight.text!.isEmpty {
                calculateFinal()
            }
            
        default:
            break
        }
    }
}

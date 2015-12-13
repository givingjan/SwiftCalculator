//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Chen Yu-Chun on 2015/11/30.
//  Copyright © 2015年 Chen Yu-Chun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum LastIndexState {
        case None
        case Symbol
        case Number
        case Point
        case LeftBrackets
        case RightBrackets
    }

    @IBOutlet var m_lbResult: UILabel!
    @IBOutlet var m_lbDescribe: UILabel!
    @IBOutlet var m_aryNumbers: [UIButton]!
    
    var m_aryDataList:[String] = []
    var m_aryStack:[String] = []
    var m_aryOutput:[String] = []
    var m_eLastIndexState:LastIndexState = LastIndexState.None

    @IBOutlet var m_btPoint: UIButton!
    @IBOutlet var m_btDelete: UIButton!
    @IBOutlet var m_btEquals: UIButton!
    @IBOutlet var m_btAdd: UIButton!
    @IBOutlet var m_btSubtract: UIButton!
    @IBOutlet var m_btMultiply: UIButton!
    @IBOutlet var m_btDivide: UIButton!
    @IBOutlet var m_btAC: UIButton!
    @IBOutlet var m_btLeftBrackets: UIButton!
    @IBOutlet var m_btRightBrackets: UIButton!
    
    
    // MARK:Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.m_lbResult.text = ""
        self.m_lbDescribe.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK:Method
    @IBAction func handleTap(sender: UIButton) {
        if sender == m_btAC {
            self.m_aryDataList = []
            self.m_aryStack = []
            self.m_aryOutput = []
            
            updateUI()
            self.m_lbResult.text = ""
            self.m_eLastIndexState = LastIndexState.None

            return
        }
        
        if sender == m_btDelete {
            if self.m_aryDataList.count > 0 {
                var strLast:String = self.m_aryDataList.last as String!
                var charArray = Array(strLast.characters)
                charArray.removeLast()
                strLast = String(charArray)
                
                self.m_aryDataList[self.m_aryDataList.count-1] = strLast
                
                if charArray.count == 0 {
                    self.m_aryDataList.removeLast()
                }
            }
            
            updateUI()
            
            return
        }
        
        if sender == m_btEquals {
            getPostfix(self.m_aryDataList)
            
            return
        }
        
        if sender == m_btPoint {
            if self.m_eLastIndexState == LastIndexState.Number {
                if var str = self.m_aryDataList.last as String? {
                    str.appendContentsOf(".")
                    self.m_aryDataList[self.m_aryDataList.count-1] = str
                    self.m_eLastIndexState = LastIndexState.Point
                }
            }
            else if self.m_eLastIndexState == LastIndexState.RightBrackets ||
                    self.m_eLastIndexState == LastIndexState.Point {
                return
            }
            else {
                self.m_aryDataList.append("0.")
                self.m_eLastIndexState = LastIndexState.Point
            }
            
            updateUI()
            
            return
        }
        
        if inputIsNumbers(sender) == true {
            if self.m_aryDataList.count == 0 {
                self.m_aryDataList.append(String(sender.tag))
                self.m_eLastIndexState = LastIndexState.Number
                
                updateUI()
                
                return
            }
            
            if self.m_eLastIndexState == LastIndexState.Number ||
                self.m_eLastIndexState == LastIndexState.Point {
                if var str = self.m_aryDataList.last as String? {
                    str.appendContentsOf(String(sender.tag))
                    self.m_aryDataList[self.m_aryDataList.count-1] = str
                }
            }
            else if self.m_eLastIndexState == LastIndexState.Symbol ||
                    self.m_eLastIndexState == LastIndexState.LeftBrackets
            {
                self.m_aryDataList.append(String(sender.tag))
            }
            else {
                return
            }
            
            self.m_eLastIndexState = LastIndexState.Number
            
            updateUI()
            
            return
        }
        
        if sender == self.m_btLeftBrackets {
            if self.m_eLastIndexState == LastIndexState.Symbol ||
               self.m_eLastIndexState == LastIndexState.LeftBrackets ||
               self.m_eLastIndexState == LastIndexState.None {
                self.m_aryDataList.append("(")
                self.m_eLastIndexState = LastIndexState.LeftBrackets
                
                updateUI()
            }
            
            return
        }
        
        if sender == self.m_btRightBrackets {
            if self.m_aryDataList.count == 0 {
                return
            }
            
            if self.m_eLastIndexState == LastIndexState.Number ||
               self.m_eLastIndexState == LastIndexState.RightBrackets {
                if isRightBracketEnough() == false {
                    self.m_aryDataList.append(")")
                    self.m_eLastIndexState = LastIndexState.RightBrackets
                    
                    updateUI()
                }
            }
            return
        }
        
        self.addSymbol(sender)
    }
    
    func isRightBracketEnough() -> Bool {
        var leftCount:Int = 0
        var rightCount:Int = 0
        
        for str in self.m_aryDataList {
            if str == "(" {
                leftCount += 1
            }
            
            if str == ")" {
                rightCount += 1
            }
        }
        
        if leftCount > rightCount {
            return false
        }
        else {
            return true
        }
    }
    
    func addSymbol(btn:UIButton) {
        var strSymbol:String = ""
        
        switch(btn) {
        case self.m_btAdd:
            strSymbol = "+"
        case self.m_btSubtract:
            strSymbol = "-"
        case self.m_btMultiply:
            strSymbol = "*"
        case self.m_btDivide:
            strSymbol = "/"
        default:
            strSymbol = ""
        }
        
        if self.m_eLastIndexState == LastIndexState.Number ||
           self.m_eLastIndexState == LastIndexState.RightBrackets {
            self.m_aryDataList.append(strSymbol)
            self.m_eLastIndexState = LastIndexState.Symbol
        }
        else if self.m_eLastIndexState == LastIndexState.Symbol
        {
            self.m_aryDataList[self.m_aryDataList.count-1] = strSymbol
        }
        else {
            return
        }
        
        self.m_eLastIndexState = LastIndexState.Symbol
        
        updateUI()
    }
    


    func inputIsNumbers (sender:UIButton) -> Bool{
        for btn in m_aryNumbers {
            if btn == sender {
                return true
            }
        }
        return false
    }
    
    func updateUI() {
        var strLabel = ""
        
        for str in self.m_aryDataList {
            strLabel.appendContentsOf(" "+str+" ")
        }
        
        self.m_lbDescribe.text = strLabel
        print(self.m_aryDataList)
    }
    
    func isOperators(str:String) -> (Bool){
        if str == "+" || str == "-" || str == "*" || str == "/" {
            return true
        }
        else {
            return false
        }
    }
    
    func getResult() {
        if self.m_aryOutput.count >= 3 {
            var str:String = ""
            var strN1:String = ""
            var strN2:String = ""
            var i:Int = 0
            Out:for i = 0 ; i < self.m_aryOutput.count ; i++ {
                str = self.m_aryOutput[i]
                if isOperators(str) {
                    strN1 = self.m_aryOutput[i-2]
                    strN2 = self.m_aryOutput[i-1]
                    break Out
                }
            }
            
            var n1:Double = 0.0
            var n2:Double = 0.0
            
            if let fN1:Double = Double(strN1) {
                n1 = fN1
            }
            if let fN2:Double = Double(strN2) {
                n2 = fN2
            }
            
            let result:Double = doCalculator(str, n1: n1, n2: n2)
            let newArray = [String(result)]
            self.m_aryOutput[i-2..<i+1] = ArraySlice(newArray)
            
            getResult()
        }
        else {
            // if result is Integer. should not show "."
            let str:String = self.m_aryOutput[0]
            var charAry = Array(str.characters)
            if charAry[charAry.count-1] == "0" && charAry[charAry.count-2] == "." {
                charAry.removeRange(charAry.count-2..<charAry.count)
            }
            print("Final Result = \(self.m_aryOutput[0])")
            self.m_lbResult.text = String(charAry)
            self.m_aryOutput = [] // clear array for next calculator.
        }
        
    }
    
    ///  Transfer to Postfix
    func getPostfix(aryList:Array<String>) {
        let aryTemp = aryList
        var strInput:String = ""
        var icp:Int = 0 // In Comming Priority
        var isp:Int = -1 // In Stack Priority
        
        for var i = 0 ; i < aryTemp.count ; i++ {
            strInput = aryTemp[i]
            icp = getInCommingPriority(strInput)
            
            if icp == 0 {
                // if priority is 0, just output
                self.m_aryOutput.append(strInput)
                print("IN TO OUTPUT :\(strInput)")
            }
            else if strInput == ")" {
                while self.m_aryStack.last as String! != "(" {
                    popStack()
                }
                self.m_aryStack.removeLast()  // 移除 "("
            }
            else {
                // compare priorty with stack last index
                if let strLast = self.m_aryStack.last {
                    isp = getInStackPriority(strLast)
                }
                else {
                    isp = -1
                }
                
                while isp >= icp {
                    popStack()
                    if let strLast = self.m_aryStack.last {
                        isp = getInStackPriority(strLast)
                    }
                    else {
                        isp = -1
                    }
                }
                pushStack(strInput)
            }
        }
        while self.m_aryStack.count != 0 {
            popStack()
        }
        
        print("FINAL STACK:\(self.m_aryStack)")
        print("FINAL OUTPUT:\(self.m_aryOutput)")
        getResult()
    }
    
    
    func popStack() {
        let strLastStack = self.m_aryStack.last as String!
        self.m_aryOutput.append(strLastStack)
        self.m_aryStack.removeLast()
        
        print("POP TO OUTPUT:\(strLastStack)")
    }
    
    func pushStack(strPush:String) {
        self.m_aryStack.append(strPush)
        print("PUSH:\(self.m_aryStack)")
    }
    
    
    func getInStackPriority(strCal:String) ->(Int) {
        var iPriority:Int
        switch(strCal) {
        case "(":
            iPriority = 0
        case "+":
            iPriority = 1
        case "-":
            iPriority = 1
        case "*":
            iPriority = 2
        case "/":
            iPriority = 2
        default:
            iPriority = 0
        }
        
        return iPriority
    }

    
    func getInCommingPriority(strCal:String) ->(Int) {
        var iPriority:Int
        switch(strCal) {
        case "+":
            iPriority = 1
        case "-":
            iPriority = 1
        case "*":
            iPriority = 2
        case "/":
            iPriority = 2
        case "(":
            iPriority = 3
        case ")":
            iPriority = 3
        default:
            iPriority = 0
        }
        
        return iPriority
    }

    func doCalculator(kType:String,n1:Double,n2:Double) -> (Double) {
        var result:Double = 0.0
        switch(kType) {
            case "+":
            result = n1 + n2
            case "-":
            result = n1 - n2
            case "*":
            result = n1*n2
            case "/":
            result = n1/n2
            default:
            print("default")
        }
        
        return result
    }
}


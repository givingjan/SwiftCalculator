//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Chen Yu-Chun on 2015/11/30.
//  Copyright © 2015年 Chen Yu-Chun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var m_lbResult: UILabel!
    @IBOutlet var m_lbDescribe: UILabel!
    var m_aryDataList:[String] = []
    var m_strDescribe:String = ""
    var m_bIsNumber = false
    

    // all button have thier own tag in Main.storyboard. 
    // just define for easy to read.

    @IBOutlet var m_btEquals: UIButton!
    @IBOutlet var m_btAdd: UIButton!
    @IBOutlet var m_btSubtract: UIButton!
    @IBOutlet var m_btMultiply: UIButton!
    @IBOutlet var m_btDivide: UIButton!
    @IBOutlet var m_btAC: UIButton!
    @IBOutlet weak var m_btBracketsLeft: UIButton!
    @IBOutlet weak var m_btBracketsRight: UIButton!
    // include all number and "." , "+/-"
    @IBOutlet var aryNumbers: [UIButton]!
    
    @IBAction func handleTap(sender: UIButton) {
        
        
        // clear all
        if sender == m_btAC {
            self.m_aryDataList = []
            self.m_strDescribe = ""
            updateUI()
            return
        }
        if isNumber(sender) == true {
            self.m_strDescribe.appendContentsOf(String(sender.tag))
        }
        
        if sender == m_btEquals {
            checkCalculator()
        }
        
        if sender == m_btAdd {
            self.m_strDescribe.appendContentsOf(" + ")
        }
        
        if sender == m_btSubtract {
            self.m_strDescribe.appendContentsOf(" - ")
        }
        
        if sender == m_btMultiply {
            self.m_strDescribe.appendContentsOf(" × ")
        }
        
        if sender == m_btDivide {
            self.m_strDescribe.appendContentsOf(" ÷ ")
        }
        
        if sender == m_btBracketsLeft {
            self.m_strDescribe.appendContentsOf(" ( ")
        }
        
        if sender == m_btBracketsRight {
            self.m_strDescribe.appendContentsOf(" ) ")
        }
        
        updateUI()
    }
    
    func isNumber(sender:UIButton) -> Bool{
        for btn in aryNumbers {
            if btn == sender {
                return true
            }
        }
        
        return false
    }
    
    func updateUI() {
        self.m_lbDescribe.text = self.m_strDescribe
    }
    
    func checkCalculator() {
//        var result:Int = 0
//        var index:Int = 0
//        var aryTokens:Array<Array<String>> = []
//        // ×
//        for strToken:String in self.m_aryDataList {
//            if strToken == String(kBtnMultiply) || strToken == String(kBtnDivide) {
//                let n1:Int = Int(self.m_aryDataList[index-1])!
//                let n2:Int = Int(self.m_aryDataList[index+1])!
//                let iToken:Int = Int(strToken)!
//                
//                let aryTemp:Array<String> = [self.m_aryDataList[index-1],self.m_aryDataList[index],self.m_aryDataList[index+1]];
//                aryTokens.append(aryTemp)
//            }
//            index++
//        }
//        
//        print(aryTokens)
        
        // ÷
    }
    
    func doCalculator(kType:Int,n1:Int,n2:Int) -> (Int) {
//        switch(kType) {
//        case kBtnMultiply:
//            return n1*n2
//        case kBtnDivide:
//            return n1/n2
//        case kBtnAdd:
//            return n1+n2
//        case kBtnSubtract:
//            return n1-n2
//        default:
//            return 0
//        }
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


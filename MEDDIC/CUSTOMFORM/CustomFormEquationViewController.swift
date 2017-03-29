//
//  ResultViewController.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/24/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class CustomFormEquationViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout {
    struct Equation{
        var type :String = ""
        var value :String = ""
        var color : Int = 0
    }
    var system = BackSystem()
    var helper = Helper()
    var section = CustomFormSection()
    var equation = [Equation]()
    var sectionIndex : Int!
    var index : Int!
    var color = Color()
    var cusForm = CustomForm()
    let sectionInsets = UIEdgeInsets(top: 1, left:1, bottom: 1, right: 1)
    var function = ["+","-","x","÷","(",")","del"]
    var number = ["7","8","9","4","5","6","1","2","3",".","0","≡"]
    var width = [CGFloat]()
    var isSection = true
    var inNumber = false
    var openCount = 0
    var closeCount = 0
    var back = BackCustomForm()
    var api = APIAddCustomForm()
    @IBOutlet weak var vwAlert: UIView!
    @IBOutlet weak var btn_section: UIButton!
    @IBOutlet weak var btn_number: UIButton!
    @IBOutlet weak var collectionQuestion: UICollectionView!
    @IBOutlet weak var collectionNumber: UICollectionView!
    @IBOutlet weak var collectionShow: UICollectionView!
    @IBOutlet weak var collectionFunction: UICollectionView!
    @IBOutlet weak var tableSection: UITableView!
    @IBAction func btn_done_action(_ sender: UIButton) {
        var formula = [String]()
        for i in 0..<self.equation.count{
            if self.equation[i].value != "" {
                if self.equation[i].type == "section"{
                    formula.append("$"+self.equation[i].value)
                }else if self.equation[i].type == "function"{
                    if self.equation[i].value == "x"{
                        formula.append("*")
                    }else if self.equation[i].value == "÷"{
                        formula.append("/")
                    }else{
                        formula.append(self.equation[i].value)
                    }
                }else{
                    formula.append(self.equation[i].value)
                }
                
            }
        }
        if isSection{
            self.api.updateCFCoverFormula(sessionid: self.system.getSessionid(), cusformid: self.cusForm.id, formula: formula, success: {(success) in
                print(success)
                //self.back.updateFormulaForCusform(cusform: self.cusForm, equation: self.equation)
                self.performSegue(withIdentifier: "done", sender: self)
            }, failure: {(error) in
                
            })
            
        }else{
            if self.index != nil{
                self.sectionIndex = self.index
            }
            //self.backQuestion.updateEquation(section: (self.cusForm.section[UInt(self.sectionIndex)] as! CustomFormSection), equation:self.equation)
            self.performSegue(withIdentifier: "doneQuestion", sender: self)
        }
        
    }
    @IBAction func btn_section(_ sender: UIButton) {
        self.collectionQuestion.isHidden = true
        self.btn_section.isHidden = true
    }
    @IBAction func btn_number_action(_ sender: UIButton) {
        self.btn_number.isHidden = true
        collectionNumber.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let button: UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(addNew), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:0, y:0, width:50, height:40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view.
    }
    func addNew(sender:UIButton){
        var formula = [String]()
        for i in 0..<self.equation.count{
            if self.equation[i].value != "" {
                if self.equation[i].type == "section"{
                    formula.append("$"+self.equation[i].value)
                }else if self.equation[i].type == "function"{
                    if self.equation[i].value == "x"{
                        formula.append("*")
                    }else if self.equation[i].value == "÷"{
                        formula.append("/")
                    }else{
                        formula.append(self.equation[i].value)
                    }
                }else{
                    formula.append(self.equation[i].value)
                }
                
            }
        }
        if isSection{
            self.api.updateCFCoverFormula(sessionid: self.system.getSessionid(), cusformid: self.cusForm.id, formula: formula, success: {(success) in
                if let content = success.value(forKey: "content") as? NSDictionary{
                    if let updatetime = content.value(forKey: "updatetime") as? String{
                        self.back.updateFormulaForCusform(cusform: self.cusForm, equation: self.equation,updatetime:updatetime)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }, failure: {(error) in
                
            })
            
        }else{
            if self.index != nil{
                self.sectionIndex = self.index
            }
            self.api.updateCFSectionFormula(sessionid: self.system.getSessionid(), sectionid: self.cusForm.section[self.sectionIndex].id, cusformid: self.cusForm.id, formula: formula, success: {(success) in
                if let content = success.value(forKey: "content") as? NSDictionary{
                    if let updatetime = content.value(forKey: "updatetime") as? String{
                        self.back.updateFormulaForSection(cusform: self.cusForm, section: self.cusForm.section[self.sectionIndex], equation: self.equation, updatetime: updatetime)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }, failure: {(error) in
                
            })
            //self.backQuestion.updateEquation(section: (self.cusForm.section[UInt(self.sectionIndex)] as! CustomFormSection), equation:self.equation)
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionShow.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.equation = [Equation]()
        if self.isSection{
            // for i in 0..<self.cusForm.equation.count{
            //    var eq = Equation()
            //  eq.color = (self.cusForm.equation[i] as! Equation).color
            //eq.type =   (self.cusForm.equation[i] as! Equation).type
            //eq.value = (self.cusForm.equation[i] as! Equation).value
            //    self.equation.append(eq)
            //}
            self.transferStringToEvaluationForm()
            self.setWidth()
            self.collectionShow.reloadData()
            self.btn_number.layer.cornerRadius = 20
            self.btn_number.layer.masksToBounds = true
            self.btn_section.layer.cornerRadius = 20
            self.btn_section.layer.masksToBounds = true
            self.collectionNumber.isHidden = true
            if self.isSection{
                self.title = "Section Equation"
                self.btn_section.isHidden = true
                self.collectionQuestion.isHidden = true
            }else{
                self.title = "Question Equation"
                self.collectionQuestion.reloadData()
                self.btn_section.isHidden = false
                self.collectionQuestion.isHidden = false
            }
            self.vwAlert.layer.cornerRadius = 20
            self.vwAlert.layer.masksToBounds = true
        }else{
            self.transferStringToEvaluationForm()
            self.setWidth()
            self.collectionShow.reloadData()
            self.btn_number.layer.cornerRadius = 20
            self.btn_number.layer.masksToBounds = true
            self.btn_section.layer.cornerRadius = 20
            self.btn_section.layer.masksToBounds = true
            self.collectionNumber.isHidden = true
            if self.isSection{
                self.title = "Section Equation"
                self.btn_section.isHidden = true
                self.collectionQuestion.isHidden = true
            }else{
                self.title = "Question Equation"
                self.collectionQuestion.reloadData()
                self.btn_section.isHidden = false
                self.collectionQuestion.isHidden = false
            }
            self.vwAlert.layer.cornerRadius = 20
            self.vwAlert.layer.masksToBounds = true
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.isSection{
            var eq = Equation()
            eq.color = self.cusForm.section[indexPath.row].colorMain
            eq.type = "section"
            eq.value = String(indexPath.row+1)
            if self.checkForNumber(type: eq.type, index: self.findCurser()){
                self.insertEquation(eq: eq)
                self.setWidth()
                self.collectionShow.reloadData()
                let lastItemIndex = IndexPath(row: self.findCurser(), section: 0)
                self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
            }else{
                self.vwAlert.isHidden = false
                self.helper.delay(2){
                    self.vwAlert.isHidden = true
                }
            }
        }else{
            self.index = self.sectionIndex
            self.sectionIndex = indexPath.row
            self.collectionQuestion.reloadData()
            self.btn_section.isHidden = false
            self.collectionQuestion.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cusForm.section.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let vw = cell.viewWithTag(1)
        vw?.backgroundColor = UIColor(netHex: self.cusForm.section[indexPath.row].colorMain)
        let number = cell.viewWithTag(2) as! UILabel
        number.text = String(indexPath.row+1)
        let title = cell.viewWithTag(3) as! UILabel
        title.text = self.cusForm.section[indexPath.row].sectionName
        let des = cell.viewWithTag(4) as! UILabel
        des.text = self.cusForm.section[indexPath.row].des
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2 {
            return function.count
        }else if collectionView.tag == 1{
            return equation.count
        }else if collectionView.tag == 3{
            return number.count
        }else{
            if self.cusForm.section.count > 0 {
                return self.cusForm.section[self.sectionIndex].form.count
            }else{
                return 0
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let lb = cell.viewWithTag(1) as! UILabel
            lb.text = self.function[indexPath.row]
            return cell
        }else if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowEquationCollectionViewCell
            let vw = cell.vw_background
            vw?.layer.cornerRadius = 2
            vw?.layer.masksToBounds = true
            let lb = cell.lb_text as UILabel
            let curser = cell.lb_curser as UILabel
            if self.equation[indexPath.row].type == "function"{
                vw?.backgroundColor = UIColor.white
                lb.textColor = UIColor.black
                curser.isHidden = true
            }else if self.equation[indexPath.row].type == "section"{
                vw?.backgroundColor = UIColor(netHex: self.equation[indexPath.row].color)
                lb.textColor = UIColor.white
                curser.isHidden = true
            }else if self.equation[indexPath.row].type == "curser"{
                vw?.backgroundColor = UIColor.white
                curser.isHidden = false
            }else if self.equation[indexPath.row].type == "blank"{
                vw?.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
                curser.isHidden = true
            }else if self.equation[indexPath.row].type == "number"{
                vw?.backgroundColor = UIColor.white
                curser.isHidden = true
                lb.textColor = UIColor.black
            }
            lb.text = self.equation[indexPath.row].value
            cell.setWidth()
            return cell
        }else if collectionView.tag == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let lb = cell.viewWithTag(1) as! UILabel
            lb.text = self.number[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let vw_number = cell.viewWithTag(1)
            let lb_number = cell.viewWithTag(2) as! UILabel
            let img_type = cell.viewWithTag(3) as! UIImageView
            let lb_text = cell.viewWithTag(4) as! UILabel
            let vw_border = cell.viewWithTag(5)
            let img_star = cell.viewWithTag(8) as! UIImageView
            vw_number?.backgroundColor = UIColor(netHex: self.cusForm.section[self.sectionIndex].colorMain)
            lb_number.text = String(indexPath.row+1)
            img_type.image = UIImage(named: self.cusForm.section[self.sectionIndex].form[indexPath.row].type)
            lb_text.text = self.cusForm.section[self.sectionIndex].form[indexPath.row].question
            vw_border?.layer.cornerRadius = 3
            vw_border?.layer.masksToBounds = true
            vw_border?.backgroundColor = UIColor(netHex: self.cusForm.section[self.sectionIndex].colorMain)
            if self.cusForm.section[self.sectionIndex].form[indexPath.row].required{
                img_star.isHidden = false
            }else{
                img_star.isHidden = true
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            if self.function[indexPath.row] == "del"{
                if findCurser() != 0 {
                    if self.equation[self.findCurser()-1].value == "("{
                        self.openCount -= 1
                    }else if self.equation[self.findCurser()-1].value == ")"{
                        self.closeCount -= 1
                    }
                    
                    self.equation.remove(at: self.findCurser()-1)
                }
                self.inNumber = false
                self.setWidth()
                self.collectionShow.reloadData()
                let lastItemIndex = IndexPath(row: findCurser(), section: 0)
                self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
                
            }else{
                var eq = Equation()
                eq.type = "function"
                eq.value = self.function[indexPath.row]
                if self.checkForFunction(type: eq.type, index: self.findCurser(), value: eq.value){
                    if eq.value == "("{
                        self.openCount+=1
                    }else if eq.value == ")"{
                        self.closeCount+=1
                    }
                    self.insertEquation(eq: eq)
                    self.inNumber = false
                    self.setWidth()
                    self.collectionShow.reloadData()
                    let lastItemIndex = IndexPath(row: findCurser(), section: 0)
                    self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
                    
                }else{
                    self.vwAlert.isHidden = false
                    self.helper.delay(2){
                        self.vwAlert.isHidden = true
                    }
                }
            }
            
        }else if collectionView.tag == 1{
            self.inNumber = false
            var eq = Equation()
            eq.type = "curser"
            self.equation.insert(eq, at: indexPath.row)
            for i in 0..<self.equation.count{
                if self.equation[i].type == "curser"{
                    if i != indexPath.row{
                        self.equation.remove(at: i)
                        break
                    }
                }
            }
            self.setWidth()
            self.collectionShow.reloadData()
            let lastItemIndex = IndexPath(row: findCurser(), section: 0)
            self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
        }else if collectionView.tag == 3{
            if indexPath.row == 11 {
                self.btn_number.isHidden = false
                self.collectionNumber.isHidden = true
                self.inNumber = false
            }else{
                if inNumber{
                    self.equation[self.findCurser()-1].value =  self.equation[self.findCurser()-1].value+self.number[indexPath.row]
                    self.setWidth()
                    self.collectionShow.reloadData()
                    let lastItemIndex = IndexPath(row: findCurser(), section: 0)
                    self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
                }else{
                    self.inNumber = true
                    var eq = Equation()
                    eq.type = "number"
                    eq.value = self.number[indexPath.row]
                    if self.checkForNumber(type: eq.type, index: self.findCurser()){
                        self.insertEquation(eq: eq)
                        self.setWidth()
                        self.collectionShow.reloadData()
                        let lastItemIndex = IndexPath(row: findCurser(), section: 0)
                        self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
                    }else{
                        self.vwAlert.isHidden = false
                        self.helper.delay(2){
                            self.vwAlert.isHidden = true
                        }
                    }
                }
            }
            
        }else{
            var eq = Equation()
            self.inNumber = false
            eq.color = self.cusForm.section[self.sectionIndex].colorMain
            eq.type = "section"
            eq.value = String(sectionIndex+1)+"."+String(indexPath.row+1)
            if self.checkForNumber(type: eq.type, index: self.findCurser()){
                self.insertEquation(eq: eq)
                self.setWidth()
                self.collectionShow.reloadData()
                let lastItemIndex = IndexPath(row: self.findCurser(), section: 0)
                self.collectionShow.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
            }else{
                self.vwAlert.isHidden = false
                self.helper.delay(2){
                    self.vwAlert.isHidden = true
                }
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 2 {
            let paddingSpace = sectionInsets.left * (6 + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 7
            return CGSize(width: widthPerItem, height: 50)
        }else if collectionView.tag == 1{
            return CGSize(width: self.width[indexPath.row]+10, height: 100)
        }else if collectionView.tag == 3{
            return CGSize(width: (self.view.frame.width/3)-2, height: (collectionView.frame.height/4)-2)
        }else{
            let paddingSpace = sectionInsets.left * (2 + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem, height: widthPerItem+20)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func insertEquation(eq:Equation){
        var index = 0
        for i in 0..<equation.count{
            if equation[i].type == "curser"{
                index = i
                break
            }
        }
        equation.insert(eq, at: index)
    }
    func setWidth(){
        self.width = [CGFloat]()
        for i in 0..<equation.count{
            if self.equation[i].value != ""{
                let count = self.equation[i].value.characters.count
                self.width.append(CGFloat(((count-1)*10)+40))
            }else{
                self.width.append(40)
            }
        }
    }
    func findCurser() -> Int{
        for i in 0..<equation.count{
            if equation[i].type == "curser"{
                return i
            }
        }
        return 0
    }
    func checkForNumber(type:String,index:Int) ->Bool{
        if index == 0 {
            if self.equation.count > 2{
                if self.equation[index+1].type == "function"{
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }else{
            if (self.equation[index+1].type == "function" || self.equation[index+1].type == "blank") && (self.equation[index-1].type == "function" ){
                return true
            }else{
                return false
            }
        }
    }
    func checkForFunction(type:String,index:Int,value:String) ->Bool{
        if index == 0 {
            if value == "("{
                return true
            }else{
                return false
            }
        }else{
            if value == "(" || value == ")"{
                if value == "(" {
                    if self.equation[index-1].type == "function" && (self.equation[index+1].type != "function" || self.equation[index+1].value == "(") && self.equation[index-1].value != ")"{
                        return true
                    }else{
                        return false
                    }
                }else{
                    if (self.equation[index-1].type != "function" || self.equation[index-1].value == ")") && (self.equation[index+1].type == "function" || self.equation[index+1].type == "blank") && self.equation[index+1].value != "(" && self.closeCount < self.openCount{
                        return true
                    }else{
                        return false
                    }
                }
                return true
            }else{
                if self.equation[index+1].type != "function" && (self.equation[index-1].type != "function" || self.equation[index-1].value == ")"){
                    return true
                }else{
                    return false
                }
            }
        }
    }
    func transferStringToEvaluationForm(){
        self.equation = [Equation]()
        var eq = Equation()
        eq.type = "curser"
        eq.value = ""
        equation.append(eq)
        if isSection{
            for i in 0..<self.cusForm.formula.count{
                var eq = Equation()
                let str = self.cusForm.formula[i].formula
                let start = str.index(str.startIndex, offsetBy: 1)
                let end = str.index(str.endIndex, offsetBy: 0)
                let index = str.index(str.startIndex, offsetBy: 1)
                let range = start..<end
                if str.substring(to: index) == "$"{
                    eq.type = "section"
                    eq.value = str.substring(with: range)
                    eq.color = self.cusForm.section[Int(str.substring(with: range))!-1].colorMain
                }else{
                    if Double(self.cusForm.formula[i].formula) != nil{
                        eq.type = "number"
                        eq.value = self.cusForm.formula[i].formula
                    }else{
                        eq.type = "function"
                        if self.cusForm.formula[i].formula == "*"{
                            eq.value = "x"
                        }else if self.cusForm.formula[i].formula == "/"{
                            eq.value = "÷"
                        }else{
                            eq.value = self.cusForm.formula[i].formula
                        }
                    }
                }
                self.equation.append(eq)
            }
        }else{
            for i in 0..<self.section.formula.count{
                var eq = Equation()
                var str = self.section.formula[i].formula
                let start = str.index(str.startIndex, offsetBy: 1)
                let end = str.index(str.endIndex, offsetBy: 0)
                let index = str.index(str.startIndex, offsetBy: 1)
                let range = start..<end
                if str.substring(to: index) == "$"{
                    eq.type = "section"
                    eq.value = str.substring(with: range)
                    let s = str.index(str.startIndex, offsetBy: 1)
                    var e = str.index(str.endIndex, offsetBy: -1)
                    if str.characters.count == 4 {
                        e = str.index(str.endIndex, offsetBy: -2)
                    }else{
                        e = str.index(str.endIndex, offsetBy: 0)
                    }
                    let r = s..<e
                    eq.color = self.cusForm.section[Int(str.substring(with: r))!-1].colorMain
                }else{
                    if Double(self.section.formula[i].formula) != nil{
                        eq.type = "number"
                        eq.value = String(self.section.formula[i].formula)
                    }else{
                        eq.type = "function"
                        if self.section.formula[i].formula == "*"{
                            eq.value = "x"
                        }else if self.section.formula[i].formula == "/"{
                            eq.value = "÷"
                        }else{
                            eq.value = self.section.formula[i].formula
                        }
                    }
                }
                self.equation.append(eq)
            }
        }
        var eq1 = Equation()
        eq1.type = "blank"
        eq1.value = ""
        equation.append(eq1)
        self.collectionShow.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

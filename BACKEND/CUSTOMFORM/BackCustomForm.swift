//
//  BackCustomForm.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/23/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackCustomForm{
    let realm = try! Realm()
    var helper = Helper()
    var color = Color()
    let cf = try! Realm().objects(CustomForm.self)
    func createCustomForm(title:String,des:String,category:String,color:Int,icon:String,id:String,updatetime:String){
        try! realm.write {
            var customForm = CustomForm()
            customForm.id = id
            customForm.title = title
            customForm.des = des
            customForm.category = category
            customForm.color = color
            customForm.icon = icon
            customForm.updateTime = self.helper.StringToDate(date: updatetime)
            customForm.frequent = 1
            realm.add(customForm)
        }
    }
    func updateTime(updatetime:String,cusform:CustomForm){
        try! realm.write {
            cusform.updateTime = self.helper.StringToDate(date: updatetime)
        }
    }
    func updateCustomForm(title:String,des:String,category:String,color:Int,icon:String,cusForm:CustomForm,updatetime:String){
        try! realm.write {
            cusForm.title = title
            cusForm.des = des
            cusForm.category = category
            cusForm.color = color
            cusForm.icon = icon
            cusForm.updateTime = self.helper.StringToDate(date: updatetime)
            cusForm.frequent = 1
        }
    }
    func sortCustomFormBySequence() -> Results<CustomForm>{
        return realm.objects(CustomForm.self).filter(NSPredicate(format: "frequent > 0")).sorted(byProperty: "frequent",ascending:false)
    }
    func createSection(title:String,des:String,color:Int,cusForm:CustomForm,id:String){
        try! realm.write {
            let section = CustomFormSection()
            section.id = id
            section.colorMain = color
            section.sectionName = title
            section.des = des
            cusForm.section.append(section)
        }
    }
    func updateSection(title:String,des:String,color:Int,section:CustomFormSection){
        try! realm.write {
            section.colorMain = color
            section.sectionName = title
            section.des = des
        }
    }
    func createQuestion(q:String,type:String,require:Bool,option:[CustomFormOption],grid:[CustomFormGridOption],section:CustomFormSection,id:String){
        try! realm.write {
            let question = CustomFormForm()
            question.id = id
            question.question = q
            question.type = type
            question.required = require
            for i in 0..<option.count{
                if option[i].question != ""{
                    if option[i].point == ""{
                        option[i].point = "0"
                    }
                    question.option.append(option[i])
                }
            }
            for i in 0..<grid.count{
                if grid[i].question != ""{
                    question.choice.append(grid[i])
                }
            }
            section.form.append(question)
        }
    }
    func updateQuestion(q:String,type:String,require:Bool,option:[CustomFormOption],grid:[CustomFormGridOption],question:CustomFormForm){
        try! realm.write {
            question.question = q
            question.type = type
            question.required = require
            question.option.removeAll()
            for i in 0..<option.count{
                if option[i].question != ""{
                    if option[i].point == ""{
                        option[i].point = "0"
                    }
                    question.option.append(option[i])
                }
            }
            question.choice.removeAll()
            for i in 0..<grid.count{
                if grid[i].question != ""{
                    question.choice.append(grid[i])
                }
            }
        }
    }
    func updateFormulaForSection(cusform:CustomForm,section:CustomFormSection,equation:[CustomFormEquationViewController.Equation],updatetime:String){
        try! realm.write{
            cusform.updateTime = self.helper.StringToDate(date: updatetime)
            section.formula.removeAll()
            for i in 0..<equation.count{
                let f = CustomFormFormula()
                f.formula = equation[i].value
                if equation[i].value != ""{
                    if equation[i].type == "section"{
                        f.formula = "$"+f.formula
                        section.formula.append(f)
                    }else{
                        section.formula.append(f)
                    }
                }
            }
        }
    }
    func updateFormulaForCusform(cusform:CustomForm,equation:[CustomFormEquationViewController.Equation],updatetime:String){
        try! realm.write {
            cusform.updateTime = self.helper.StringToDate(date: updatetime)
            cusform.formula.removeAll()
            for i in 0..<equation.count{
                let f = CustomFormFormula()
                f.formula = equation[i].value
                if equation[i].value != ""{
                    if equation[i].type == "section"{
                        f.formula = "$"+f.formula
                        cusform.formula.append(f)
                    }else{
                        cusform.formula.append(f)
                    }
                }
            }
        }
    }
    func downloadCusForm(json:NSDictionary,form:CustomForm){
        try! realm.write{
            if let content = json.value(forKey: "content") as? NSDictionary{
                if let cusID = (content.value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                    form.id = cusID
                }
                if let title = content.value(forKey: "name") as? String{
                    form.title = title
                }
                if let des = content.value(forKey: "description") as? String{
                    form.des = des
                }
                if let title = content.value(forKey: "name") as? String{
                    form.title = title
                }
                if let color = content.value(forKey: "color") as? String{
                    if color != ""{
                        form.color = self.color.frontEndColor(color: color)
                    }
                }
                if let icon = content.value(forKey: "picurl") as? String{
                    form.icon = icon
                }
                if let formula = content.value(forKey: "formula") as? NSArray{
                    form.formula.removeAll()
                    for i in 0..<formula.count{
                        let f = CustomFormFormula()
                        f.formula = formula[i] as! String
                        form.formula.append(f)
                    }
                }
                form.isDownload = true
                if let updateTime = content.value(forKey: "updatetime") as? String{
                    form.updateTime = self.helper.StringToDate(date: updateTime)
                }
                if let owneruserid = content.value(forKey: "owneruserid") as? String{
                    form.owneruserid = owneruserid
                }
                if let sections = content.value(forKey: "sections") as? NSArray{
                    for i in 0..<sections.count{
                        var section = CustomFormSection()
                        if let sectID = ((sections[i] as! NSDictionary).value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                            section.id = sectID
                        }
                        if let color = (sections[i] as! NSDictionary).value(forKey: "color") as? String{
                            section.colorMain = self.color.frontEndColor(color: color.uppercased())
                        }
                        if let sectionName = (sections[i] as! NSDictionary).value(forKey: "name") as? String{
                            section.sectionName = sectionName
                        }
                        if let des = (sections[i] as! NSDictionary).value(forKey: "description") as? String{
                            section.des = des
                        }
                        if let formula = (sections[i] as! NSDictionary).value(forKey: "formula") as? NSArray{
                            section.formula.removeAll()
                            for i in 0..<formula.count{
                                let f = CustomFormFormula()
                                f.formula = formula[i] as! String
                                section.formula.append(f)
                            }
                            
                        }
                        if let questions = (sections[i] as! NSDictionary).value(forKey: "questions") as? NSArray{
                            for j in 0..<questions.count{
                                var question = CustomFormForm()
                                if let quesID = ((questions[j] as! NSDictionary).value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                                    question.id = quesID
                                }
                                if let required = (questions[j] as! NSDictionary).value(forKey: "required") as? Int{
                                    if required == 0 {
                                        question.required = false
                                    }else{
                                        question.required = true
                                    }
                                }
                                if let type = (questions[j] as! NSDictionary).value(forKey: "questiontype") as? Int{
                                    switch type {
                                    case 1:
                                        question.type = "checkbox"
                                    case 2:
                                        question.type = "drop"
                                    case 3:
                                        question.type = "multiple"
                                    case 4:
                                        question.type = "slider"
                                    case 5:
                                        question.type = "grid"
                                    case 6:
                                        question.type = "text"
                                    case 7:
                                        question.type = "number"
                                    case 8:
                                        question.type = "calendar"
                                    case 9:
                                        question.type = "pictures"
                                    case 10:
                                        question.type = "video"
                                    default:
                                        print("error")
                                    }
                                }
                                if let q = (questions[j] as! NSDictionary).value(forKey: "question") as? String{
                                    question.question = q
                                }
                                if let formula = (questions[j] as! NSDictionary).value(forKey: "formula") as? String{
                                    question.formula = formula
                                }
                                if let options = (questions[j] as! NSDictionary).value(forKey: "choices") as? NSArray{
                                    for k in 0..<options.count{
                                        var option = CustomFormOption()
                                        if let name = (options[k] as! NSDictionary).value(forKey: "name") as? String{
                                            option.question = name
                                        }
                                        if let score = (options[k] as! NSDictionary).value(forKey: "score") as? Double{
                                            option.point = String(score)
                                        }
                                        question.option.append(option)
                                    }
                                }
                                if let questionrows = (questions[j] as! NSDictionary).value(forKey: "questionrows") as? NSArray{
                                    for k in 0..<questionrows.count{
                                        var questionrow = CustomFormGridOption()
                                        if let name = (questionrows[k] as! NSDictionary).value(forKey: "question") as? String{
                                            questionrow.question = name
                                        }
                                        if let inversescore  = (questionrows[k] as! NSDictionary).value(forKey: "inversescore") as? Int{
                                            if inversescore == 0 {
                                                questionrow.reverse = false
                                            }else{
                                                questionrow.reverse = true
                                            }
                                            
                                        }
                                        question.choice.append(questionrow)
                                    }
                                }
                                section.form.append(question)
                            }
                        }
                        form.section.append(section)
                    }
                }
            }
        }
    }
    func showCusForm(json:NSDictionary){
        try! realm.write{
            var form = try! Realm().objects(CustomForm.self).first!
            if let content = json.value(forKey: "content") as? NSDictionary{
                if let cusID = (content.value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                    form.id = cusID
                }
                if let title = content.value(forKey: "name") as? String{
                    form.title = title
                }
                if let des = content.value(forKey: "description") as? String{
                    form.des = des
                }
                if let title = content.value(forKey: "name") as? String{
                    form.title = title
                }
                if let color = content.value(forKey: "color") as? String{
                    if color != ""{
                        form.color = self.color.frontEndColor(color: color)
                    }
                }
                if let icon = content.value(forKey: "picurl") as? String{
                    form.icon = icon
                }
                if let formula = content.value(forKey: "formula") as? NSArray{
                    for i in 0..<formula.count{
                        let f = CustomFormFormula()
                        f.formula = formula[i] as! String
                        form.formula.append(f)
                    }
                }
                form.isDownload = true
                if let updateTime = content.value(forKey: "updatetime") as? String{
                    form.updateTime = self.helper.StringToDate(date: updateTime)
                }
                if let owneruserid = content.value(forKey: "owneruserid") as? String{
                    form.owneruserid = owneruserid
                }
                form.section.removeAll()
                if let sections = content.value(forKey: "sections") as? NSArray{
                    for i in 0..<sections.count{
                        var section = CustomFormSection()
                        if let sectID = ((sections[i] as! NSDictionary).value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                            section.id = sectID
                        }
                        if let color = (sections[i] as! NSDictionary).value(forKey: "color") as? String{
                            section.colorMain = self.color.frontEndColor(color: color.uppercased())
                        }
                        if let sectionName = (sections[i] as! NSDictionary).value(forKey: "name") as? String{
                            section.sectionName = sectionName
                        }
                        if let des = (sections[i] as! NSDictionary).value(forKey: "description") as? String{
                            section.des = des
                        }
                        if let formula = (sections[i] as! NSDictionary).value(forKey: "formula") as? NSArray{
                            for i in 0..<formula.count{
                                let f = CustomFormFormula()
                                f.formula = formula[i] as! String
                                section.formula.append(f)
                            }
                            
                        }
                        if let questions = (sections[i] as! NSDictionary).value(forKey: "questions") as? NSArray{
                            for j in 0..<questions.count{
                                var question = CustomFormForm()
                                if let quesID = ((questions[j] as! NSDictionary).value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                                    question.id = quesID
                                }
                                if let required = (questions[j] as! NSDictionary).value(forKey: "required") as? Int{
                                    if required == 0 {
                                        question.required = false
                                    }else{
                                        question.required = true
                                    }
                                }
                                if let type = (questions[j] as! NSDictionary).value(forKey: "questiontype") as? Int{
                                    switch type {
                                    case 1:
                                        question.type = "checkbox"
                                    case 2:
                                        question.type = "drop"
                                    case 3:
                                        question.type = "multiple"
                                    case 4:
                                        question.type = "slider"
                                    case 5:
                                        question.type = "grid"
                                    case 6:
                                        question.type = "text"
                                    case 7:
                                        question.type = "number"
                                    case 8:
                                        question.type = "calendar"
                                    case 9:
                                        question.type = "pictures"
                                    case 10:
                                        question.type = "video"
                                    default:
                                        print("error")
                                    }
                                }
                                if let q = (questions[j] as! NSDictionary).value(forKey: "question") as? String{
                                    question.question = q
                                }
                                if let formula = (questions[j] as! NSDictionary).value(forKey: "formula") as? String{
                                    question.formula = formula
                                }
                                if let options = (questions[j] as! NSDictionary).value(forKey: "choices") as? NSArray{
                                    for k in 0..<options.count{
                                        var option = CustomFormOption()
                                        if let name = (options[k] as! NSDictionary).value(forKey: "name") as? String{
                                            option.question = name
                                        }
                                        if let score = (options[k] as! NSDictionary).value(forKey: "score") as? Double{
                                            option.point = String(score)
                                        }
                                        question.option.append(option)
                                    }
                                }
                                if let questionrows = (questions[j] as! NSDictionary).value(forKey: "questionrows") as? NSArray{
                                    for k in 0..<questionrows.count{
                                        var questionrow = CustomFormGridOption()
                                        if let name = (questionrows[k] as! NSDictionary).value(forKey: "question") as? String{
                                            questionrow.question = name
                                        }
                                        if let inversescore  = (questionrows[k] as! NSDictionary).value(forKey: "inversescore") as? Int{
                                            if inversescore == 0 {
                                                questionrow.reverse = false
                                            }else{
                                                questionrow.reverse = true
                                            }
                                            
                                        }
                                        question.choice.append(questionrow)
                                    }
                                }
                                section.form.append(question)
                            }
                        }
                        form.section.append(section)
                    }
                }
            }
        }
    }
    func downloadAnswer(success:NSDictionary,cusformListAns:CustomFormListAnswer){
        print(success)
        try! self.realm.write {
            if let content = success.value(forKey: "content") as? NSDictionary{
                let cusform = CustomForm()
                if let cusformid = content.value(forKey: "cusformid") as? String{
                    cusform.id = cusformid
                }
                if let color = content.value(forKey: "color") as? String{
                    cusform.color = self.color.frontEndColor(color: color)
                }
                if let cusfdescription = content.value(forKey: "cusfdescription") as? String{
                    cusform.des = cusfdescription
                }
                if let cusformname = content.value(forKey: "cusformname") as? String{
                    cusform.title = cusformname
                }
                if let owneruserid = content.value(forKey: "owneruserid") as? String{
                    cusform.owneruserid = owneruserid
                }
                if let picurl = content.value(forKey: "picurl") as? String{
                    cusform.icon = picurl
                }
                cusform.isAnswer = true
                if let details = content.value(forKey: "detail") as? NSArray{
                    for i in 0..<details.count{
                        var section = CustomFormSection()
                        var cusform_section_answer = CustomFormSectionAns()
                        if let detail = details[i] as? NSDictionary{
                            if let sectionid = detail.value(forKey: "sectionid") as? String{
                                section.id = sectionid
                            }
                            if let sectionname = detail.value(forKey: "sectionname") as? String{
                                section.sectionName = sectionname
                            }
                            if let answers = detail.value(forKey: "answers") as? NSArray{
                                for j in 0..<answers.count{
                                    var question = CustomFormForm()
                                    var cusform_answer = CustomFormAnswer()
                                    if let answer = answers[j] as? NSDictionary{
                                        if let type = answer.value(forKey: "qtype") as? Int{
                                            switch type {
                                            case 1:
                                                question.type = "checkbox"
                                                if let choices = answer.value(forKey: "choices") as? NSArray{
                                                    for k in 0..<choices.count{
                                                        if let choice = choices[k] as? NSDictionary{
                                                            var option = CustomFormOption()
                                                            if let name = choice.value(forKey: "name") as? String{
                                                                option.question = name
                                                            }
                                                            if let score = choice.value(forKey: "score") as? Double{
                                                                option.point = String(score)
                                                            }
                                                            question.option.append(option)
                                                        }
                                                        
                                                    }
                                                }
                                                if let ans = answer.value(forKey: "ans") as? NSArray{
                                                    for l in 0..<ans.count{
                                                        var checked = Checked()
                                                        checked.answer = String(ans[l] as! Int)
                                                        cusform_answer.checked.append(checked)
                                                    }
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 2:
                                                question.type = "drop"
                                                if let choices = answer.value(forKey: "choices") as? NSArray{
                                                    for k in 0..<choices.count{
                                                        if let choice = choices[k] as? NSDictionary{
                                                            var option = CustomFormOption()
                                                            if let name = choice.value(forKey: "name") as? String{
                                                                option.question = name
                                                            }
                                                            if let score = choice.value(forKey: "score") as? Double{
                                                                option.point = String(score)
                                                            }
                                                            question.option.append(option)
                                                        }
                                                    }
                                                }
                                                if let ans = answer.value(forKey: "ans") as? Int{
                                                    
                                                        cusform_answer.answer = String(ans)
                                                    
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 3:
                                                question.type = "multiple"
                                                if let choices = answer.value(forKey: "choices") as? NSArray{
                                                    for k in 0..<choices.count{
                                                        if let choice = choices[k] as? NSDictionary{
                                                            var option = CustomFormOption()
                                                            if let name = choice.value(forKey: "name") as? String{
                                                                option.question = name
                                                            }
                                                            if let score = choice.value(forKey: "score") as? Double{
                                                                option.point = String(score)
                                                            }
                                                            question.option.append(option)
                                                        }
                                                        
                                                    }
                                                }
                                                if let ans = answer.value(forKey: "ans") as? Int{
                                                    
                                                        var checked = Checked()
                                                        checked.answer = String(ans)
                                                        cusform_answer.checked.append(checked)
                                                    
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 4:
                                                question.type = "slider"
                                                if let choices = answer.value(forKey: "choices") as? NSArray{
                                                    for k in 0..<choices.count{
                                                        if let choice = choices[k] as? NSDictionary{
                                                            var option = CustomFormOption()
                                                            if let name = choice.value(forKey: "name") as? String{
                                                                option.question = name
                                                            }
                                                            if let score = choice.value(forKey: "score") as? Double{
                                                                option.point = String(score)
                                                            }
                                                            question.option.append(option)
                                                        }
                                                        
                                                    }
                                                }
                                                if let ans = answer.value(forKey: "ans") as? Double{
                                                    cusform_answer.answer = String(ans)
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 5:
                                                question.type = "grid"
                                                if let choices = answer.value(forKey: "choices") as? NSArray{
                                                    for k in 0..<choices.count{
                                                        if let choice = choices[k] as? NSDictionary{
                                                            var option = CustomFormOption()
                                                            if let name = choice.value(forKey: "name") as? String{
                                                                option.question = name
                                                            }
                                                            if let score = choice.value(forKey: "score") as? Double{
                                                                option.point = String(score)
                                                            }
                                                            question.option.append(option)
                                                        }
                                                        
                                                    }
                                                }
                                                if let qrows = answer.value(forKey: "choices") as? NSArray{
                                                    for k in 0..<qrows.count{
                                                        if let qrow = qrows[k] as? NSDictionary{
                                                            var grid = CustomFormGridOption()
                                                            if let name = qrow.value(forKey: "name") as? String{
                                                                grid.question = name
                                                            }
                                                            if let inversescore = qrow.value(forKey: "inversescore") as? Bool{
                                                                grid.reverse = inversescore
                                                            }
                                                            question.choice.append(grid)
                                                        }
                                                        
                                                    }
                                                }
                                                if let ans = answer.value(forKey: "ans") as? NSArray{
                                                    for l in 0..<ans.count{
                                                        var answerGrid = CustomFormAnswer()
                                                        var checked = Checked()
                                                        checked.answer = String((ans[l] as! NSDictionary).value(forKey: "ans") as! Int)
                                                        answerGrid.checked.append(checked)
                                                        cusform_answer.answerGrid.append(answerGrid)
                                                    }
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 6:
                                                question.type = "text"
                                                if let ans = answer.value(forKey: "ans") as? String{
                                                    cusform_answer.answer = ans
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 7:
                                                question.type = "number"
                                                if let ans = answer.value(forKey: "ans") as? Double{
                                                    cusform_answer.answer = String(ans)
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 8:
                                                question.type = "calendar"
                                                if let ans = answer.value(forKey: "ans") as? NSArray{
                                                    if let a = ans[0] as? String{
                                                        cusform_answer.answer = a
                                                    }
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 9:
                                                question.type = "pictures"
                                                
                                                if let ans = answer.value(forKey: "picurl") as? String{
                                                    cusform_answer.answer = ans
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            case 10:
                                                question.type = "video"
                                                
                                                if let ans = answer.value(forKey: "ans") as? NSDictionary{
                                                    if let url = ans.value(forKey: "youtubeurl") as? String{
                                                        cusform_answer.answer = url
                                                    }
                                                    
                                                }
                                                cusform_section_answer.answer.append(cusform_answer)
                                            default:
                                                print("error")
                                            }
                                        }
                                        if let questionname = answer.value(forKey: "question") as? String{
                                            question.question = questionname
                                        }
                                        if let require = answer.value(forKey: "required") as? Bool{
                                            question.required = require
                                        }
                                        if let questionid = answer.value(forKey: "questionid") as? String{
                                            question.id = questionid
                                        }
                                    }
                                    section.form.append(question)
                                }
                                cusformListAns.customform_section_answer.append(cusform_section_answer)
                                cusform.section.append(section)
                            }
                            
                        }
                        
                    }
                    cusformListAns.customform = cusform
                }
            }
        }
    }
    func downloadCoverCusForm(json:NSDictionary){
        try! realm.write{
            if let array = json.value(forKey: "content") as? NSArray{
                for i in 0..<array.count{
                    if let content = array[i] as? NSDictionary{
                        var form = CustomForm()
                        var idd = ""
                        if let cusID = (content.value(forKey: "_id") as! NSDictionary).value(forKey: "$id") as? String{
                            if self.findCustomForm(id: cusID) != nil{
                                form = self.findCustomForm(id: cusID)!
                            }
                            form.id = cusID
                            idd = cusID
                        }
                        if let title = content.value(forKey: "name") as? String{
                            form.title = title
                        }
                        if let des = content.value(forKey: "description") as? String{
                            form.des = des
                        }
                        if let title = content.value(forKey: "name") as? String{
                            form.title = title
                        }
                        if let color = content.value(forKey: "color") as? String{
                            if color != ""{
                                form.color = self.color.frontEndColor(color: color)
                            }
                        }
                        if let icon = content.value(forKey: "picurl") as? String{
                            form.icon = icon
                        }
                        if let formula = content.value(forKey: "formula") as? NSArray{
                            for i in 0..<formula.count{
                                let f = CustomFormFormula()
                                f.formula = formula[i] as! String
                                form.formula.append(f)
                            }
                        }
                        if let updateTime = content.value(forKey: "updatetime") as? String{
                            form.updateTime = self.helper.StringToDate(date: updateTime)
                        }
                        if let owneruserid = content.value(forKey: "owneruserid") as? String{
                            form.owneruserid = owneruserid
                        }
                        if let perm = content.value(forKey: "perm") as? String{
                            form.perm = perm
                        }
                        if self.findCustomForm(id: idd) == nil{
                            realm.add(form)
                        }
                    }
                    
                }
            }
        }
    }
    //GET
    func filterAnswer() ->Results<CustomForm>{
        return realm.objects(CustomForm.self).filter(NSPredicate(format: "isAnswer == false"))
    }
    func getLastUpdate() ->Date?{
        return try! Realm().objects(CustomForm.self).sorted(byProperty: "updateTime", ascending: false).first?.updateTime
    }
    func findCustomForm(id:String) ->CustomForm?{
        return realm.objects(CustomForm.self).filter(NSPredicate(format: "id == %@", id)).first
    }
    func getQuestionText(section:CustomFormSection,index:Int) ->String{
        return section.form[index].question
    }
    func getQuestionRequired(section:CustomFormSection,index:Int) -> Bool{
        return section.form[index].required
    }
}

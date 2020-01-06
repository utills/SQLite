//
//  AlertUtill.swift
//  HelloCordova
//
//  Created by Vivek Kumar on 5/2/18.
//

import UIKit
class AlertUtil: NSObject ,UITextFieldDelegate{
    static let shared = AlertUtil()
    
    func showAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title:String,message:String,okTitle:String,cancelTitle:String,completion:@escaping((Bool)->Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: {(alert:UIAlertAction) in
            completion(true)
        })
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive, handler: {(alert:UIAlertAction) in
            completion(false)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var okAction = UIAlertAction(title: "", style: .default, handler: nil)
    var cancelAction = UIAlertAction(title: "", style: .default, handler: nil)
    var textValue = ""
    var secondTextValue = ""
    
    func alertWithTextField(parent:UIViewController,title:String,message:String,placeholder:String,value:String,proceedTitle:String,cancelTitle:String,didProceed:@escaping ((String)->Void),didCancel:(()->Void)?) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.okAction = UIAlertAction(title: proceedTitle, style: .default) { (alertAction) in
            didProceed(self.textValue)
        }
        self.cancelAction = UIAlertAction(title: cancelTitle, style: .default){(alertAction) in
            if let cancelCallBack = didCancel{
                cancelCallBack()
            }
        }
        alert.addTextField { (textField) in
            textField.tag = 1
            if(value != ""){
                textField.text = value
            }else{
                textField.placeholder = placeholder
            }
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        }
        self.alert.addAction(self.cancelAction)
        self.alert.addAction(self.okAction)
        
        okAction.isEnabled = false
        parent.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(textField:UITextField){
        if(textField.tag == 1){
            if let text = textField.text{
                if(text == ""){
                    self.okAction.isEnabled = false
                }else{
                    self.textValue = text
                    self.okAction.isEnabled = true
                }
            }else{
                self.okAction.isEnabled = false
            }
        }
        if(textField .tag == 2){
            if let text = textField.text{
                self.secondTextValue = text
            }
        }
        
    }
    
    func alertWithTwoTextField(parent:UIViewController,title:String,message:String,placeholder1:String,value1:String,placeholder2:String,value2:String,proceedTitle:String,cancelTitle:String,didProceed:@escaping ((String,String)->Void),didCancel:(()->Void)?) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.okAction = UIAlertAction(title: proceedTitle, style: .default) { (alertAction) in
            didProceed(self.textValue,self.secondTextValue)
        }
        self.cancelAction = UIAlertAction(title: cancelTitle, style: .default){(alertAction) in
            if let cancelCallBack = didCancel{
                cancelCallBack()
            }
        }
        
        alert.addTextField { (textField) in
            textField.tag = 1
            //            textField.keyboardType = .numberPad
            textField.keyboardType = .asciiCapableNumberPad
            
            if(value1 != ""){
                textField.text = value1
            }else{
                textField.placeholder = placeholder1
            }
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        }
        alert.addTextField { (textField) in
            textField.tag = 2
            if(value2 != ""){
                textField.text = value2
            }else{
                textField.placeholder = placeholder2
            }
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        }
        self.alert.addAction(self.cancelAction)
        self.alert.addAction(self.okAction)
        
        okAction.isEnabled = false
        parent.present(alert, animated: true, completion: nil)
    }
    
}

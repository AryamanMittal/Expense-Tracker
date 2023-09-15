//
//  updateView.swift
//  ExpenseTracker2
//
//  Created by aryaman mittal on 13/06/23.
//

import UIKit

class updateView: UIViewController {

    @IBOutlet weak var purchaseDate: UIDatePicker!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var itemNameField: UITextField!
    //var expObj:Expenses?
    var expObj:[Int:String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        purchaseDate!.date =  dateFormatter.date(from: expObj![3]! )!
        
        amountField!.text! = expObj![2]!
        itemNameField!.text = expObj![1]!
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSubmitEdit(_ sender: Any) {
        //expObj!.amt = Int(amountField!.text!)!
        let amt:Int = Int(amountField!.text!)!
        let id:Int = Int(expObj![0]!)!
        let itemPurched:String = itemNameField!.text!
        
        let datePicked:Date = purchaseDate!.date
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let stringDt:String = formatter.string(from: datePicked)
        
        //expObj!.date = stringDt
        
        var queries:String = " "
        queries = "update expense_info set item='\(itemPurched)',price='\(amt)',date='\(stringDt)' where id ='\(id)'"
        SQLiteWrapper.executeNonSelectQuery(query: queries)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /*
     let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: "2015-04-01T11:42:00") // replace Date String
    */

}

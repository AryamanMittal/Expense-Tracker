//
//  newExpenseView.swift
//  ExpenseTracker2
//
//  Created by aryaman mittal on 13/06/23.
//

import UIKit

class newExpenseView: UIViewController {
    
    @IBOutlet weak var pickedDate: UIDatePicker!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var itemName: UITextField!
    
    //var expenseArr:[Expenses]?
    
    var viewCon:ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Expense"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionNewExp(_ sender: Any) {
        
        let name:String = itemName!.text!
        let amt:Int = Int(amount!.text!)!
        
        let selectedDate:Date =  pickedDate!.date
        let formatter:DateFormatter = DateFormatter()
              formatter.dateFormat = "dd/MM/yyyy"
              let strDate:String  = formatter.string(from: selectedDate)
        
       // let item = Expenses(itemPurched: name, amt: amt, date: strDate)
        
        //viewCon?.expenseArray.append(item)
        var queries:String = ""
        queries = "insert into expense_info(item,price ,date) values('\(name)', \(amt), '\(strDate)') "
        
        SQLiteWrapper.executeNonSelectQuery(query: queries)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

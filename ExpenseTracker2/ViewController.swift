//
//  ViewController.swift
//  ExpenseTracker2
//
//  Created by aryaman mittal on 13/06/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    
    
    @IBOutlet weak var expenseTable: UITableView!
    var Array:[[Int:String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchTable()
        expenseTable.dataSource = self
        
        let nib:UINib=UINib(nibName: "expenseCell", bundle: nil)
        expenseTable.register(nib, forCellReuseIdentifier: "expense_cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:expenseCell = expenseTable.dequeueReusableCell(withIdentifier: "expense_cell", for: indexPath) as! expenseCell
        
        let items = Array[indexPath.row]
        cell.itemNameLabel.text! = items[1]! as String
        cell.itemPriceLabel.text! = "Rs. \(String(items[2]!))"
        cell.dateLabel.text! = items[3]! as String
  
        cell.indexPth = indexPath
        cell.viewCon = self
        return cell
    }
    
    @IBAction func actionNewExpense(_ sender: Any) {
        let expenseCon:newExpenseView = self.storyboard!.instantiateViewController(identifier: "new_screen") as! newExpenseView
        
        //expenseCon.expenseArr = self.expenseArray
        expenseCon.viewCon=self
        //present(expenseCon, animated: true)
        self.navigationController?.pushViewController(expenseCon, animated: true)
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchTable()
        expenseTable!.reloadData()
        
    }
    func fetchTable(){
        let q = "select * from expense_info"
        Array = SQLiteWrapper.executeSelectQuery(query: q)
        print(Array)
    }


}


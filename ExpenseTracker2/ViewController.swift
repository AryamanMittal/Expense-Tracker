//
//  ViewController.swift
//  ExpenseTracker2
//
//  Created by aryaman mittal on 13/06/23.
//

import UIKit
import UserNotifications
class ViewController: UIViewController,UITableViewDataSource {
    
    let dates = "2023-10-12T10:00:00.000Z"

    @IBOutlet weak var expenseTable: UITableView!
    var Array:[[Int:String]] = []
    var dateOfCurrentBook:String = ""
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
        if(indexPath.row == 0){
            dateOfCurrentBook = items[3]! as String
        }

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
        prepareNotification()

        print(daysBetweenCurrentDateAndDateString(dateString: dateOfCurrentBook)!)
        print(daysBetweenCurrentDateAndDateStrings(dateString: dates)!)

    }
    func fetchTable(){
        let q = "select * from expense_info"
        Array = SQLiteWrapper.executeSelectQuery(query: q)
        print(Array)
    }
    func prepareNotification(){
        /*
         if(issuedBooks.Count ==0){
         return;}
         */
        let center = UNUserNotificationCenter.current()
            
            // Define the notification content
        let daystoDueDate = daysBetweenCurrentDateAndDateString(dateString: dateOfCurrentBook)!
        if(daystoDueDate < 15){
            let content = UNMutableNotificationContent()
            content.title = "Daily Reminder"
            content.subtitle = "Library book due in \(daystoDueDate) days"
            content.body = "Don't forget to return your library book!"
            
            
            // Define the notification trigger for a daily notification at a specific time
            var dateComponents = DateComponents()
            dateComponents.hour = 11 // Change this to the desired hour (24-hour format)
            dateComponents.minute = 42 // Change this to the desired minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Create a unique identifier for the notification
            let identifier = "dailyReminderNotification"
            
            // Create the notification request
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // Schedule the notification
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Daily notification scheduled successfully.")
                }
            }
        }
    }
    
    
    func daysBetweenCurrentDateAndDateString(dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let dateFromString = dateFormatter.date(from: dateString) {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: currentDate, to: dateFromString)
            return components.day
        }
        
        return nil // Return nil if parsing the date fails
    }
    func daysBetweenCurrentDateAndDateStrings(dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let dateFromString = dateFormatter.date(from: dateString) {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: currentDate, to: dateFromString)
            return components.day
        }
        
        return nil // Return nil if parsing the date fails
    }




}


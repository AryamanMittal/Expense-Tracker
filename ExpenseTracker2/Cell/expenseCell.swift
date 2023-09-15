//
//  expenseCell.swift
//  ExpenseTracker2
//
//  Created by aryaman mittal on 13/06/23.
//

import UIKit

class expenseCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    var indexPth:IndexPath?
    var viewCon:ViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        let updateCon:updateView = viewCon!.storyboard!.instantiateViewController(identifier: "update_screen") as! updateView
      //  updateCon.expObj = viewCon!.expenseArray[indexPth!.row]
        updateCon.expObj = viewCon!.Array[indexPth!.row]

        viewCon!.navigationController!.pushViewController(updateCon, animated: true)
        
        
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        let selectedRow:[Int:String] = viewCon!.Array[indexPth!.row]
        let qu = "delete from expense_info where id = '\(Int(selectedRow[0]!)!)'"
        SQLiteWrapper.executeNonSelectQuery(query: qu)
        viewCon!.fetchTable()
        viewCon!.expenseTable.reloadData()
    }
}

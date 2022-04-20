//
//  SchoolTableViewCell.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit

protocol SchoolTableViewCellDelegate: AnyObject {
    func phoneNumberTapped(row: Int)
    func emailTapped(row: Int)
}

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet var schoolName: UILabel!
    
    public weak var delegate: SchoolTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(school: School?) {
        schoolName.text = school?.school_name
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        PrintLog.printToConsole(str: "Email tapped \(self.tag)")
        delegate?.emailTapped(row: self.tag)
    }
    
    @IBAction func phoneTapped(_ sender: Any) {
        PrintLog.printToConsole(str: "Phone tapped \(self.tag)")
        delegate?.phoneNumberTapped(row: self.tag)
    }
    
}

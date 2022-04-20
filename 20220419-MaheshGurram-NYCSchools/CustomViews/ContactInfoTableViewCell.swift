//
//  ContactInfoTableViewCell.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {


    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(school: School?, row: Int) {
        let data = prepareData(row: row, school: school)
        titleLabel.text = data.0
        valueLabel.text = data.1
    }
    
    private func prepareData(row: Int, school: School?) -> (String, String?) {
        
        switch row {
            case 0:
                return("Phone", school?.phone_number)
            case 1:
                return("Fax", school?.fax_number)
            case 2:
                return("Email", school?.school_email)
            case 3:
                return("Website", school?.website)
            default:
                return("", "")
        }
        
    }
    
}

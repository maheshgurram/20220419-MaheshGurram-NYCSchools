//
//  OverviewCell.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit

class OverviewCell: UITableViewCell {

    @IBOutlet var overView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(school: School?) {
        guard let school = school else { return }
        
        overView.text = school.overview_paragraph
        
    }
    
    
    // Prepare the requirements as string from all the requirement properties
    public func configureRequirements(school: School?) {
        let reqs = prepareRequirement(school: school)
        overView.text = reqs == "" ? "No Data" : reqs
    }
    
    public func prepareRequirement(school: School?) -> String {
        var reqs = ""
        if let req1 = school?.requirement1_1 {
            
            reqs += "- \(req1) \n"
            
            if let req2 = school?.requirement2_1 {
                reqs += "- \(req2) \n"
                
                if let req3 = school?.requirement3_1 {
                    reqs += "- \(req3) \n"
                    
                    if let req4 = school?.requirement4_1 {
                        reqs += "- \(req4) \n"
                    }
                }
                
            }
        }
        
        return reqs
    }
    
}

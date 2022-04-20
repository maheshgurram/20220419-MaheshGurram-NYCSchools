//
//  AverageScoreCell.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit

class AverageScoreCell: UITableViewCell {

    @IBOutlet var readingScore: UILabel!
    @IBOutlet var mathScore: UILabel!
    @IBOutlet var writingScore: UILabel!
    
    var noDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No data at the moment"
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.addSubview(noDataLabel)
        
        noDataLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        noDataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
        noDataLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        noDataLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(score: Score?) {
        if let score = score {
            readingScore.text = score.sat_critical_reading_avg_score
            writingScore.text = score.sat_writing_avg_score
            mathScore.text = score.sat_math_avg_score
            noDataLabel.isHidden = true
            shouldHideScoreLabels(isHidden: false)
        } else {
            noDataLabel.isHidden = false
            shouldHideScoreLabels(isHidden: true)
        }
    }
    
    private func shouldHideScoreLabels(isHidden: Bool){
        readingScore.isHidden = isHidden
        writingScore.isHidden = isHidden
        mathScore.isHidden = isHidden
    }
}

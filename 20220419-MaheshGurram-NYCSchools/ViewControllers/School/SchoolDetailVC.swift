//
//  SchoolDetailVC.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit

enum sectionTypes: String {
    case scores = "Average SAT scores"
    case overview = "Overview"
    case address = "Address"
    case requirements = "Requirements"
    case contactInfo = "Contact Info"
}

class SchoolDetailVC: UIViewController {

    var tableView: UITableView!
    var school: School? = nil
    var score: Score? = nil
    let networkManager = NetworkManager()
    var activityIndicator: UIActivityIndicatorView?
    
    // Sections list to display.
    let sections = [sectionTypes.overview, sectionTypes.scores, sectionTypes.address, sectionTypes.requirements, sectionTypes.contactInfo]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            
        title = school?.school_name
        view.backgroundColor = .white
        
        setupTableView()
        
        Task {
            await getSchoolScores()
        }
        
    }
    
    private func setupTableView() {
        
        tableView = UITableView()

        view.addSubview(tableView)
        
        // Table view constraints to display it in full screen
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        
        // Register all the table view cells
        tableView.register(UINib(nibName: "AverageScoreCell", bundle: self.nibBundle), forCellReuseIdentifier: "AverageScoreCell")
        tableView.register(UINib(nibName: "AddressCell", bundle: self.nibBundle), forCellReuseIdentifier: "AddressCell")
        tableView.register(UINib(nibName: "OverviewCell", bundle: self.nibBundle), forCellReuseIdentifier: "OverviewCell")
        tableView.register(UINib(nibName: "ContactInfoTableViewCell", bundle: self.nibBundle), forCellReuseIdentifier: "ContactInfoTableViewCell")
        
    }
    
    // Activity indicator to show during api call in progress
    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        activityIndicator?.color = .darkGray
        
        if let actInd = activityIndicator {
            view.addSubview(actInd)
        }
        
        activityIndicator?.startAnimating()
    }
    
    // Remove the activity inidcator after data load
    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
        
    }
    
    // Get the score info for selected school
    private func getSchoolScores() async {
        
        // return if the school id is doens't exist
        guard let schoolId = school?.dbn else { return }
        
        let url = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn=\(schoolId)"
        
        showActivityIndicator()
        do {
            let data = try await networkManager.getData(url: url, type: [Score].self)
            if let dataVal = data?.first {
                self.score = dataVal
                self.reloadData()
            }
            hideActivityIndicator()
        } catch SchoolFetchError.invalidURL {
            PrintLog.printToConsole(str: "Invalid URL")
            self.displayAlert(title: "Error", message: "Invalid URL")
        } catch SchoolFetchError.invalidResponse(let statusCode) {
            PrintLog.printToConsole(str: "\(statusCode)")
            let message = networkManager.displayError(statusCode: statusCode)
            self.displayAlert(title: "Error", message: message)
        } catch {
            PrintLog.printToConsole(str: error.localizedDescription)
            self.displayAlert(title: "Error", message: error.localizedDescription)
        }
        
        hideActivityIndicator()
    }
    
    private func displayAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension SchoolDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    // Automatic dimenson to handle table view cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Contact info section has 4 rows to display phone, fax, email and website info
        if sections[section] == sectionTypes.contactInfo {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the section type from sections list to display
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .scores :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AverageScoreCell") as? AverageScoreCell else { return UITableViewCell() }
            cell.configure(score: score)
            return cell
        case .overview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell") as? OverviewCell else { return UITableViewCell() }
            cell.overView.text = school?.overview_paragraph
            return cell
        case .address:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as? AddressCell else { return UITableViewCell() }
            cell.configure(school: school)
            return cell
        case .requirements:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell") as? OverviewCell else { return UITableViewCell() }
            cell.configureRequirements(school: school)
            return cell
        case .contactInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell") as? ContactInfoTableViewCell else { return UITableViewCell() }
            cell.configure(school: school, row: indexPath.row)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = UIColor(red: 1/256, green: 34/256, blue: 106/256, alpha: 1)// .blue
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width, height: 30))
        view.addSubview(headerLabel)

        headerLabel.font = .systemFont(ofSize: 20)
        headerLabel.textColor = .white
        
        // Get the sections from section and raw value of enum to display as section header
        let sectionType = sections[section]
        headerLabel.text = sectionType.rawValue
        
        return view
    }
    
    
}

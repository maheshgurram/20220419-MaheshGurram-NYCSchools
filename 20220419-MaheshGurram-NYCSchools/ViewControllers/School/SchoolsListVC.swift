//
//  SchoolsListVC.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit

class SchoolsListVC: UIViewController {

    var tableView: UITableView!
    let networkManager = NetworkManager()
    var schools: [School] = []
    var searchedSchools: [School] = []
    
    var activityIndicator: UIActivityIndicatorView?
    var refresh = UIRefreshControl()
    var searchBar: UISearchBar!
    var searchController: UISearchController!
    
    
    // Gives if search bar is empty or not
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // indicates search in progress
    var isSearchInProgress: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Schools"
        setupSearchBar()
        setupTableView()
        
        // Make api call to get data
        getSchools()
        
        // Refresh controller
        refresh.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.addSubview(refresh)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Search bar to help search by school name
    private func setupSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "School name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        
        tableView = UITableView()
        view.addSubview(tableView)
        
        // Adding constraints to tableview to span full screen
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Register table view cells
        tableView.register(UINib(nibName: "SchoolTableViewCell", bundle: self.nibBundle), forCellReuseIdentifier: "SchoolTableViewCell")
        
    }
    
    // Activity indicator to show during api call in progress
    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .darkGray
        activityIndicator?.center = view.center
        
        if let actInd = activityIndicator {
            view.addSubview(actInd)
        }
        
        // Do not show activity indicator when refresh is in progress
        if self.refresh.isRefreshing == false {
            activityIndicator?.startAnimating()
        }
    }
    
    
    // Remove the activity inidcator after data load
    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
    }
    
    // Make api call to get data when pull down refresh happens
    @objc func handleRefresh() {
        refresh.beginRefreshing()
        getSchools()
    }
    
    
    // stop refreshing once data load is complete
    private func stopRefreshing() {
        DispatchQueue.main.async {
            if self.refresh.isRefreshing == true {
                self.refresh.endRefreshing()
            }
        }
    }
    
    private func getSchools() {
        
        let url = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
        showActivityIndicator()
        networkManager.getData(url: url, type: [School].self) { [weak self] data, error in
            if let err = error {
                PrintLog.printToConsole(str: "Exception occured while loading data\(err)")
                self?.displayAlert(title: "Error", message: err)
            } else {
                if let schoolsData = data {
                    self?.schools = schoolsData
                    self?.reloadData()
                }
                
            }

            self?.stopRefreshing()
            self?.hideActivityIndicator()
        }
        
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

extension SchoolsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If search is in progress display search results, otherwise display full list
        if isSearchInProgress {
            return searchedSchools.count
        }
        return schools.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell") as? SchoolTableViewCell else { return UITableViewCell() }
        // If search is in progress display search results, otherwise display full list
        let school: School?
        if isSearchInProgress {
            school = searchedSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }
        
        cell.configure(school: school)
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If search is in progress get the selected school from search results, otherwise from school list
        let vc = SchoolDetailVC()
        let school: School?
        if isSearchInProgress {
            school = searchedSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }

        vc.school = school
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SchoolsListVC: UISearchResultsUpdating {
    
    // Handling search, filter the schools that match with search text
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased() {
            searchedSchools = schools.filter { (school: School) -> Bool in
                return school.school_name?.lowercased().contains(searchText) ?? false
            }
            
            tableView.reloadData()
        }
        
    }
    
}


extension SchoolsListVC: SchoolTableViewCellDelegate {
    
    func phoneNumberTapped(row: Int) {
        
        let school = isSearchInProgress ? searchedSchools[row] : schools[row]
        
        PrintLog.printToConsole(str: "Phone tapped\(String(describing: school.phone_number))")
        
        guard let phone = school.phone_number,
            let url = URL(string: "tel://\(phone)") ,
              UIApplication.shared.canOpenURL(url) else {
            displayAlert(title: "Cannot open", message: "Please try on real device to make phone call")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func emailTapped(row: Int) {
        let school = isSearchInProgress ? searchedSchools[row] : schools[row]
        
        PrintLog.printToConsole(str: "Email tapped\(String(describing: school.school_email))")
        
        guard let email = school.school_email,
            let url = URL(string: "mailto:\(email)") ,
              UIApplication.shared.canOpenURL(url) else {
            displayAlert(title: "Cannot open", message: "Please try on real device to send email")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

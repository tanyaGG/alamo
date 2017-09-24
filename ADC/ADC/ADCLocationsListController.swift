//
//  ViewController.swift
//  ADC
//
//  Created by TANYA GYGI on 9/22/17.
//  Copyright © 2017 TANYA GYGI. All rights reserved.
//

import UIKit

class ADCLocationsListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let minNumberOfSearchChars: NSInteger = 3
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderLabel: UILabel!
    
    var locations: [ADCLocation] = []
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ADCLocationCell.nib, forCellReuseIdentifier: ADCLocationCell.cellIdentifier)
        self.tableView.estimatedRowHeight = 100
        self.title = NSLocalizedString("Search", comment: "search screen title")
        self.searchBar.placeholder = NSLocalizedString("Start typing location", comment: "search hint")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
    }
    
    func getLocations() {
        
        guard let text = self.searchBar.text else {
            self.showError(text: NSLocalizedString("Value is required", comment: "error string cant be empty"))
            return
        }
        
        let cleanQuery = text.trimmingCharacters(in: .whitespaces)
        guard cleanQuery.characters.count > minNumberOfSearchChars else {
            let message = String(format: NSLocalizedString("Value must meet criteria", comment:"error string cant be empty"), minNumberOfSearchChars)
            
            self.showError(text: message)
            return
        }
        
        self.activityIndicator.startAnimating()
        ADCLocationManager.sharedInstance.fetchLocations(withQuery:cleanQuery) { [weak self] (locations, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if let error = error {
                    self?.showError(text: error.localizedDescription)
                } else {
                    self?.locations = locations!
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func showError(text: String) {
        guard self.searchActive == false else {
            return
        }
        let messagetitle = NSLocalizedString("Error", comment: "error title")
        let buttonTitle = NSLocalizedString("Ok", comment: "error button title")
        let alert = UIAlertController(title: messagetitle, message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Table data source, delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ADCLocationCell.cellIdentifier) as? ADCLocationCell else {
            return UITableViewCell()
        }
        
        if indexPath.row < self.locations.count {
            cell.setup(withLocation: self.locations[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < self.locations.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller:ADCLocationMapController = storyboard.instantiateViewController(withIdentifier: "ADCLocationMapController") as! ADCLocationMapController
            controller.location = self.locations[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    //MARK: Search bar delegates
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getLocations), object: nil)
        self.getLocations()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.throttle()
    }
    
    func throttle() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getLocations), object: nil)
        self.perform(#selector(self.getLocations), with: nil, afterDelay: 1.0)
    }
}


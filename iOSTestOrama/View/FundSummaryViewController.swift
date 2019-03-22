//
//  FundSummaryViewController.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 20/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import UIKit

protocol FundSummaryViewDelegate {
    func fetchFundsSucceeded()
    func fetchFundsFailed(_ localizedDescription: String)
    func fundPurchaseSucceeded()
    func fundListStateChanged(stateShowPurchased: Bool)
}

class FundSummaryViewController: UIViewController, FundSummaryViewDelegate {

    var presenter: FundPresenter? = nil
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    @IBOutlet weak var bbiReload: UIBarButtonItem!
    @IBOutlet weak var bbiShowPurchased: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpController()
    }
    
    func setUpController() {
        self.presenter = FundPresenter()
        presenter?.fundSummaryViewDelegate = self
        presenter?.fetchFunds()
        
        activityIndicator.startAnimating()
        
        self.collectionView.delegate = presenter
        self.collectionView.dataSource = presenter
        self.collectionView.backgroundView = activityIndicator
    }
    
    func updateControls(_ showPurchased: Bool) {
        if showPurchased {
            self.title = "Fundos Adquiridos"
            self.bbiReload.isEnabled = false
        } else {
            self.title = "Fundos"
            self.bbiReload.isEnabled = true
        }
    }
    
    
    // MARK: @IBAction
    
    @IBAction func bbiRefreshClicked(_ sender: Any) {
        self.activityIndicator.startAnimating()
        self.presenter?.clearFunds()
        self.collectionView.reloadData()
        self.presenter?.fetchFunds()
    }
    
    @IBAction func bbiShowPurchasedClicked(_ sender: Any) {
        self.presenter?.toggleState()
    }
    
    
    // MARK: FundSummaryViewDelegate
    
    func fetchFundsSucceeded() {
        self.activityIndicator.stopAnimating()
        self.collectionView.reloadData()
    }
    
    func fetchFundsFailed(_ localizedDescription: String) {
        self.activityIndicator.stopAnimating()
        
        let fetchFailAlertController = UIAlertController(title: "Erro", message: localizedDescription, preferredStyle: .alert)
        fetchFailAlertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(fetchFailAlertController, animated: true)
    }
    
    func fundPurchaseSucceeded() {
        self.navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }

    func fundListStateChanged(stateShowPurchased: Bool) {
        self.updateControls(stateShowPurchased)
        self.collectionView.reloadData()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFundDetailSegue" {
            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
                self.presenter?.routeToFundDetail(segue: segue, indexPath: indexPath)
            }
        }
    }
}







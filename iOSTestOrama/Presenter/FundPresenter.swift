//
//  FundPresenter.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 22/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import UIKit
import Alamofire

class FundPresenter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let PURCHASED_ARRAY_KEY = "purchasedArrayKey"
    
    var funds: [Fund] = []
    var selectedFund: Fund? = nil
    var stateShowPurchased: Bool = false
    var fundSummaryViewDelegate: FundSummaryViewDelegate? = nil
    
    func fetchFunds() {
        Alamofire.request("https://s3.amazonaws.com/orama-media/json/fund_detail_full.json").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let decoder = JSONDecoder()
                    
                    do {
                        self.funds = try decoder.decode([Fund].self, from: jsonData)
                        
                        if let storedPurchases = UserDefaults.standard.array(forKey: self.PURCHASED_ARRAY_KEY) as? [Int] {
                            for fund in self.funds where storedPurchases.contains(fund.id) {
                                fund.purchased = true
                            }
                        }
                    } catch {
                        self.fundSummaryViewDelegate?.fetchFundsFailed(error.localizedDescription)
                    }
                }
                
                self.fundSummaryViewDelegate?.fetchFundsSucceeded()
                
            case .failure(let error):
                self.fundSummaryViewDelegate?.fetchFundsFailed(error.localizedDescription)
            }
        }
    }
    
    func clearFunds() {
        self.funds.removeAll()
    }
    
    func toggleState() {
        self.stateShowPurchased = !self.stateShowPurchased
        self.fundSummaryViewDelegate?.fundListStateChanged(stateShowPurchased: self.stateShowPurchased)
    }
    
    func routeToFundDetail (segue: UIStoryboardSegue, indexPath: IndexPath) {
        if let fundDetailViewController = segue.destination as? FundDetailViewController {
            self.selectedFund = self.funds.filter({$0.purchased == stateShowPurchased})[indexPath.row]
            fundDetailViewController.presenter = self
            fundDetailViewController.fullName = self.selectedFund!.fullName
            fundDetailViewController.purchased = self.selectedFund!.purchased
            fundDetailViewController.managerDescription = self.selectedFund!.manager.description
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: self.selectedFund!.initialDate) {
                formatter.dateFormat = "dd/MM/yyyy"
                fundDetailViewController.initialDate = formatter.string(from: date)
            }
            
            if let urlString = self.selectedFund!.strategyVideo?.thumbnailURL {
                fundDetailViewController.thumbnailURL = urlString
            }
        }
    }
    
    func handleFundPurchaseAndUpdatePersistence() {
        guard self.selectedFund != nil else {
            return
        }

        var purchased: [Int] = []

        if let storedPurchases = UserDefaults.standard.array(forKey: PURCHASED_ARRAY_KEY) as? [Int] {
            purchased.append(contentsOf: storedPurchases)
        }

        if !purchased.contains(self.selectedFund!.id) {
            purchased.append(self.selectedFund!.id)
            self.selectedFund!.purchased = true
        }

        UserDefaults.standard.set(purchased, forKey: PURCHASED_ARRAY_KEY)

        self.fundSummaryViewDelegate?.fundPurchaseSucceeded()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.funds.filter({$0.purchased == stateShowPurchased}).count //.isEmpty ? 0 : 6 //
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fund = self.funds.filter({$0.purchased == stateShowPurchased})[indexPath.row]
        let simpleName = fund.simpleName
        let minInitApplicationAmount = "R$\(fund.operability.minInitApplicationAmount.replacingOccurrences(of: ".", with: ","))"
        let fundRiskProfileName = fund.specification.riskProfile.name
        return FundSummaryCollectionViewCell.createCell(collectionView: collectionView, indexPath: indexPath, simpleName: simpleName, minInitApplicationAmount: minInitApplicationAmount, fundRiskProfileName: fundRiskProfileName)
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

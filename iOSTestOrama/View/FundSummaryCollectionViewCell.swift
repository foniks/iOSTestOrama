//
//  FundSummaryCollectionViewCell.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 22/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import UIKit

class FundSummaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet public weak var lblSimpleName: UILabel!
    @IBOutlet public weak var lblMinInitApplicationAmount: UILabel!
    @IBOutlet public weak var lblFundRiskProfileName: UILabel!
    
    public class func createCell (collectionView: UICollectionView, indexPath: IndexPath, simpleName: String, minInitApplicationAmount: String, fundRiskProfileName: String) -> FundSummaryCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FundSummaryCollectionViewCell", for: indexPath) as! FundSummaryCollectionViewCell
        cell.lblSimpleName.text = simpleName
        cell.lblMinInitApplicationAmount.text = minInitApplicationAmount
        cell.lblFundRiskProfileName.text = fundRiskProfileName
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
}

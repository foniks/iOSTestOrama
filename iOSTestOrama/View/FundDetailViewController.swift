//
//  FundDetailViewController.swift
//  iOSTestOrama
//
//  Created by Bruno Pampolha on 20/03/19.
//  Copyright © 2019 Bruno Pampolha. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FundDetailViewController: UIViewController {
    
    var fullName: String = ""
    var initialDate: String = ""
    var managerDescription: String = ""
    var thumbnailURL: String = ""
    var purchased: Bool = false
    var presenter: FundPresenter? = nil
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblInitialDate: UILabel!
    @IBOutlet weak var txvFundDescription: UITextView!
    @IBOutlet weak var imgVideoThumbnail: UIImageView!
    @IBOutlet weak var btnPurchase: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpController()
    }
    
    func setUpController() {
        self.lblFullName.text = self.fullName
        self.lblInitialDate.text = "Data inicial: \(self.initialDate)"
        self.txvFundDescription.text = self.managerDescription
        if let thumbURL = URL(string: self.thumbnailURL) {
            self.imgVideoThumbnail.af_setImage(withURL: thumbURL, placeholderImage: nil)
        }
        
        if purchased {
            self.btnPurchase.isEnabled = false
            self.btnPurchase.setTitle("Comprado", for: .disabled)
            self.btnPurchase.setTitleColor(UIColor.darkGray, for: .disabled)
        }
    }
    
    func promptForPassword() {
        let passwordAlertController = UIAlertController(title: "Digite sua senha", message: "senha: 123", preferredStyle: .alert)
        passwordAlertController.addTextField()
        passwordAlertController.textFields?[0].isSecureTextEntry = true
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: .default) { [unowned passwordAlertController] _ in
            if let answer = passwordAlertController.textFields?[0].text, answer == "123" {
                self.presenter?.handleFundPurchaseAndUpdatePersistence()
            } else {
                passwordAlertController.message = "Senha incorreta!"
            }
        }
        
        passwordAlertController.addAction(confirmAction)
        
        present(passwordAlertController, animated: true)
    }
    
    
    // MARK : @IBAction
    
    @IBAction func btnPurchasedClicked(_ sender: Any) {
        self.promptForPassword()
    }
}

//
//  CreateSuperHeroViewController.swift
//  FIT5140-Week03-Lab
//
//  Created by Mayank Kamra on 21/8/20.
//  Copyright © 2020 Mayank Kamra. All rights reserved.
//

import UIKit

class CreateSuperHeroViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var abilitiesTextField: UITextField!
    @IBOutlet weak var createHeroButton: UIButton!
    
    weak var superHeroDelegate: AddSuperHeroDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createHeroButton.layer.cornerRadius = 15
    }
    
    @IBAction func createHero(_ sender: Any) {
        if nameTextField.text != "" && abilitiesTextField.text != "" {
            let name = nameTextField.text!
            let abilities = abilitiesTextField.text!
            let hero = SuperHero(newName: name, newAbilities: abilities)
            let _ = superHeroDelegate?.addSuperHero(newHero: hero)
            navigationController?.popViewController(animated: true)
            return
        }
        
        var errorMsg = "Please ensure all fields are filled:\n"
        
        if nameTextField.text == "" {
            errorMsg += "- Must provide abilities"
        }
        
        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Hide keyboard after hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

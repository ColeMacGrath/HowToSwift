//
//  ViewController.swift
//  CustomShareSheet
//
//  Created by Moisés Córdova on 05/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openMenuButtonPressed(_ sender: UIButton) {
        guard let (controller, activityViewController) = storyboard?.createMenu(options: ["Option 1", "Option 2"], images: nil, title: NSLocalizedString("Menu Title", comment: ""), image: nil) else { return }
        controller.callback = { selected in
           print("Selected option index: \(selected)")
        }
        
        if let popoverController = activityViewController.popoverPresentationController {
            let viewForSource = sender as UIView
            popoverController.sourceView = viewForSource
            popoverController.sourceRect = viewForSource.bounds
            popoverController.delegate = self
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


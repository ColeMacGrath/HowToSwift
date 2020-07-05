//
//  Util.swift
//  CustomShareSheet
//
//  Created by Moisés Córdova on 05/06/20.
//  Copyright © 2020 Moisés Córdova. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    @available(iOS 13, *)
    func createMenu(options: [String], images: [UIImage]?, title: String?, image: UIImage?) -> (menu: OptionsViewController, activityController: CustomActivityViewController)? {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsVC") as? OptionsViewController else { return nil }
        controller.options = options
        controller.headerTitle = title ?? ""
        controller.headerImage = image
        controller.images = images
        let activityViewController = CustomActivityViewController(controller: controller)
        return (controller, activityViewController)
    }
}

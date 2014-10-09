//
//  ContainerViewController.swift
//  TwitterSplitViewApp
//
//  Created by Arun Venkatesh on 10/7/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var viewController : UISplitViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setEmbeddedViewController(splitViewController: UISplitViewController!){
        if splitViewController != nil{
            viewController = splitViewController
            
            self.addChildViewController(viewController)
            self.view.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if size.width > size.height{
            self.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: viewController)
        }
        else{
            self.setOverrideTraitCollection(nil, forChildViewController: viewController)
        }
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    
}

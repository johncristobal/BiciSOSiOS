//
//  RoboBiciViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 4/15/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class RoboBiciViewController: UIViewController {

    @IBOutlet var vistaAmarilla: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var butonStart: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var tutorialPageViewController: OnboardingViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageControl.addTarget(self, action: "didChangePageControlValue", for: .valueChanged)
        vistaAmarilla.borderAmarillo()

    }
    
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
        print("Aqui change")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? OnboardingViewController {
            //tutorialPageViewController.tutorialDelegate = self as! OnboardingViewControllerDelegate
            self.tutorialPageViewController = tutorialPageViewController
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}


extension RoboBiciViewController: OnboardingViewControllerDelegate {
    
    func onboardingViewController(tutorialPageViewController: OnboardingViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onboardingViewController(tutorialPageViewController: OnboardingViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        
        /*if index == 2 {
            butonStart.isHidden = false
        }else{
            butonStart.isHidden = true
        }*/
        
        print("Aqui...\(index)")
    }
    
}


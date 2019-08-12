//
//  TutorialViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 8/12/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var butonStart: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
     @IBOutlet var butonOmitir: UIButton!
    @IBOutlet var whiteborderView: UIView!
    
    var tutorialPageViewController: OnboardingPagerViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        butonStart.isHidden = true
        
        // Do any additional setup after loading the view.
        pageControl.addTarget(self, action: "didChangePageControlValue", for: .valueChanged)
        
        containerView.borderWhite()
        butonStart.borderButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
        print("Aqui change")
    }
    
    
    @IBAction func launchMain(_ sender: Any) {
        
        let bici = UserDefaults.standard.string(forKey: "tutorial")
        if bici != nil{
            if bici == "1"{
                dismiss(animated: true, completion: nil)
            }else{
                UserDefaults.standard.set("1", forKey: "tutorial")
                self.performSegue(withIdentifier: "reveal", sender: nil)
            }
        }else{
            UserDefaults.standard.set("1", forKey: "tutorial")
            self.performSegue(withIdentifier: "reveal", sender: nil)
        }
        //colocar bandera tutorial en 1
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? OnboardingPagerViewController {
                self.tutorialPageViewController = tutorialPageViewController
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension TutorialViewController: OnboardingPagerViewControllerDelegate {
    
    func onboardingViewController(tutorialPageViewController: OnboardingPagerViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onboardingViewController(tutorialPageViewController: OnboardingPagerViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        
        if index == 5 {
            butonStart.isHidden = false
        }else{
            butonStart.isHidden = true
        }
        
        print("Aqui...\(index)")
    }
    
}

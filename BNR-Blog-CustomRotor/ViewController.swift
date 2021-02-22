//
//  ViewController.swift
//  BNR-Blog-CustomRotor
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    // MARK: - Properties
    
    private var currentRating = 0
    
    var ratingRotor: UIAccessibilityCustomRotor {
        var rating = currentRating
        
        // The name of the rotor is what the user hears so make it descriptive!
        let rotorOption = UIAccessibilityCustomRotor(name: "Rating Value") { [weak self] predicate -> UIAccessibilityCustomRotorItemResult? in
            guard let self = self else { return nil }
            
            let isFlickUp = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.previous
            let delta = isFlickUp ? +1 : -1
            rating = min(max(0, rating + delta), 4)
            
            self.setRating(value: rating)
            
            UIAccessibility.post(notification: .layoutChanged, argument: self.ratingStackView)
            
            return UIAccessibilityCustomRotorItemResult(targetElement: self.ratingStackView , targetRange: nil)
        }

        return rotorOption
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRatingBar()
        setUpAccessibility()
    }
    
    @objc func ratingTapped(_ sender: UITapGestureRecognizer) {
        var selectedStarIndex = 0
        
        for (index, starView) in ratingStackView.subviews.enumerated() {
            if starView.frame.contains(sender.location(in: ratingStackView)) {
                selectedStarIndex = index
            }
        }
        
        setRating(value: selectedStarIndex)
    }
    
    // MARK: - Private
    
    private func setUpAccessibility() {
        titleLabel.accessibilityTraits = [.header]
        
        productImageView.isAccessibilityElement = true
        productImageView.accessibilityLabel = "Dark brown leather hat with embellishments"
        
        ratingStackView.isAccessibilityElement = true
        ratingStackView.accessibilityCustomRotors = [ratingRotor]
    }
    
    private func setUpRatingBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ratingTapped(_:)))
        ratingStackView.addGestureRecognizer(tapGesture)
        
        setRating(value: 0)
    }
    
    private func setRating(value: Int) {
        currentRating = value
        ratingStackView.accessibilityLabel = "Rating: \(currentRating + 1) out of 5"
        
        for (index, starView) in ratingStackView.subviews.enumerated() {
            guard let starImageView = starView as? UIImageView else { continue }
            
            starImageView.image = index <= value ? UIImage(named: "filled-star") : UIImage(named: "open-star")
        }
    }
}

//
//  ViewController.swift
//  PraticeViewCode
//
//  Created by Brian Hashirama on 2/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var cardView: UIView = {
        let card = UIView(frame: .zero)
        card.backgroundColor = .lightGray
        card.isUserInteractionEnabled = true
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    // just for testing purpose
    private lazy var presentationView: UIView = {
        let card = UIView(frame: .zero)
        card.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        card.backgroundColor = .red
        card.isUserInteractionEnabled = true
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    
    var startingFrame: CGRect?
    var viewController: UIViewController!
    var topConstraints: NSLayoutConstraint?
    var leadingConstraints: NSLayoutConstraint?
    var heightConstraints: NSLayoutConstraint?
    var widthConstraints: NSLayoutConstraint?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.layer.cornerRadius = 9
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 200),
            cardView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
    }
    
    func addTapGesture(){
        // adding gesture to card view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandCard))
        cardView.addGestureRecognizer(tapGesture)
        
        // dissmiss gesture for the presentation view
//        let tapGesturePresentationView = UITapGestureRecognizer(target: self, action: #selector(dissmissView(gesture:)))
//        presentationView.addGestureRecognizer(tapGesturePresentationView)
//

    }
    
    @objc func expandCard(){
        //this if a uiview testing purpose
        //view.addSubview(presentationView)

        //we can add a view controller
        let vc = UIViewController()
        let presentationView = vc.view!
        presentationView.backgroundColor = .red
        view.addSubview(presentationView)
        let tapGestureDismissVC = UITapGestureRecognizer(target: self, action: #selector(dissmissView(gesture:)))
        presentationView.addGestureRecognizer(tapGestureDismissVC)
        
        //if using view controller
        addChild(vc)
        self.viewController = vc
        
        // get the frame from the view you want to render
        //absolute coordinates of view
        guard let startingFrame = cardView.superview?.convert(cardView.frame, to: nil) else {return}
        
        self.startingFrame = startingFrame // store the starting frame
        
        //using frame
       // presentationView.frame = startingFrame
        
        // using constraints
        presentationView.translatesAutoresizingMaskIntoConstraints = false
        topConstraints = presentationView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraints = presentationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraints = presentationView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraints = presentationView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        [topConstraints, leadingConstraints, widthConstraints, heightConstraints].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded()
        
        //optionaly the corner radius
        presentationView.layer.cornerRadius = 9
        
        //Animate the transition
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7,initialSpringVelocity: 0.7,options: .curveEaseInOut, animations: {
            //presentationView.frame = self.view.frame
            
            //constraints
            self.topConstraints?.constant = 0
            self.leadingConstraints?.constant = 0
            self.widthConstraints?.constant = self.view.frame.width
            self.heightConstraints?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            
            // if using tab bar
            self.tabBarController?.tabBar.frame.origin.y += 100
            self.navigationController?.navigationBar.frame.origin.y -= 100
        }, completion: nil)

    }
    
    
    @objc func dissmissView(gesture: UITapGestureRecognizer){
        // acess the frame of the target view
        //Animate the dismiss
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7,initialSpringVelocity: 0.7,options: .curveEaseInOut, animations: {
           // gesture.view?.frame = self.startingFrame ?? .zero
            
            //constraints
            guard let startingFrame = self.startingFrame else {return}
            self.topConstraints?.constant = startingFrame.origin.y
            self.leadingConstraints?.constant = startingFrame.origin.x
            self.widthConstraints?.constant = startingFrame.width
            self.heightConstraints?.constant = startingFrame.height
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame.origin.y -= 100
            self.navigationController?.navigationBar.frame.origin.y += 100
        }, completion: { _ in
            
            // once the animations its completed he removes from super view
            gesture.view?.removeFromSuperview()
            // remove the view controller from the parent
            self.viewController.removeFromParent()
        })
    }

}


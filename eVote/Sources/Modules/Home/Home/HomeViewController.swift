//
//  HomeViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel
    
    private let createVoteButton = UIButton()
    
    var onCreateVote: VoidClosure?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.createVoteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.createVoteButton.setTitle("Create Vote", for: .normal)
        self.createVoteButton.backgroundColor = .white
        self.createVoteButton.setTitleColor(UIColor.systemBlue, for: .normal)
        self.createVoteButton.layer.cornerRadius = 4
        self.createVoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.createVoteButton.addTarget(self, action: #selector(self.createVotePressed), for: .touchUpInside)
        self.createVoteButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.createVoteButton.layer.shadowRadius = 10
        self.createVoteButton.layer.shadowOpacity = 0.7
        self.createVoteButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.view.fl_addSubview(self.createVoteButton) { (view, container) -> [NSLayoutConstraint] in
            [
                view.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                view.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor, constant: -30)
            ]
        }
    }
    
    @objc private func createVotePressed() {
        self.onCreateVote?()
    }
}

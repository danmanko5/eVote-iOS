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
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var onCreateVote: VoidClosure?
    var onVote: VoteClosure?
    
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
        
        self.viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(VoteTableViewCell.self, forCellReuseIdentifier: VoteTableViewCell.className)
        
        self.view.fl_addSubview(self.tableView)
        
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

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VoteTableViewCell.className) as? VoteTableViewCell else { return UITableViewCell() }
        
        cell.vote = self.viewModel.vote(for: indexPath)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vote = self.viewModel.vote(for: indexPath) else { return }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.onVote?(vote)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

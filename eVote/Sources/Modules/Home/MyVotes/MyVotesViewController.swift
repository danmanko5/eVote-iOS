//
//  MyVotesViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class MyVotesViewController: UIViewController {
    
    let viewModel: MyVotesViewModel
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private lazy var segmentedController: UISegmentedControl = {
        let items = self.viewModel.sections.map { $0.title }
        return UISegmentedControl(items: items)
    }()
    
    var onVote: VoteClosure?
    
    init(viewModel: MyVotesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.updateVotes()
    }
    
    private func setupViews() {
        self.segmentedController.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.segmentedController.selectedSegmentIndex = self.viewModel.selectedSectionIndex
        self.navigationItem.titleView = self.segmentedController
        self.navigationController?.navigationBar.makeTransparent()
        
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        self.tableView.register(VoteTableViewCell.self, forCellReuseIdentifier: VoteTableViewCell.className)
        
        self.view.fl_addSubview(self.tableView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor)
            ]
        }
    }
    
    @objc private func segmentChanged(_ segmentedController: UISegmentedControl) {
        self.viewModel.setSelectedSectionIndex(segmentedController.selectedSegmentIndex)
        
        self.tableView.reloadData()
    }
}
extension MyVotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VoteTableViewCell.className) as? VoteTableViewCell else { return UITableViewCell() }
        
        cell.vote = self.viewModel.vote(for: indexPath)
        
        return cell
    }
}

extension MyVotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vote = self.viewModel.vote(for: indexPath) else { return }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.onVote?(vote)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//
//  VoteViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteViewController: UIViewController {
    
    let viewModel: VoteViewModel
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var onResults: VoteClosure?
    
    init(viewModel: VoteViewModel) {
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
    
    private func setupViews() {
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(VoteOptionTableViewCell.self, forCellReuseIdentifier: VoteOptionTableViewCell.className)
        
        self.view.fl_addSubview(self.tableView)
    }
    
    private func vote() {
        self.viewModel.vote { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func seeResults() {
        if let vote = self.viewModel.finishedVote {
            self.onResults?(vote)
        } else {
            self.onResults?(self.viewModel.vote)
        }
    }
}

extension VoteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.vote.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VoteOptionTableViewCell.className) as? VoteOptionTableViewCell,
              let option = self.viewModel.vote.options[safe: indexPath.row] else { return UITableViewCell() }
        
        cell.option = option
        cell.isOptionSelected = self.viewModel.isSelected(option: option)
        
        return cell
    }
}

extension VoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = self.viewModel.vote.options[safe: indexPath.row], !self.viewModel.hasParticipated else { return }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.viewModel.select(option)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = VoteTableHeaderView()
        headerView.vote = self.viewModel.vote
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = VoteTableFooterView()
        footerView.hasVoted = self.viewModel.hasParticipated
        footerView.canVote = self.viewModel.canVote
        
        footerView.onVote = { [weak self] in
            self?.vote()
        }
        footerView.onResult = { [weak self] in
            self?.seeResults()
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

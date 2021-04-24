//
//  VoteResultViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteResultViewController: UIViewController {
    
    let viewModel: VoteResultViewModel
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var onDone: VoidClosure?
    
    init(viewModel: VoteResultViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupViews()
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed))
        doneButton.tintColor = UIColor.label
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationController?.navigationBar.makeTransparent()
    }
    
    private func setupViews() {
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(VoteResultTableViewCell.self, forCellReuseIdentifier: VoteResultTableViewCell.className)
        
        self.view.fl_addSubview(self.tableView)
    }
    
    @objc private func donePressed() {
        self.onDone?()
    }
}

extension VoteResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfOptions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VoteResultTableViewCell.className) as? VoteResultTableViewCell,
              let option = self.viewModel.option(for: indexPath) else { return UITableViewCell() }
        
        cell.title = option.name
        cell.rate = self.viewModel.rate(for: indexPath)
        
        return cell
    }
}

extension VoteResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

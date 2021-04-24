//
//  SettingsViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    let viewModel: SettingsViewModel
    
    private let collectionView: UICollectionView
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.viewModel.user.username
        self.navigationController?.navigationBar.makeTransparent()
        self.view.backgroundColor = .systemBackground
        
        SettingsView.Reusables.CellType.allCases.forEach {
            self.collectionView.register($0.cellType,
                                         forCellWithReuseIdentifier: $0.reuseIdentifier)
        }
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.preservesSuperviewLayoutMargins = true
        
        self.view.fl_addSubview(self.collectionView)
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellType = self.viewModel.cellTypeForItem(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        let cellIdentifier = cellType.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath)
        let isFirst = indexPath.item == 0
        let isLast = indexPath.item == (self.viewModel.numberOfItems(in: indexPath.section) - 1)
        
        switch cellType {
        case .general:
            guard let generalCell = cell as? SettingsGeneralCell else { break }
            
            generalCell.displayObject = self.viewModel.generalDisplayObject(at: indexPath)
            generalCell.isFirst = isFirst
            generalCell.isLast = isLast
            
        case .action:
            guard let actionCell = cell as? SettingsActionCell else { break }
            
            actionCell.displayObject = self.viewModel.actionDisplayObject(at: indexPath)
            actionCell.isFirst = isFirst
            actionCell.isLast = isLast
        }
        
        return cell
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectItem(at: indexPath)
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cellType = self.viewModel.cellTypeForItem(at: indexPath) else {
            return .zero
        }
        
        return CGSize(width: collectionView.bounds.width,
                      height: cellType.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}

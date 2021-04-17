//
//  VoteResultViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class VoteResultViewModel {
    
    let vote: Vote
    
    private var rates: [VoteOption: Int] = [:]
    
    init(vote: Vote) {
        self.vote = vote
        
        self.calculateRates()
    }
    
    private func calculateRates() {
        var totalRate: Int = 0
        
        for option in self.vote.options {
            let rate = self.vote.rate(for: option)
            
            if (totalRate + rate > 100 || totalRate + rate < 100) && option == self.vote.options.last {
                self.rates[option] = 100 - totalRate
            } else {
                self.rates[option] = rate
            }
            
            totalRate += rate
        }
    }
    
    func numberOfOptions() -> Int {
        return self.vote.options.count
    }
    
    func option(for indexPath: IndexPath) -> VoteOption? {
        return self.vote.options[safe: indexPath.row]
    }
    
    func rate(for indexPath: IndexPath) -> Int {
        guard let option = self.option(for: indexPath) else { return 0 }
        
        return self.rates[option] ?? 0
    }
}

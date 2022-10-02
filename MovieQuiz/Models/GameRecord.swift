//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Илья Валито on 01.10.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    func gameStatistic() -> String {
        return "\(correct)/\(total) (\(date.dateTimeString))"
    }
}

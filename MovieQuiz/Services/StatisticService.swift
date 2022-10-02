//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Валито on 01.10.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private(set) var totalAccuracy: Double {
        get {
            loadUserDefaults(for: .total, as: Double.self) ?? 0.0
        }
        set {
            saveUserDefaults(value: newValue, at: .total)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            loadUserDefaults(for: .gamesCount, as: Int.self) ?? 0
        }
        set {
            saveUserDefaults(value: newValue, at: .gamesCount)
        }
    }
    
    private(set) var correctAnswersCount: Int {
        get {
            loadUserDefaults(for: .correct, as: Int.self) ?? 0
        }
        set {
            saveUserDefaults(value: newValue, at: .correct)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            loadUserDefaults(for: .bestGame, as: GameRecord.self) ?? .init(correct: 0, total: 0, date: Date())
        }
        set {
            saveUserDefaults(value: newValue, at: .bestGame)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswersCount += count
        totalAccuracy = (Double(correctAnswersCount) / Double(gamesCount * 10)) * 100
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < currentGame {
            bestGame = currentGame
        }
    }
    
    private func loadUserDefaults<T: Codable>(for key: Keys, as dataType: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let count = try? JSONDecoder().decode(dataType.self, from: data) else {
            return nil
        }
        return count
    }
    
    private func saveUserDefaults<T: Codable>(value: T,at key: Keys) {
        guard let data = try? JSONEncoder().encode(value) else {
            print("Невозможно сохранить результат")
            return
        }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}

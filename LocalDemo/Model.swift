//
//  Model.swift
//  LocalDemo
//
//  Created by Rockford Wei on 2022-04-02.
//
import Foundation
import PerfectCRUD
import PerfectSQLite

struct Record: Codable, CustomStringConvertible {
    let id: Int
    let title: String
    let description: String
    init(id i: Int, title t: String, description d: String) {
        id = i; title = t; description = d
    }
    static func random() -> Record {
        let id = Int.random(in: 0...1000000)
        let title = "#\(id) record"
        let text = UUID().uuidString
        return Record(id: id, title: title, description: text)
    }
    private static let db: Database<SQLiteDatabaseConfiguration> = {
        guard let path = Bundle.main.path(forResource: "records", ofType: "sqlite") else {
            fatalError("Local database is missing")
        }
        print("local db path")
        print(path)
        guard let config = try? SQLiteDatabaseConfiguration(path) else {
            fatalError("Unable to load local database")
        }
        let db = Database(configuration: config)
        do {
            try db.create(Record.self)
        } catch (let exception) {
            NSLog("Warning: unable to create table 'record': \(exception)")
        }
        return db
    }()
    static var records: [Record] {
        get {
            var r: [Record] = []
            do {
                let table = db.table(Record.self)
                r = try table.order(by: \.id).select().map { $0 }
            } catch (let error) {
                NSLog("Warning: unable to select table by order id: \(error)")
            }
            return r
        }
    }
    func insert() -> Bool {
        var result = true
        do {
            let table = Record.db.table(Record.self)
            try table.insert([self])
        } catch (let error) {
            result = false
            NSLog("Warning: unable to insert record because: \(error)")
        }
        return result
    }
    func delete() -> Bool {
        var result = true
        do {
            let table = Record.db.table(Record.self)
            try table.where(\Record.id == self.id).delete()
        } catch (let error) {
            result = false
            NSLog("Warning: unable to insert record because: \(error)")
        }
        return result
    }
}

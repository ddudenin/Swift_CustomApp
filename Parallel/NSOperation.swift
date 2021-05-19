//
//  NSOperation.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 19.05.2021.
//

import Foundation
import UIKit
import RealmSwift

class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
}

class FetchDataOperation: AsyncOperation {
    var data: Data?
    
    override func main() {
        NetworkManager.instance.loadGroups() { [weak self] (data) in
            self?.data = data
            self?.state = .finished
        }
    }
}

class ParseDataOperation: Operation {
    var groups = [Group]()
    
    override func main() {
        guard let operation = self.dependencies.first as? FetchDataOperation else { return }
        
        if let data = operation.data {
            do {
                self.groups = try JSONDecoder().decode(GroupsJSONData.self, from: data).response.items
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

class SaveToRealmOperation: Operation {
    override func main() {
        guard let operation = self.dependencies.first as? ParseDataOperation else { return }
        
        do {
            try RealmManager.instance?.add(objects: operation.groups)
        } catch {
            print(error.localizedDescription)
        }
    }
}

class DisplayDataOpeartion: Operation {
    unowned let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    override func main() {
        guard let _ = self.dependencies.first as? SaveToRealmOperation else { return }
        self.tableView.reloadData()
    }
}

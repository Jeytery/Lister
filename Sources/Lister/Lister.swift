// MIT license
// Telegram: @Jeytery, github: Jeytery

import UIKit
import Foundation

//TODO: -
// 1. Section + Row class -> struct
// 2. remove id from Section and Row
// 3. add clear() func to lister public interface
// 4. add delegate and dataSource variables analogs
// 5. add possibility to put view on header and footer 

open class ListerSection: Hashable {
   
    public static func == (lhs: ListerSection, rhs: ListerSection) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    
    public var rows: [ListerRow]
    public var header: String?
    public var footer: String?
    
    public init(
        rows: [ListerRow],
        header: String? = nil,
        footer: String? = nil
    ) {
        self.rows = rows
        self.header = header
        self.footer = footer
    }
}

open class ListerRow: Hashable {
    
    public static func == (lhs: ListerRow, rhs: ListerRow) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public let id = UUID()
    
    public var view: UIView
    public var action: (() -> Void)?
    public var height: CGFloat
    public var edges: UIEdgeInsets?
    
    public init(
        view: UIView,
        height: CGFloat = 60,
        edges: UIEdgeInsets? = nil,
        action: (
            () -> Void
        )? = nil
    ) {
        self.view = view
        self.height = height
        self.edges = edges
        self.action = action
    }
}

open class Lister: UITableView {
    
    private var content: [ListerSection] = []
    
    public override init(
        frame: CGRect,
        style: UITableView.Style
    ) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        register(TableViewCellWrapper.self, forCellReuseIdentifier: "cell")
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
}

extension Lister: UITableViewDelegate, UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let section = content[indexPath.section]
        return section.rows[indexPath.row].height
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return content[section].rows.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = content[indexPath.section]
        let row = section.rows[indexPath.row]
        
        let cell = TableViewCellWrapper<UIView>(
            view: row.view,
            edges: row.edges ?? .zero
        )
        return cell
    }
    
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let section = content[indexPath.section]
        let row = section.rows[indexPath.row]
        row.action?()
    }
    
    public func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        let section = content[section]
        return section.footer ?? ""
    }
    
    public func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        let section = content[section]
        return section.header ?? ""
    }
}

public extension Lister {
    func set(_ content: [ListerSection]) {
        self.content = content
        reloadData()
    }
    
    func clear() {
        set([])
    }
    
    func insertRow(
        _ row: ListerRow,
        at indexPath: IndexPath,
        with animation: UITableView.RowAnimation = .fade
    ) {
        content[indexPath.section].rows.insert(
            row,
            at: indexPath.row
        )
        insertRows(at: [indexPath], with: animation)
    }
    
    func appendRow(
        _ row: ListerRow,
        section: Int,
        with animation: UITableView.RowAnimation = .fade
    ) {
        content[section].rows.append(row)
        let indexPath = IndexPath(
            row: content[section].rows.count - 1,
            section: section
        )
        insertRows(at: [indexPath], with: animation)
    }
    
    func removeRow(
        at indexPath: IndexPath,
        with animation: UITableView.RowAnimation = .fade
    ) {
        content[indexPath.section].rows.remove(at: indexPath.row)
        deleteRows(at: [indexPath], with: animation)
    }
   
    func removeRows(
        at section: Int,
        rows: [Int],
        with animation: UITableView.RowAnimation = .fade
    ) {
        let indexPathes: [IndexPath] = rows.compactMap {
            return IndexPath(row: $0, section: section)
        }
        let _ = content[section].rows.remove(elementsAtIndices: rows)
        deleteRows(at: indexPathes, with: animation)
    }
    
    public func sectionViewsCount(_ section: Int) -> Int {
        return content[section].rows.count
    }
}

fileprivate extension Array {
    mutating func remove(elementsAtIndices indicesToRemove: [Int]) -> [Element] {
        guard !indicesToRemove.isEmpty else {
            return []
        }
        
        // Copy the removed elements in the specified order.
        let removedElements = indicesToRemove.map { self[$0] }
        
        // Sort the indices to remove.
        let indicesToRemove = indicesToRemove.sorted()
        
        // Shift the elements we want to keep to the left.
        var destIndex = indicesToRemove.first!
        var srcIndex = destIndex + 1
        func shiftLeft(untilIndex index: Int) {
            while srcIndex < index {
                self[destIndex] = self[srcIndex]
                destIndex += 1
                srcIndex += 1
            }
            srcIndex += 1
        }
        for removeIndex in indicesToRemove[1...] {
            shiftLeft(untilIndex: removeIndex)
        }
        shiftLeft(untilIndex: self.endIndex)
        
        // Remove the extra elements from the end of the array.
        self.removeLast(indicesToRemove.count)
        
        return removedElements
    }
}

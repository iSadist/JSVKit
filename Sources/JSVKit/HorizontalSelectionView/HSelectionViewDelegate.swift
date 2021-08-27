//
//  HSelectionViewDelegate.swift
//  BucketBuddy
//
//  Created by Jan Svensson on 2021-03-08.
//

import Foundation

public protocol HSelectionViewDelegate: AnyObject {
    /// Called when an item was selected
    /// - Parameters:
    ///   - view: The selection view where the item is
    ///   - item: The item that was selected
    @available(iOS 11.0, *)
    func didSelect(_ view: HSelectionView, item: SelectableItem)
    /// Called when an item is deselected
    /// - Parameters:
    ///   - view: The selection view where the item is
    ///   - item: The item that was selected
    @available(iOS 11.0, *)
    func didDeselect(_ view: HSelectionView, item: SelectableItem)
    /// Decides if the HSelectionView can deselect a selected item and have no items selected.
    /// - Parameter view: The item that was selected
    @available(iOS 11.0, *)
    func canDeselect(_ view: HSelectionView) -> Bool
}

extension HSelectionViewDelegate {
    /// Called when an item is deselected
    /// - Parameters:
    ///   - view: The selection view where the item is
    ///   - item: The item that was selected
    @available(iOS 11.0, *)
    public func didDeselect(_ view: HSelectionView, item: SelectableItem) {}
    /// Decides if the HSelectionView can deselect a selected item and have no items selected.
    /// - Parameter view: The item that was selected
    /// - Returns: True if can deselect, otherwise false
    @available(iOS 11.0, *)
    public func canDeselect(_ view: HSelectionView) -> Bool { true }
}

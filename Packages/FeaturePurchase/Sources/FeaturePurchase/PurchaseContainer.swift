//
//  PurchaseContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 23.08.2026.
//

import Foundation

public final class PurchaseContainer {
    public init() {}

    lazy var purchaseProvider = RevenueCatProvider()
}
// TODO: - в рут координаторе дергать sheet paywall, и после создавать revenueCatSheet, у которого будет своя вьюмодель, вьюшки, и свои юз кейсы, которые должны будут проверять, когда именно показать paywall

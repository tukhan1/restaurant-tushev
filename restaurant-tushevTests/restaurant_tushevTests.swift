//
//  restaurantTests.swift
//  restaurantTests
//
//  Created by Egor Tushev on 13.11.2023.
//

import XCTest
import SnapshotTesting
@testable import restaurant_tushev

private struct TestObjects {
    static let recommendations: [MasterClass] = [
    MasterClass(title: "test1", description: "test1", imageUrl: "", date: "", recipeUrl: ""),
    MasterClass(title: "test2", description: "test2", imageUrl: "", date: "", recipeUrl: "")
    ]
    static let banners: [Banner] = [
        Banner(imageUrl: "", title: "test1", description: "test1", activeUrl: ""),
        Banner(imageUrl: "", title: "test2", description: "test2", activeUrl: ""),
    ]
    static let menuSections: [MenuSection] = [
        MenuSection(title: "Test", products: [
            Product(title: "test1", cost: "230", weight: "222", imageUrl: ""),
            Product(title: "test2", cost: "999", weight: "111", imageUrl: ""),
            Product(title: "test3", cost: "123", weight: "321", imageUrl: "")
        ]),
        MenuSection(title: "Test", products: [
            Product(title: "test1", cost: "230", weight: "222", imageUrl: ""),
            Product(title: "test2", cost: "999", weight: "111", imageUrl: ""),
            Product(title: "test3", cost: "123", weight: "321", imageUrl: "")
        ])
    ]
}

final class ViewControllerSnapshotTests: XCTestCase {
    
    let isRecording = true

    func testMainViewControllerAppearance() {
        let vc = MainVC(recommendations: TestObjects.recommendations, banners: TestObjects.banners, loyaltyPoints: 200)
        verifyViewController(vc, isRecording: isRecording, wait: 0.05)
    }

    func testOrderViewControllerAppearance() {
        let vc = OrderVC(menu: TestObjects.menuSections)
        verifyViewController(vc, isRecording: isRecording, wait: 0.05
        )
    }
}

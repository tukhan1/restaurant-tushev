//
//  UIViewControllerTests.swift
//  restaurantTests
//
//  Created by Egor Tushev on 13.11.2023.
//

import SnapshotTesting
import XCTest

extension XCTestCase {
    func verifyViewController(
        _ viewController: UIViewController?,
        testName: String = "",
        isRecording: Bool = false,
        wait: CGFloat = 0
    ) {
        guard let viewController = viewController else { return }
        let devices: [String: ViewImageConfig] = [
            "iPhoneX": .iPhoneX,
            "iPhoneXsMax": .iPhoneXsMax,
            "iPhone13Mini": .iPhone13Mini,
            "iPhone13Pro": .iPhone13Pro,
            "iPhone13ProMax": .iPhone13ProMax,
        ]

        let name = testName != "" ? "\(getScreenName(viewController))-\(testName)" : getScreenName(viewController)
        let results = devices.map { device in
            verifySnapshot(
                matching: viewController,
                as: .wait(for: wait, on: .image(on: device.value)),
                named: "\(device.key)",
                record: isRecording,
                testName: name
            )
        }
        results.forEach { XCTAssertNil($0) }
    }
    
    private func getScreenName(_ viewController: UIViewController) -> String {
        if let navigationController = viewController as? UINavigationController,
        let firstViewController = navigationController.viewControllers.first {
            return "\(String(describing: type(of: firstViewController.self)))"
        }
        return "\(String(describing: type(of: viewController.self)))"
    }
}

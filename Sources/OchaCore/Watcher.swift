//
//  Entrypoint.swift
//  OchaCore
//
//  Created by Yudai.Hirose on 2019/03/01.
//

import Foundation

public typealias CallBack = (URL) -> Void
public class Presenter: NSObject, NSFilePresenter {
    public let presentedItemURL: URL?
    public let presentedItemOperationQueue: OperationQueue = .main
    
    internal var callback: CallBack?

    internal init(presentedItemURL: URL) {
        self.presentedItemURL = presentedItemURL
    }
    
    public func savePresentedItemChanges(completionHandler: @escaping (Error?) -> Void) {
        callback?(presentedItemURL!)
        print(#function)
        completionHandler(nil)
    }
    
    public func presentedItemDidGain(_ version: NSFileVersion) {
        print(#function)
        print(version)
    }
}

public class Watcher {
    private let paths: [String]
    private let presenters: [Presenter]
    
    public init(paths: [Pathable]) {
        self.paths = paths.map { $0.pathForWatching().absoluteString }
        self.presenters = paths
            .map { $0.pathForWatching() }
            .map(Presenter.init(presentedItemURL:))
    }
    
    public func start(_ callback: @escaping CallBack) {
        presenters.forEach {
            $0.callback = callback
            NSFileCoordinator.addFilePresenter($0)
        }
    }
}

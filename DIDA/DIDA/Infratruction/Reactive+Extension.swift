//
//  Reactive+Extension.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
extension Reactive where Base: UICollectionViewDiffableDataSource<Int, HomeSectionType> {
    func snapshot() -> Binder<NSDiffableDataSourceSnapshot<Int, HomeSectionType>> {
        return Binder(self.base) { dataSource, snapshot in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

//add a tap gesture recognizer to a UIView
extension Reactive where Base: UIView {
    var tapGesture: ControlEvent<Void> {
        let tapRecognizer = UITapGestureRecognizer()
        base.addGestureRecognizer(tapRecognizer)

        let controlEvent = ControlEvent<Void>(events: tapRecognizer.rx.event.map { _ in })
        return controlEvent
    }
}

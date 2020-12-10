//
//  MapSnapShotSubscription.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/10.
//

import Combine
import Foundation
import MapKit

class MapSnapShotSubscription<S: Subscriber>: Subscription where S.Input == Data?, S.Failure == Error {
    private var subscriber: S?
    private let snapshotter: MKMapSnapshotter
    private let processor: MapSnapShotProcessor
    private let queue = DispatchQueue(label: "MapSnapShot", qos: .background, attributes: .concurrent)

    init(subscriber: S, snapshotter: MKMapSnapshotter, processor: MapSnapShotProcessor) {
        self.subscriber = subscriber
        self.snapshotter = snapshotter
        self.processor = processor
        start()
    }

    func request(_: Subscribers.Demand) {}

    func cancel() {
        snapshotter.cancel()
        subscriber = nil
    }

    private func start() {
        snapshotter.start(with: queue) { [subscriber, processor, queue] snapshot, error in
            dispatchPrecondition(condition: .onQueue(queue))
            if let error = error {
                subscriber?.receive(completion: .failure(error))
            } else {
                _ = subscriber?.receive(processor.process(snapShot: snapshot))
            }
        }
    }
}

struct MapSnapShotPublisher: Publisher {
    typealias Output = Data?
    typealias Failure = Error

    private let snapshotter: MKMapSnapshotter
    private let processor: MapSnapShotProcessor

    init(snapshotter: MKMapSnapshotter, processor: MapSnapShotProcessor) {
        self.snapshotter = snapshotter
        self.processor = processor
    }

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = MapSnapShotSubscription(
            subscriber: subscriber,
            snapshotter: snapshotter,
            processor: processor
        )
        subscriber.receive(subscription: subscription)
    }
}

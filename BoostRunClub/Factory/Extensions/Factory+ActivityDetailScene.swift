//
//  Factory+ActivityDetailScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol ActivityDetailSceneFactory {
    // func makeActivityDetailVC()
    // func makeActivityDetailVM()
}

extension DependencyFactory: ActivityDetailSceneFactory {}

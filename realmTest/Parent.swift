//
//  Parent.swift
//  realmTest
//
//  Created by Leon Tuček on 29/04/2019.
//  Copyright © 2019 Leon Tuček. All rights reserved.
//

import Foundation
import RealmSwift

class Parent: Object {
    @objc dynamic var id: String = ""
    let children = List<Child>()
}

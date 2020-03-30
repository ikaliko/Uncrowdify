//
//  Store.swift
//  Uncrowdify
//
//  Created by Ilia Kaliko on 3/29/20.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct Store: Codable {
    //var id: String
    var name: String
    var street: String
    var city: String
    var state: String
    var zip: String
    var location: GeoPoint
    var capacity: Double
    var area: Double
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

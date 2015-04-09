////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import XCTest
import Realm

class SwiftPropertyTypeTest: SwiftTestCase {
    
    func testLongType() {
        let longNumber = 17179869184
        let intNumber = 2147483647
        let negativeLongNumber = -17179869184
        let updatedLongNumber = 8589934592
        
        let realm = realmWithTestPath()
        
        realm.beginWriteTransaction()
        SwiftIntObject.createInRealm(realm, withObject: [longNumber])
        SwiftIntObject.createInRealm(realm, withObject: [intNumber])
        SwiftIntObject.createInRealm(realm, withObject: [negativeLongNumber])
        realm.commitWriteTransaction()
        
        let objects = SwiftIntObject.allObjectsInRealm(realm)
        XCTAssertEqual(objects.count, UInt(3), "3 rows expected")
        XCTAssertEqual((objects[0] as! SwiftIntObject).intCol, longNumber, "2 ^ 34 expected")
        XCTAssertEqual((objects[1] as! SwiftIntObject).intCol, intNumber, "2 ^ 31 - 1 expected")
        XCTAssertEqual((objects[2] as! SwiftIntObject).intCol, negativeLongNumber, "-2 ^ 34 expected")
        
        realm.beginWriteTransaction()
        (objects[0] as! SwiftIntObject).intCol = updatedLongNumber
        realm.commitWriteTransaction()
        
        XCTAssertEqual((objects[0] as! SwiftIntObject).intCol, updatedLongNumber, "After update: 2 ^ 33 expected")
    }

    func testIntSizes() {
        let realm = realmWithTestPath()

        let v16 = Int16(1) << 12
        let v32 = Int32(1) << 30
        // 1 << 40 doesn't auto-promote to Int64 on 32-bit platforms
        let v64 = Int64(1) << 40
        realm.transactionWithBlock() {
            let obj = SwiftAllIntSizesObject()

            obj.int16 = v16
            XCTAssertEqual(obj.int16, v16)
            obj.int32 = v32
            XCTAssertEqual(obj.int32, v32)
            obj.int64 = v64
            XCTAssertEqual(obj.int64, v64)

            realm.addObject(obj)
        }

        let obj = SwiftAllIntSizesObject.allObjectsInRealm(realm)[0]! as! SwiftAllIntSizesObject
        XCTAssertEqual(obj.int16, v16)
        XCTAssertEqual(obj.int32, v32)
        XCTAssertEqual(obj.int64, v64)
    }

    func testIntSizes_objc() {
        let realm = realmWithTestPath()

        let v16 = Int16(1) << 12
        let v32 = Int32(1) << 30
        // 1 << 40 doesn't auto-promote to Int64 on 32-bit platforms
        let v64 = Int64(1) << 40
        realm.transactionWithBlock() {
            let obj = AllIntSizesObject()

            obj.int16 = v16
            XCTAssertEqual(obj.int16, v16)
            obj.int32 = v32
            XCTAssertEqual(obj.int32, v32)
            obj.int64 = v64
            XCTAssertEqual(obj.int64, v64)

            realm.addObject(obj)
        }

        let obj = AllIntSizesObject.allObjectsInRealm(realm)[0]! as! AllIntSizesObject
        XCTAssertEqual(obj.int16, v16)
        XCTAssertEqual(obj.int32, v32)
        XCTAssertEqual(obj.int64, v64)
    }
}

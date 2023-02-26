//
//  Bucket.swift
//  Bucketlist
//
//  Created by 라완 💕 on 03/05/1444 AH.
//

import Foundation
import CoreData

extension BucketListItem {
    @nonobjc public class override func fetchRequest() -> NSFetchRequest<BucketListItem> {
        return NSFetchRequest<BucketListItem>(entityName: "BucketListItem")
    }
    @NSManaged public var text: String
}

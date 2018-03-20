//
//  Tweet+CoreDataProperties.swift
//  Twitter
//
//  Created by robin on 2018-03-17.
//  Copyright © 2018 robin. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }

    @NSManaged public var text: String?
    @NSManaged public var user: User?

}

//
//  Places+CoreDataProperties.swift
//  appStudy
//
//  Created by Clement  Wekesa on 05/11/2020.
//
//

import Foundation
import CoreData


extension Places {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Places> {
        return NSFetchRequest<Places>(entityName: "Places")
    }

    @NSManaged public var name: String?
    @NSManaged public var lon: Double
    @NSManaged public var lat: Double

}

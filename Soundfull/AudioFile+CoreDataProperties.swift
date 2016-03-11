//
//  AudioFile+CoreDataProperties.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/11/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AudioFile {

    @NSManaged var title: String?
    @NSManaged var discURL: String?
    @NSManaged var category: String?

}

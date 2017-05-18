//
//  NoteCell+CoreDataProperties.swift
//  MADCalendarNoteApp
//
//  Created by braedon graika on 4/15/17.
//  Copyright © 2017 braedon graika. All rights reserved.
//

import Foundation
import CoreData


extension NoteCell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteCell> {
        return NSFetchRequest<NoteCell>(entityName: "NoteCell");
    }


}

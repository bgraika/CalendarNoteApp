//
//  NoteCell+CoreDataClass.swift
//  MADCalendarNoteApp
//
//  Created by braedon graika on 4/15/17.
//  Copyright © 2017 braedon graika. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NoteCell)
public class NoteCell: NSManagedObject
{
    @NSManaged var month: String!
    @NSManaged var day: Int32
    @NSManaged var noteView: UITextView!
    @NSManaged var cellImage: UIImage!
}

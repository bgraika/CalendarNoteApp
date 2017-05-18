//
//  CollectionViewCell.swift
//  MADCalendarNoteApp
//
//  Created by braedon graika on 4/4/17.
//  Copyright © 2017 braedon graika. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CollectionViewCell: UICollectionViewCell{

    var noteText = ""
    var noteView: UITextView!
    @IBOutlet weak var myLabel: UILabel!

    @IBOutlet weak var cellImageView: UIImageView!
}

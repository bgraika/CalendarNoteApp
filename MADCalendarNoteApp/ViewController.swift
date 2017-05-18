//
//  ViewController.swift
//  MADCalendarNoteApp
//
//  Created by braedon graika on 4/4/17.
//  Copyright © 2017 braedon graika. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var currentDate: Date!
    var currentCalendar: Calendar!
    var numDaysInMonth: Int!
    var currentMonth: String!
    var firstWeekday: Int!
    var selectedCell: CollectionViewCell!
    var selectedDay: Int!
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var noteCellsInMonth: [Int: NoteCell] = [:]
    var labelViews: [UILabel] = []
    
    @IBOutlet weak var currentCellTextView: UITextView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollection: UICollectionView!

    
    // MARK: - Custom functions
    
    // sets the current Date value to currentMonth + monthsAway
    // also sets the monthLabel
    func setDateValues(date: Date, calendar: Calendar, monthsAway: Int)
    {
        
        self.currentDate = calendar.date(byAdding: .month, value: monthsAway, to: date)
        let components = calendar.dateComponents([.year, .month, .day], from: self.currentDate)
        let range = calendar.range(of: .day, in: .month, for: self.currentDate)!
    
        // Get first weekday of month
        let firstDayComponents = calendar.dateComponents([.year, .month], from: self.currentDate)
        let firstDay = calendar.date(from: firstDayComponents)
        self.firstWeekday = calendar.component(.weekday, from: firstDay!) - 1
        print("First Weekday: \(firstWeekday)!")
        
        self.numDaysInMonth = range.count
        self.currentMonth = calendar.monthSymbols[Int(components.month!) - 1]
        self.monthLabel.text = self.currentMonth
    }
    
    func addOrSetNoteCell(month: String, day: Int, newView: UITextView, image: UIImage) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCell")
        var found = false;
        var noteCells: [NSManagedObject]!
        do {
            noteCells = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getNoteCells error: \(error)")
        }
        print("Found \(noteCells.count) noteCells")
        for noteCell in noteCells {
            let nMonth = noteCell.value(forKey: "month") as! String
            let nDay = noteCell.value(forKey: "day") as! Int
            let nView = noteCell.value(forKey: "noteView") as! UITextView
            print(" Found noteCell with month \(month) with day \(day) count: \(view.subviews.count)")
            
            if(month == nMonth && day == nDay)
            {
                noteCell.setValue(month, forKey: "month")
                noteCell.setValue(day, forKey: "day")
                noteCell.setValue(newView, forKey: "noteView")
                noteCell.setValue(image, forKey: "cellImage")
                found = true;
            }
        }
        
        if(found == false)
        {
            let noteCell = NSEntityDescription.insertNewObject(forEntityName: "NoteCell", into: self.managedObjectContext)
            noteCell.setValue(month, forKey: "month")
            noteCell.setValue(day, forKey: "day")
            noteCell.setValue(newView, forKey: "noteView")
            noteCell.setValue(image, forKey: "cellImage")
        }
        self.appDelegate.saveContext()
    }
    
    func addNoteCell()
    {
        let noteCell = NSEntityDescription.insertNewObject(forEntityName: "NoteCell", into: self.managedObjectContext)
        noteCell.setValue(currentMonth, forKey: "month")
        noteCell.setValue(selectedDay, forKey: "day")
        noteCell.setValue(selectedCell.noteView, forKey: "noteView")
        self.appDelegate.saveContext()
    }
    
    func deleteAllNoteCells()
    {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCell")
//        var noteCells: [NSManagedObject]!
//        do {
//            noteCells = try self.managedObjectContext.fetch(fetchRequest)
//        } catch {
//            print("getNoteCells error: \(error)")
//        }
//        print("Found \(noteCells.count) noteCells")
//        for noteCell in noteCells {
//            self.managedObjectContext.delete(noteCell)
//        }
//        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "NoteCell"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
        self.appDelegate.saveContext()
    }
    
    func setNoteCellsInMonth() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteCell")
        var noteCells: [NSManagedObject]!
        do {
            noteCells = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getNoteCells error: \(error)")
        }
        print("Found \(noteCells.count) noteCells")
        self.noteCellsInMonth = [:] //clear out noteCellsInMonth
        for noteCell in noteCells {
            let month = noteCell.value(forKey: "month") as! String
            let day = noteCell.value(forKey: "day") as! Int
            let view = noteCell.value(forKey: "noteView") as! UITextView
            print(" Found noteCell with month \(month) with day \(day) count: \(view.subviews.count)")
            
            if(month == self.currentMonth)
            {
                noteCellsInMonth[day] = noteCell as? NoteCell
            }
        }
    }
    
    func setMonthLabels(width: CGFloat)
    {
        let dayNames = ["S", "M", "T", "W", "T", "F", "S"]
        let w = width / 2
        let y = self.calendarCollection.frame.origin.y - 30
        var x = self.calendarCollection.frame.origin.x + w
        var i = 0
        var j = 0

        //remove all previous month labels
        while(j < self.labelViews.count)
        {
            self.labelViews[j].removeFromSuperview()
            j = j + 1
        }
        
        // add new month labels based on size of screen and cells
        while(i < 7)
        {
            var label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            label.center = CGPoint(x: x, y: y)
            label.textAlignment = .center
            label.text = dayNames[i]
            self.view.addSubview(label)
            self.labelViews.append(label)
            
            i = i + 1
            x = x + width
        }
    }
    
    // MARK: - App Actions
    
    //transitions to draw menu to add a picture to the cell
    @IBAction func addCellPictureClick(_ sender: UIButton) {
        performSegue(withIdentifier: "drawImageSegue", sender: nil)
    }
    
    // segue to edit note screen of selected cell
    @IBAction func editNoteClick(_ sender: UIButton) {
        if(self.selectedCell != nil)
        {
            performSegue(withIdentifier: "editNotesSegue", sender: nil)
        }
    }
    
    // Move to next month
    @IBAction func nextMonthClick(_ sender: UIButton) {
        setDateValues(date: currentDate, calendar: currentCalendar, monthsAway: 1)
        setNoteCellsInMonth()
        calendarCollection.reloadData() // refresh collection after month has been changed
    }
    
    // Move to previous month
    @IBAction func lastMonthClick(_ sender: UIButton) {
        setDateValues(date: currentDate, calendar: currentCalendar, monthsAway: -1)
        setNoteCellsInMonth()
        calendarCollection.reloadData() // refresh collection after month has been changed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editNotesSegue"){
            let vc = segue.destination as! NoteViewController
            vc.selectedCell = self.selectedCell
        }
    }
    
    @IBAction func unwindFromEditNotes (sender: UIStoryboardSegue) {
        let secondViewController = sender.source as! NoteViewController
        
        // make sure user wants to save their joke
        if(secondViewController.cancelled == false){
            selectedCell.noteText = secondViewController.noteText
            selectedCell.noteView = secondViewController.textView
            print("Note Text: \(selectedCell.noteText)")
            self.addNoteCell()
        }
    }
    
    // Check if an image has been made and if so set it as the cover image for that cell
    @IBAction func unwindFromDrawView (sender: UIStoryboardSegue) {
        let secondViewController = sender.source as! drawViewController
        
        // make sure user wants to save their drawing
        if(secondViewController.cancelled == false){
            let image1 = secondViewController.drawImageView.image
            selectedCell.cellImageView.image = image1
            selectedCell.cellImageView.highlightedImage = nil
            selectedCell.cellImageView.isHighlighted = false
            
            var view1 = UITextView()
            if(self.selectedCell.noteView != nil)
            {
                view1 = self.selectedCell.noteView
            }
            addOrSetNoteCell(month: self.currentMonth, day: self.selectedDay, newView: view1, image: image1!)
        }
    }
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numDaysInMonth + self.firstWeekday
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
     
        // *** Display day number in each cell's label ***
        cell.myLabel.text = ""
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.cellImageView.image = nil
        // print blank cells until reaching first weekday of month
        if(indexPath.item >= self.firstWeekday)
        {
            let day = indexPath.item + 1 - self.firstWeekday
            let noteCell = noteCellsInMonth[day]
            
            cell.noteView = nil
            if(noteCell != nil)
            {
                cell.noteView = noteCell?.noteView
                if(cell.cellImageView != nil)
                {
                    cell.cellImageView.image = noteCell?.cellImage
                }
            }
            cell.myLabel.text = String(day)
            cell.backgroundColor = UIColor.cyan
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.black.cgColor
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        //set selected cell border color to red
        cell.layer.borderColor = UIColor.yellow.cgColor
        
        //set old selected cell border color to black
        if(self.selectedCell != nil)
        {
            self.selectedCell.layer.borderColor = UIColor.black.cgColor
        }
        
        self.selectedCell = cell
        self.selectedDay = indexPath.item - self.firstWeekday + 1
        print("You selected cell #\(indexPath.item)!")
        print("width #\(cell.bounds.width)")
        
        // set the text of the selected cell view box
        if(self.selectedCell.noteView != nil)
        {
            self.currentCellTextView.text = self.selectedCell.noteView.text
        }
        
        //performSegue(withIdentifier: "editNotesSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view, typically from a nib.
        
        currentCalendar = Calendar.current
        currentDate = Date()
        //deleteAllNoteCells()
        setDateValues(date: currentDate, calendar: currentCalendar, monthsAway: 0)
        setNoteCellsInMonth() //get array of noteCells from Core Data
        selectedCell = nil
        currentCellTextView.layer.borderWidth = 1
        currentCellTextView.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // on orientation change, reload collection view in order to get correct cell widths and labels
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        calendarCollection.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayou
    
    // set the size of the cells so there are always 7 columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize {
        
        let screenRect = calendarCollection.bounds
        let screenWidth = screenRect.size.width;
        let cellWidth = screenWidth / 7.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size = CGSize(width: cellWidth, height: cellWidth);
        self.setMonthLabels(width: cellWidth)
        
        return size;
    }


}


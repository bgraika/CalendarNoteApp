//
//  NoteViewController.swift
//  MADCalendarNoteApp
//
//  Created by braedon graika on 4/4/17.
//  Copyright © 2017 braedon graika. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {

    var selectedCell: CollectionViewCell!
    var noteText: String!
    var cancelled: Bool!
    var cursor: CGPoint!
    var paths = [UIBezierPath]()
    var drawImageView: UIImageView!
    var textView: UITextView!
    
    @IBOutlet weak var drawButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "drawViewSegue"){
            let vc = segue.destination as! drawViewController
            vc.text = textView.text
            vc.cursor = cursor
        }
    }
    
    // Check if an image has been made and if so add it to the view as a subview
    @IBAction func unwindFromDrawView (sender: UIStoryboardSegue) {
        let secondViewController = sender.source as! drawViewController
        print("TextView text: \(textView.text)")
        //self.textView.text = secondViewController.text
        
        // make sure user wants to save their drawing
        if(secondViewController.cancelled == false){
            let image1 = secondViewController.drawImageView.image
            drawImageView = UIImageView(image: image1)
            
            print("frame size1: \(drawImageView.frame.width), \(drawImageView.frame.height)")
            drawImageView.frame = CGRect(x: cursor.x, y: cursor.y, width: 100, height: 200)
            print("frame Orgins: \(drawImageView.frame.origin.x), \(drawImageView.frame.origin.y)")
            print("frame size: \(drawImageView.frame.width), \(drawImageView.frame.height)")
            
            let path = UIBezierPath(rect: CGRect(x: cursor.x, y: cursor.y, width: drawImageView.frame.width, height: drawImageView.frame.height))
            paths.append(path)
            textView.textContainer.exclusionPaths = paths
            textView.addSubview(drawImageView)
            print("subView Count: \(textView.subviews.count)")
        }
    }
    
    @IBAction func sketchClick(_ sender: UIButton) {
        performSegue(withIdentifier: "drawViewSegue", sender: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        self.textView.resignFirstResponder()
        self.noteText = self.textView.text
        
        performSegue(withIdentifier: "unwindFromEditNotes", sender: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.textView.resignFirstResponder()
        self.cancelled = true
        
        performSegue(withIdentifier: "unwindFromEditNotes", sender: nil)
    }
    
    // update cursor position when it changes
    func textViewDidChange(_ textView: UITextView) {
        self.cursor = textView.caretRect(for: (textView.selectedTextRange?.start)!).origin
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if this is the first time rendering this cell then
        // create a new textView that will store the notes
        // else; use the cell's stored textView
        let y = drawButton.frame.origin.y + 25;
        if(selectedCell.noteView != nil)
        {
            textView = selectedCell.noteView
        }
        else{
            textView = UITextView(frame: CGRect(x: 20.0, y: y, width: self.view.frame.width - 20, height: self.view.frame.height - 175))
        }
        
        textView.frame = CGRect(x: 20.0, y: y, width: self.view.frame.width - 20, height: self.view.frame.height - 175)
        
        self.view.addSubview(textView)
        textView.delegate = self
        cancelled = false
        self.cursor = textView.caretRect(for: (textView.selectedTextRange?.start)!).origin
        self.textView.isUserInteractionEnabled = true
        self.textView.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        //textView.text = selectedCell.noteText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

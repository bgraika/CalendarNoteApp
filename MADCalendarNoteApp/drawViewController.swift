//
//  drawViewController.swift
//  MADCalendarNoteApp
//
//  Created by braedon graika on 4/5/17.
//  Copyright © 2017 braedon graika. All rights reserved.
//

import UIKit

class drawViewController: UIViewController {

    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    var cancelled = false
    var text: String!
    var cursor: CGPoint!
    
    @IBOutlet weak var drawImageView: UIImageView!
 
    @IBAction func saveClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromDrawView", sender: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = false
        if let touch = touches.first{
            lastPoint = touch.location(in: self.drawImageView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = true;
        if let touch = touches.first{
            let currentPoint = touch.location(in: self.drawImageView)
            UIGraphicsBeginImageContext(self.drawImageView.frame.size)
            let ctx = UIGraphicsGetCurrentContext()
            self.drawImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawImageView.frame.size.width, height: self.drawImageView.frame.size.height))
            ctx?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            ctx?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            ctx?.setLineCap(CGLineCap.round)
            ctx?.setLineWidth(9.0)
            ctx?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            ctx?.strokePath()
            self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isSwiping)
        {
            UIGraphicsBeginImageContext(self.drawImageView.frame.size)
            let ctx = UIGraphicsGetCurrentContext()
            self.drawImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawImageView.frame.size.width, height: self.drawImageView.frame.size.height))
            ctx?.setLineCap(CGLineCap.round)
            ctx?.setLineWidth(9.0)
            ctx?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            ctx?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            ctx?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            ctx?.strokePath()
            self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
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

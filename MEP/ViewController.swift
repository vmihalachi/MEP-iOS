//
//  ViewController.swift
//  MEP
//
//  Created by Vlad Mihalachi on 25/01/15.
//  Copyright (c) 2015 Maskyn. All rights reserved.
//

import UIKit
import Realm

class ViewController: UITableViewController {
    
    var persone : RLMResults!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get the default Realm
        let realm = RLMRealm.defaultRealm()
        persone = PersonaRealm.allObjects().sortedResultsUsingProperty("punti", ascending: false)
        if persone.count <= 0 {
            
            fillData()
            
            persone = PersonaRealm.allObjects()
        }        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Int(self.persone.count)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chiama(indexPath.row)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        // Configure the cell...
        let persona = persone.objectAtIndex(UInt(indexPath.row)) as! PersonaRealm
        
        var testoNome = "\(persona.nome)"
                
        for _ in count(testoNome) ... 30 {
            testoNome += " "
        }
        
        
        var title = "\(testoNome)"
        var subtitle = "punti:  \(persona.punti)  \t\t\t\t commissione:  \(persona.commissione) \t\t\t\t sezione:  \(persona.sezione)"
        
        // set the text
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        
        return cell
    }



    @IBAction func nuovaRisoluzione(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Nuova risoluzione?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Si", style: .Default, handler: { (action) -> Void in
        
            // Get the default Realm
            let realm = RLMRealm.defaultRealm()
            // You only need to do this once (per thread)
            
            // Add to the Realm inside a transaction
            realm.beginWriteTransaction()
            
        for index in 0 ..< self.persone.count {
            let persona = persone.objectAtIndex(index) as! PersonaRealm
            persona.punti += 300
        }
            
            realm.commitWriteTransaction()
            
        self.persone = PersonaRealm.allObjects().sortedResultsUsingProperty("punti", ascending: false)
        
        self.tableView.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    @IBAction func reset(sender: AnyObject) {
        
         var inputTextField: UITextField?
        
        let alert = UIAlertController(title: "Reset?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Si", style: .Default, handler: { (action) -> Void in
            
            if inputTextField!.text == "1477" {
                // Get the default Realm
                let realm = RLMRealm.defaultRealm()
                
                realm.beginWriteTransaction()
                
                realm.deleteAllObjects()
                
                realm.commitWriteTransaction()
                
                self.fillData()
                
                self.persone = PersonaRealm.allObjects().sortedResultsUsingProperty("punti", ascending: false)
                
                self.tableView.reloadData()

            }
        })
        
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
            inputTextField?.placeholder = "Scrivi 1477"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        
        
        var chiama = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Chiama", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                self.chiama(indexPath.row)
                return
        })
        
        chiama.backgroundColor = UIColor(red: 0.24, green: 0.44, blue: 0.65, alpha: 1)
        
        return [chiama]
    }
    
    func chiama (index : Int) {
        let persona = persone.objectAtIndex(UInt(index)) as! PersonaRealm
        
        if persona.punti <= 0 {
            return
        }
        
        let alert = UIAlertController(title: "Vuoi chiamare \(persona.nome)", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Si", style: .Default, handler: { (action) -> Void in
            
            // Get the default Realm
            let realm = RLMRealm.defaultRealm()
            // You only need to do this once (per thread)
            
            // Add to the Realm inside a transaction
            realm.beginWriteTransaction()
            
            persona.punti -= 50
            //persona.interventiFatti++
            
            realm.commitWriteTransaction()
            
            var commissione = persona.commissione
            var sezione = persona.sezione
            
            var personeCommissione = PersonaRealm.objectsWhere("commissione == \(commissione)")
            var personeSezione = PersonaRealm.objectsWhere("sezione == '\(sezione)'")
            
            for index in 0 ..< personeCommissione.count {
                
                realm.beginWriteTransaction()
                
                var persona2 = personeCommissione.objectAtIndex(index) as! PersonaRealm
                
                persona2.punti -= 5
                
                realm.commitWriteTransaction()
            }
            
            for index in 0 ..< personeSezione.count {
                
                realm.beginWriteTransaction()
                
                var persona2 = personeSezione.objectAtIndex(index) as! PersonaRealm
                
                persona2.punti -= 3
                
                if persona2.punti < 0 {
                    persona2.punti = 0
                }
                
                
                
                realm.commitWriteTransaction()
            }
            
            
            
            self.persone = PersonaRealm.allObjects().sortedResultsUsingProperty("punti", ascending: false)
            
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fillData() {
        
        // Get the default Realm
        let realm = RLMRealm.defaultRealm()
    
        var personeCreator = [
            PersonaCreator(nome:"Pasquali Ettore", sezione:"A", commissione:1),
            PersonaCreator(nome:"Akun Abigail", sezione:"A", commissione:1),
            PersonaCreator(nome:"Baraldi Alice", sezione:"B", commissione:1),
            PersonaCreator(nome:"Bighi Elisa", sezione:"F", commissione:1),
            PersonaCreator(nome:"Bisero Sofia", sezione:"N", commissione:1),
            PersonaCreator(nome:"Blagojevic Marija", sezione:"O", commissione:1),
            PersonaCreator(nome:"De Simone Francesco", sezione:"P", commissione:1),
            PersonaCreator(nome:"Fiorini Matilde", sezione:"P", commissione:1),
            PersonaCreator(nome:"Marcello Vittorio", sezione:"Q", commissione:1),
            PersonaCreator(nome:"Sgarbi Alessandro", sezione:"S", commissione:1),
            PersonaCreator(nome:"Zecchi Tommaso", sezione:"F", commissione:1),
            PersonaCreator(nome:"De Vincenti Gaia", sezione:"T", commissione:2),
            PersonaCreator(nome:"Regragui Najma", sezione:"R", commissione:2),
            PersonaCreator(nome:"Tartari Alessandro", sezione:"Q", commissione:2),
            PersonaCreator(nome:"Aceto Elena", sezione:"P", commissione:2),
            PersonaCreator(nome:"Visentin Nicola", sezione:"P", commissione:2),
            PersonaCreator(nome:"Zucchini Gloria", sezione:"N", commissione:2),
            PersonaCreator(nome:"Salcuni Claudia", sezione:"F", commissione:2),
            PersonaCreator(nome:"Ghinato Claudia", sezione:"B", commissione:2),
            PersonaCreator(nome:"Introini Elisa", sezione:"A", commissione:2),
            PersonaCreator(nome:"Cibienne Maria Chiara", sezione:"N", commissione:2),
            PersonaCreator(nome:"Ravagli Silvia", sezione:"A", commissione:3),
            PersonaCreator(nome:"Marchetti Victoria", sezione:"B", commissione:3),
            PersonaCreator(nome:"Santimone Olivia", sezione:"F", commissione:3),
            PersonaCreator(nome:"Romeo Federica", sezione:"F", commissione:3),
            PersonaCreator(nome:"Bottoni Chiara", sezione:"Q", commissione:3),
            PersonaCreator(nome:"Della Vedova Francesco", sezione:"R", commissione:3),
            PersonaCreator(nome:"Montalbano Mia", sezione:"A", commissione:4),
            PersonaCreator(nome:"Stefanelli Edoardo", sezione:"B", commissione:4),
            PersonaCreator(nome:"Tella Ilaria", sezione:"F", commissione:4),
            PersonaCreator(nome:"Gasparetto Michele", sezione:"P", commissione:4),
            PersonaCreator(nome:"Melloni Matteo", sezione:"Q", commissione:4),
            PersonaCreator(nome:"Cavazzini Kevin", sezione:"Q", commissione:4),
            PersonaCreator(nome:"Sulejmani Fiona", sezione:"S", commissione:4),
            PersonaCreator(nome:"Zagatti Giorgia", sezione:"T", commissione:4),
            PersonaCreator(nome:"Collina Irene", sezione:"T", commissione:4),
            PersonaCreator(nome:"Benini Giovanni", sezione:"B", commissione:5),
            PersonaCreator(nome:"Gualandi Vittoria", sezione:"F", commissione:5),
            PersonaCreator(nome:"Cenci Silvia", sezione:"F", commissione:5),
            PersonaCreator(nome:"Malacarne Miriam", sezione:"F", commissione:5),
            PersonaCreator(nome:"Naldi Linda", sezione:"P", commissione:5),
            PersonaCreator(nome:"Sandri Emiliano", sezione:"Q", commissione:5),
            PersonaCreator(nome:"Zero Cecilia", sezione:"R", commissione:5),
            PersonaCreator(nome:"Zappaterra Sofia", sezione:"T", commissione:5),
            PersonaCreator(nome:"Porto Francesca", sezione:"A", commissione:6),
            PersonaCreator(nome:"Bigoni Elena", sezione:"F", commissione:6),
            PersonaCreator(nome:"Russo Giulia", sezione:"F", commissione:6),
            PersonaCreator(nome:"Visentin Stefano", sezione:"P", commissione:6),
            PersonaCreator(nome:"Pazzi Pierpaolo", sezione:"Q", commissione:6),
            PersonaCreator(nome:"Tassoni Marta", sezione:"R", commissione:6),
            PersonaCreator(nome:"Milcoli Arianna", sezione:"T", commissione:6),
            PersonaCreator(nome:"Dolcetti Maria Vittoria", sezione:"B", commissione:7),
            PersonaCreator(nome:"Marchetti Francesca", sezione:"F", commissione:7),
            PersonaCreator(nome:"Bertoli Matteo", sezione:"N", commissione:7),
            PersonaCreator(nome:"Orsi Michele", sezione:"N", commissione:7),
            PersonaCreator(nome:"Fedozzi Marco", sezione:"P", commissione:7),
            PersonaCreator(nome:"Marchi Lucrezia", sezione:"S", commissione:7),
            PersonaCreator(nome:"Greghi Carlotta", sezione:"T", commissione:7),
            PersonaCreator(nome:"Lazarov Dimitri", sezione:"A", commissione:8),
            PersonaCreator(nome:"Piazzi Sara", sezione:"B", commissione:8),
            PersonaCreator(nome:"Guarise Nina", sezione:"F", commissione:8),
            PersonaCreator(nome:"Pasetti Maria Vittoria", sezione:"F", commissione:8),
            PersonaCreator(nome:"Barison Gregorio", sezione:"N", commissione:8),
            PersonaCreator(nome:"Veronesi Francesca", sezione:"P", commissione:8),
            PersonaCreator(nome:"Calzolari Stefano", sezione:"Q", commissione:8),
            PersonaCreator(nome:"Scarpante Irene", sezione:"S", commissione:8),
            PersonaCreator(nome:"Scanavini Pietro", sezione:"T", commissione:8),
            PersonaCreator(nome:"Chieregato Cecilia", sezione:"A", commissione:9),
            PersonaCreator(nome:"Pasquali Elena", sezione:"B", commissione:9),
            PersonaCreator(nome:"Grossi Caterina", sezione:"F", commissione:9),
            PersonaCreator(nome:"Gualiumi Veronica", sezione:"O", commissione:9),
            PersonaCreator(nome:"Xu Sheng Ran ", sezione:"Q", commissione:9),
            PersonaCreator(nome:"Trecarichi Luca", sezione:"T", commissione:9),
            PersonaCreator(nome:"Carletti Sebasiano", sezione:"B", commissione:10),
            PersonaCreator(nome:"Mora Beatrice", sezione:"F", commissione:10),
            PersonaCreator(nome:"Mazzoni Alberto", sezione:"N", commissione:10),
            PersonaCreator(nome:"Sassoli Valentina", sezione:"Q", commissione:10),
            PersonaCreator(nome:"Romagnoli Nicole", sezione:"Q", commissione:10)
        ]
        
        for persona in personeCreator {
            
            let personaRealm = PersonaRealm()
            
            personaRealm.nome = persona.nome
            personaRealm.sezione = persona.sezione
            personaRealm.commissione = persona.commissione
            personaRealm.interventiFatti = persona.interventiFatti
            personaRealm.punti = persona.punti
            
            realm.transactionWithBlock() {
                realm.addObject(personaRealm)
            }
        }

    }
}


//
//  ViewController.swift
//  MEP
//
//  Created by Vlad Mihalachi on 25/01/15.
//  Copyright (c) 2015 Maskyn. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    let realm = try! Realm()
    var persone : Results<PersonaRealm>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        persone = realm.objects(PersonaRealm).sorted("punti", ascending: false)
        if persone.count <= 0 {
            
            fillData()
            
            persone = realm.objects(PersonaRealm).sorted("punti", ascending: false)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        // Configure the cell...
        let persona = persone[indexPath.row]
        
        var testoNome = "\(persona.nome)"
                
        for _ in testoNome.characters.count ... 30 {
            testoNome += " "
        }
        
        
        let title = "\(testoNome)"
        let subtitle = "punti:  \(persona.punti)  \t\t\t\t commissione:  \(persona.commissione) \t\t\t\t sezione:  \(persona.sezione)"
        
        // set the text
        cell!.textLabel?.text = title
        cell!.detailTextLabel?.text = subtitle
        
        return cell!
    }



    @IBAction func nuovaRisoluzione(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Nuova risoluzione?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Si", style: .Default, handler: { (action) -> Void in
            
            // Add to the Realm inside a transaction
            self.realm.beginWrite()
            
        for index in 0 ..< self.persone.count {
            let persona = self.persone[index]
            persona.punti += 300
        }
            
            try! self.realm.commitWrite()
            
        self.persone = self.realm.objects(PersonaRealm).sorted("punti", ascending: false)
        
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
                
                self.realm.beginWrite()
                
                self.realm.deleteAll()
                
                try! self.realm.commitWrite()
                
                self.fillData()
                
                self.persone = self.realm.objects(PersonaRealm).sorted("punti", ascending: false)
                
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
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
        
        
        let chiama = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Chiama", handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) in
                self.chiama(indexPath.row)
                return
        })
        
        chiama.backgroundColor = UIColor(red: 0.24, green: 0.44, blue: 0.65, alpha: 1)
        
        return [chiama]
    }
    
    func chiama (index : Int) {
        let persona = persone[index]
        
        if persona.punti <= 0 {
            return
        }
        
        let alert = UIAlertController(title: "Vuoi chiamare \(persona.nome)", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Si", style: .Default, handler: { (action) -> Void in
            
            // Add to the Realm inside a transaction
            self.realm.beginWrite()
            
            persona.punti -= 50
            //persona.interventiFatti++
            
            try! self.realm.commitWrite()
            
            let commissione = persona.commissione
            let sezione = persona.sezione
            
            let personeCommissione = self.realm.objects(PersonaRealm).filter("commissione == \(commissione)")
            let personeSezione = self.realm.objects(PersonaRealm).filter("sezione == '\(sezione)'")
            
            for index in 0 ..< personeCommissione.count {
                
                self.realm.beginWrite()
                
                let persona2 = personeCommissione[index]
                
                persona2.punti -= 5
                
                try! self.realm.commitWrite()
            }
            
            for index in 0 ..< personeSezione.count {
                
                self.realm.beginWrite()
                
                let persona2 = personeSezione[index]
                
                persona2.punti -= 3
                
                if persona2.punti < 0 {
                    persona2.punti = 0
                }
                
                
                
                try! self.realm.commitWrite()
            }
            
            
            
            self.persone = self.realm.objects(PersonaRealm).sorted("punti", ascending: false)
            
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fillData() {
    
        let personeCreator = [
            PersonaCreator(nome:"Pinca Federica", sezione:"G", commissione: 1 ),
            PersonaCreator(nome:"Cellini Sofia", sezione:"G", commissione: 1 ),
            PersonaCreator(nome:"Moretti Andrea", sezione:"A", commissione: 1 ),
            PersonaCreator(nome:"Faggioli Giulia", sezione:"A", commissione: 1 ),
            PersonaCreator(nome:"Sassoli Emily", sezione:"H", commissione: 1 ),
            PersonaCreator(nome:"Celli Martina ", sezione:"A", commissione: 2 ),
            PersonaCreator(nome:"Maranini Sofia", sezione:"D", commissione: 2 ),
            PersonaCreator(nome:"Mihalachi Margherita", sezione:"A", commissione: 2 ),
            PersonaCreator(nome:"Rossi Elena Sofia", sezione:"A", commissione: 2 ),
            PersonaCreator(nome:"Rugiero Gionata", sezione:"C", commissione: 2 ),
            PersonaCreator(nome:"Tagliati Manuel", sezione:"I", commissione: 2 ),
            PersonaCreator(nome:"Scotti Guido", sezione:"C", commissione: 3 ),
            PersonaCreator(nome:"Ballo Stefano", sezione:"L", commissione: 3 ),
            PersonaCreator(nome:"Buzzoni Laura", sezione:"C", commissione: 3 ),
            PersonaCreator(nome:"Marini Kevin", sezione:"L", commissione: 3 ),
            PersonaCreator(nome:"Tagliati Mattia", sezione:"L", commissione: 3 ),
            PersonaCreator(nome:"Caselli Matilde", sezione:"C", commissione: 4 ),
            PersonaCreator(nome:"Corazzari Stefania", sezione:"D", commissione: 4 ),
            PersonaCreator(nome:"Guirrini Valentina", sezione:"H", commissione: 4 ),
            PersonaCreator(nome:"Giuffrida Maria Grazia", sezione:"A", commissione: 4 ),
            PersonaCreator(nome:"Malaguti Simone", sezione:"A", commissione: 4 ),
            PersonaCreator(nome:"Pietrantoni Luisa", sezione:"H", commissione: 4 ),
            PersonaCreator(nome:"Roversi Luca", sezione:"H", commissione: 4 ),
            PersonaCreator(nome:"Ferroni Pamela", sezione:"N", commissione: 9 ),
            PersonaCreator(nome:"Manzione Miranda", sezione:"A", commissione: 9 ),
            PersonaCreator(nome:"Barbi Asia ", sezione:"H", commissione: 9 ),
            PersonaCreator(nome:"Fiorini Jacopo", sezione:"C", commissione: 9 ),
            PersonaCreator(nome:"Duffini Vittoria", sezione:"L", commissione: 10 ),
            PersonaCreator(nome:"Iannuziello Chiara", sezione:"A", commissione: 10 ),
            PersonaCreator(nome:"Rubbi Giorgia", sezione:"A", commissione: 10 ),
            PersonaCreator(nome:"Sicchiero Valentina", sezione:"D", commissione: 10 ),
            PersonaCreator(nome:"Canella Giulia", sezione:"H", commissione: 10 )
            /*PersonaCreator(nome:"Zappaterra Nicolò", sezione:"N", commissione: 1 ),
            PersonaCreator(nome:"Benati Nicolò", sezione:"B", commissione: 1 ),
            PersonaCreator(nome:"Gonnella Julia", sezione:"F", commissione: 1 ),
            PersonaCreator(nome:"Cavallari Chiara", sezione:"G", commissione: 1 ),
            PersonaCreator(nome:"Paparella Pietro", sezione:"M", commissione: 1 ),
            PersonaCreator(nome:"Trevisani Federico", sezione:"M", commissione: 1 ),
            PersonaCreator(nome:"Poretti Giulia", sezione:"P", commissione: 1 ),
            PersonaCreator(nome:"Caselli Andrea", sezione:"R", commissione: 1 ),
            PersonaCreator(nome:"Ghetti Eleonora", sezione:"T", commissione: 1 ),
            PersonaCreator(nome:"Punzetti Francesca", sezione:"B", commissione: 2 ),
            PersonaCreator(nome:"Galletto Martina", sezione:"F", commissione: 2 ),
            PersonaCreator(nome:"Ferrari Camilla", sezione:"F", commissione: 2 ),
            PersonaCreator(nome:"Pedriali Alessandro", sezione:"B", commissione: 2 ),
            PersonaCreator(nome:"Travasoni Beatrice", sezione:"B", commissione: 2 ),
            PersonaCreator(nome:"Grenzi Marcello", sezione:"F", commissione: 2 ),
            PersonaCreator(nome:"Cavallino Oliviero", sezione:"G", commissione: 2 ),
            PersonaCreator(nome:"Antonellini Giulia", sezione:"N", commissione: 2 ),
            PersonaCreator(nome:"Zappi Miriam", sezione:"N", commissione: 2 ),
            PersonaCreator(nome:"Rapparini Giacomo", sezione:"P", commissione: 2 ),
            PersonaCreator(nome:"Grazzi Andrea", sezione:"T", commissione: 2 ),
            PersonaCreator(nome:"Simoni Francesca", sezione:"T", commissione: 3 ),
            PersonaCreator(nome:"Simoni Giulia", sezione:"T", commissione: 3 ),
            PersonaCreator(nome:"Bolognesi Michele", sezione:"B", commissione: 3 ),
            PersonaCreator(nome:"Leggieri Carlotta", sezione:"F", commissione: 3 ),
            PersonaCreator(nome:"Crepaldi Francesco ", sezione:"G", commissione: 3 ),
            PersonaCreator(nome:"Baroni Giulia", sezione:"N", commissione: 3 ),
            PersonaCreator(nome:"Zerbinati Vittorio", sezione:"N", commissione: 3 ),
            PersonaCreator(nome:"Modica Cristian", sezione:"Q", commissione: 3 ),
            PersonaCreator(nome:"Rambaldi Marta", sezione:"R", commissione: 3 ),
            PersonaCreator(nome:"Losi Anna Silvia", sezione:"T", commissione: 3 ),
            PersonaCreator(nome:"Bertelli Giovanni", sezione:"G", commissione: 4 ),
            PersonaCreator(nome:"Ghesini Viviana", sezione:"T", commissione: 4 ),
            PersonaCreator(nome:"Benini Alessia ", sezione:"F", commissione: 4 ),
            PersonaCreator(nome:"Mezzogori Chiara", sezione:"F", commissione: 4 ),
            PersonaCreator(nome:"Felisatti Pietro", sezione:"G", commissione: 4 ),
            PersonaCreator(nome:"Maietti Nicole", sezione:"T", commissione: 4 ),
            PersonaCreator(nome:"Manfrini Ilaria", sezione:"R", commissione: 5 ),
            PersonaCreator(nome:"Zanardi Virginia", sezione:"L", commissione: 5 ),
            PersonaCreator(nome:"Miculi Paola", sezione:"F", commissione: 5 ),
            PersonaCreator(nome:"Soflau Alina", sezione:"T", commissione: 5 ),
            PersonaCreator(nome:"Morandi Michele", sezione:"G", commissione: 5 ),
            PersonaCreator(nome:"Bussola Marielena", sezione:"N", commissione: 5 ),
            PersonaCreator(nome:"Castaldini Nicholas", sezione:"O", commissione: 5 ),
            PersonaCreator(nome:"Manfredini Francesco", sezione:"Q", commissione: 5 ),
            PersonaCreator(nome:"Finotti Francesco", sezione:"S", commissione: 5 ),
            PersonaCreator(nome:"Maresti Giorgia", sezione:"T", commissione: 5 ),
            PersonaCreator(nome:"Pavanini Filippo", sezione:"F", commissione: 6 ),
            PersonaCreator(nome:"Bressan Evelyn", sezione:"N", commissione: 6 ),
            PersonaCreator(nome:"Colombani Alessandro", sezione:"B", commissione: 6 ),
            PersonaCreator(nome:"Campi Aurora", sezione:"F", commissione: 6 ),
            PersonaCreator(nome:"Ulbani Kevin ", sezione:"F", commissione: 6 ),
            PersonaCreator(nome:"Piccoli Gianluca", sezione:"G", commissione: 6 ),
            PersonaCreator(nome:"Burini Martina", sezione:"M", commissione: 6 ),
            PersonaCreator(nome:"Bulgarelli Giulia", sezione:"Q", commissione: 6 ),
            PersonaCreator(nome:"Manfrini Emma", sezione:"F", commissione: 7 ),
            PersonaCreator(nome:"Tralli Marielena", sezione:"B", commissione: 7 ),
            PersonaCreator(nome:"Olrlandini Giorgio", sezione:"F", commissione: 7 ),
            PersonaCreator(nome:"Coppola Marika", sezione:"B", commissione: 7 ),
            PersonaCreator(nome:"Ceruti Pietro ", sezione:"N", commissione: 7 ),
            PersonaCreator(nome:"Pastore Mirko", sezione:"Q", commissione: 7 ),
            PersonaCreator(nome:"Pini Samuele", sezione:"F", commissione: 7 ),
            PersonaCreator(nome:"Prinzi Chiara", sezione:"T", commissione: 7 ),
            PersonaCreator(nome:"Ricci Elena", sezione:"M", commissione: 8 ),
            PersonaCreator(nome:"Lambertini Beatrice", sezione:"M", commissione: 8 ),
            PersonaCreator(nome:"Bortolotti Marco ", sezione:"G", commissione: 8 ),
            PersonaCreator(nome:"Masci Francesca ", sezione:"M", commissione: 8 ),
            PersonaCreator(nome:"Cusinatti Michele", sezione:"N", commissione: 8 ),
            PersonaCreator(nome:"Vitali Mattia", sezione:"O", commissione: 8 ),
            PersonaCreator(nome:"Navilli Alberto", sezione:"T", commissione: 8 ),
            PersonaCreator(nome:"Ramponi Viola", sezione:"T", commissione: 8 ),
            PersonaCreator(nome:"Natali Elena", sezione:"S", commissione: 9 ),
            PersonaCreator(nome:"De La Paz Miriam", sezione:"F", commissione: 9 ),
            PersonaCreator(nome:"Biondi Nicola", sezione:"G", commissione: 9 ),
            PersonaCreator(nome:"Frighi Camilla ", sezione:"N", commissione: 9 ),
            PersonaCreator(nome:"Palmieri Claudio", sezione:"P", commissione: 9 ),
            PersonaCreator(nome:"Palmese Giuseppe", sezione:"M", commissione: 9 ),
            PersonaCreator(nome:"Berro Emanuele", sezione:"T", commissione: 9 ),
            PersonaCreator(nome:"Rondinelli Vincenzo", sezione:"T", commissione: 9 ),
            PersonaCreator(nome:"Corazza Roberta", sezione:"F", commissione: 10 ),
            PersonaCreator(nome:"Verrigni Gioia", sezione:"Q", commissione: 10 ),
            PersonaCreator(nome:"Dalpasso Francesco", sezione:"B", commissione: 10 ),
            PersonaCreator(nome:"Ghirardello Ilaria", sezione:"F", commissione: 10 ),
            PersonaCreator(nome:"Tassinari Elisa", sezione:"G", commissione: 10 ),
            PersonaCreator(nome:"Tinghino Federica ", sezione:"F", commissione: 10 ),
            PersonaCreator(nome:"Simone Arturo ", sezione:"N", commissione: 10 ),
            PersonaCreator(nome:"Pigozzo Matteo", sezione:"P", commissione: 10 ),*/
        ]
        
        
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        
        // Save your object
        realm.beginWrite()
        
        for persona in personeCreator {
            
            let personaRealm = PersonaRealm()
            
            personaRealm.nome = persona.nome
            personaRealm.sezione = persona.sezione
            personaRealm.commissione = persona.commissione
            personaRealm.interventiFatti = persona.interventiFatti
            personaRealm.punti = persona.punti
            
            realm.add(personaRealm)
        }
        
        try! realm.commitWrite()

    }
}


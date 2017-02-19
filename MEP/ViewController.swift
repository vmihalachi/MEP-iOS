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
    
    // le persone
    var persone : Results<PersonaRealm>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // aggiorniamo la tabella
        aggiornaTabella()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.persone.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // chiamiamo la persona seleziona
        chiamaPersona(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        // configuriamo la cella
        let persona = persone[indexPath.row]
        // nome della persona
        var testoNome = "\(persona.nome)"
        for _ in testoNome.characters.count ... 30 {
            testoNome += " "
        }
        let title = "\(testoNome)"
        let subtitle = "punti:  \(persona.punti)  \t\t\t\t commissione:  \(persona.commissione) \t\t\t\t sezione:  \(persona.sezione)"
        // set the text
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        return cell
    }
    
    
    @IBAction func nuovaRisoluzione(_ sender: AnyObject) {
        // realm
        let realm = try! Realm()
        // l input
        var inputTextField: UITextField?
        // il dialogo
        let alert = UIAlertController(title: "Vuoi aggiungere 300 punti a tutti?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // l azione per l ok
        let ok = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            // assicuriamo che siano sicuri di volerlo fare
            if inputTextField!.text == "1477" {
                // cancelliamo tutti i dati
                try! realm.write {
                    let lista = realm.objects(PersonaRealm.self)
                    for index in 0 ..< lista.count {
                        lista[index].punti += 300
                    }
                }
                // aggiorniamo la tabella
                self.aggiornaTabella()
            }
        })
        // non facciamo niente in caso di annulamento
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in}
        // aggiungiamo le azioni
        alert.addAction(ok)
        alert.addAction(cancel)
        // aggiugiamo l input
        alert.addTextField { (textField) -> Void in
            inputTextField = textField
            inputTextField?.placeholder = "Scrivi 1477"
        }
        // mostriamo il dialogo
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        // realm
        let realm = try! Realm()
        // l input
        var inputTextField: UITextField?
        // il dialogo
        let alert = UIAlertController(title: "Reset?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // l azione per l ok
        let ok = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            // assicuriamo che siano sicuri di volerlo fare
            if inputTextField!.text == "1477" {
                // cancelliamo tutti i dati
                try! realm.write {
                    let lista = realm.objects(PersonaRealm.self)
                    for index in 0 ..< lista.count {
                        lista[index].punti = 300
                    }
                }
                // aggiorniamo la tabella
                self.aggiornaTabella()
            }
        })
        // non facciamo niente in caso di annulamento
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in}
        // aggiungiamo le azioni
        alert.addAction(ok)
        alert.addAction(cancel)
        // aggiugiamo l input
        alert.addTextField { (textField) -> Void in
            inputTextField = textField
            inputTextField?.placeholder = "Scrivi 1477"
        }
        // mostriamo il dialogo
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func aggiungiPersona(_ sender: Any) {
        // realm
        let realm = try! Realm()
        // l input
        var inputNome: UITextField?
        var inputSezione: UITextField?
        var inputCommissione: UITextField?
        // il dialogo
        let alert = UIAlertController(title: "Aggiungi una persona", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // l azione per l ok
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // assicuriamo che siano sicuri di volerlo fare
            if inputNome!.text != "" && inputSezione!.text != "" && inputCommissione!.text != ""{
                // aggiungiamo la persona
                try! realm.write {
                    let personaRealm = PersonaRealm()
                    
                    personaRealm.nome = inputNome!.text!
                    personaRealm.sezione = inputSezione!.text!
                    personaRealm.commissione = Int(inputCommissione!.text!)!
                    personaRealm.punti = 300
                    
                    realm.add(personaRealm)
                    // aggiorniamo la tabella
                    self.aggiornaTabella()
                }
            }
        })
        // non facciamo niente in caso di annulamento
        let cancel = UIAlertAction(title: "Annulla", style: .cancel) { (action) -> Void in}
        // aggiungiamo le azioni
        alert.addAction(ok)
        alert.addAction(cancel)
        // aggiugiamo l input
        alert.addTextField { (textField) -> Void in
            inputNome = textField
            inputNome?.placeholder = "Nome e cognome"
        }
        alert.addTextField { (textField) -> Void in
            inputSezione = textField
            inputSezione?.placeholder = "Sezione"
        }
        alert.addTextField { (textField) -> Void in
            inputCommissione = textField
            inputCommissione?.placeholder = "Commissione"
        }
        // mostriamo il dialogo
        self.present(alert, animated: true, completion: nil)
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        // azione per eliminare una persona
        let elimina = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Elimina", handler: { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.eliminaPersona(indexPath.row)
            return
        })
        // sfondo di colore rosso
        elimina.backgroundColor = UIColor.red
        return [elimina]
    }
    
    func chiamaPersona (_ index : Int) {
        // realm
        let realm = try! Realm()
        // troviamo la persona
        let persona = persone[index]
        // dialogo di conferma
        let alert = UIAlertController(title: "Vuoi chiamare \(persona.nome)?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // in caso affermaivo
        let ok = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            // la commissione e la sezione della persona chiamata
            let commissione = persona.commissione
            let sezione = persona.sezione
            // le persone della sezione e della commissione
            let personeCommissione = realm.objects(PersonaRealm.self).filter("commissione == \(commissione)")
            let personeSezione = realm.objects(PersonaRealm.self).filter("sezione == '\(sezione)'")
            // togliamo punti
            try! realm.write {
                // togliamo 50 punti alla persona chiamata
                persona.punti -= 50
                // 5 a ogni membro della commissione
                for index in 0 ..< personeCommissione.count {
                    personeCommissione[index].punti -= 5
                }
                // 3 a ogni membro della sezione
                for index in 0 ..< personeSezione.count {
                    personeSezione[index].punti = max(personeSezione[index].punti - 3, 0)
                }
            }
            // aggiorniamo la tabella
            self.aggiornaTabella()
        })
        // in caso negativo
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
        }
        // aggiugiamo le due azioni
        alert.addAction(ok)
        alert.addAction(cancel)
        // mostiramo il dialogo
        self.present(alert, animated: true, completion: nil)
    }
    
    // funzione che elimina una specifica persona
    func eliminaPersona (_ index : Int) {
        // realm
        let realm = try! Realm()
        // troviamo la persona
        let persona = persone[index]
        // dialogo di conferma
        let alert = UIAlertController(title: "Vuoi eliminare \(persona.nome)?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // in caso affermaivo
        let ok = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            // eliminiamo la persona
            try! realm.write {
                realm.delete(persona)
            }
            // aggiorniamo la tabella
            self.aggiornaTabella()
        })
        // in caso negativo
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
        }
        // aggiugiamo le due azioni
        alert.addAction(ok)
        alert.addAction(cancel)
        // mostiramo il dialogo
        self.present(alert, animated: true, completion: nil)
    }
    
    // funziona che aggiorna la tablle
    func aggiornaTabella() {
        // realm
        let realm = try! Realm()
        // le persone ordinate per punti
        self.persone = realm.objects(PersonaRealm.self).sorted(byKeyPath: "punti", ascending: false)
        // ricarichiamo la tabella
        self.tableView.reloadData()
    }
    
    /*func fillData() {
     
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
     PersonaCreator(nome:"Zappaterra Nicolò", sezione:"N", commissione: 1 ),
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
     PersonaCreator(nome:"Pigozzo Matteo", sezione:"P", commissione: 10 ),
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
     
     }*/
}


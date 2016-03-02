//
//  Persona.swift
//  MEP
//
//  Created by Vlad Mihalachi on 25/01/15.
//  Copyright (c) 2015 Maskyn. All rights reserved.
//

import Foundation

class PersonaCreator {
    var nome : String = ""
    var sezione : String = ""
    var commissione : Int = 0
    var interventiFatti : Int = 0
    var punti : Int = 0
    
    init ( nome : String, sezione : String, commissione : Int) {
        self.nome = nome
        self.sezione = sezione
        self.commissione = commissione
        self.interventiFatti = 0
        self.punti = 300
    }
}
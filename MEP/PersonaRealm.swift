//
//  PersonaRealm.swift
//  MEP
//
//  Created by Vlad Mihalachi on 23/02/15.
//  Copyright (c) 2015 Maskyn. All rights reserved.
//

import RealmSwift
import Foundation

class PersonaRealm : Object {
    dynamic var nome : String = ""
    dynamic var sezione : String = ""
    dynamic var commissione : Int = 0
    dynamic var punti : Int = 0
}

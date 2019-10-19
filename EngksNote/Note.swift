//
//  Note.swift
//  EngksNote
//
//  Created by Mohamed on 10/19/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import Foundation
import RealmSwift


class Note: Object{
    
    @objc dynamic var noteText: String?
    
    @objc dynamic var email: String?
    
    
}

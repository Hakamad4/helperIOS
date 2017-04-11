//
//  Util.swift
//  Helper
//
//  Created by Edson Hakamada on 09/04/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import Foundation

class Util{
    static func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890âáãàéèêîìíõôòóúùûñ".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
}

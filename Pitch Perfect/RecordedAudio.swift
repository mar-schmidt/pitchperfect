//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Marcus Ronélius on 2015-08-25.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    override init() {
        filePathUrl = NSURL()
        title = String()
    }
}
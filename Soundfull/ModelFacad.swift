//
//  ModelFacad.swift
//  Soundfull
//
//  Created by Omar Alshammari on 3/11/16.
//  Copyright © 2016 Omar Alshammari. All rights reserved.
//

import UIKit
import MagicalRecord

class ModelFacad: NSObject {
    
    class func saveAudioWithTitle(title: String, andCategory category: String, withData data: NSData) -> Bool {
        let destinationPath = SoundfullFileManager.saveData(data, withfileName: "\(title)\(category).m4a")
        
        let audioFile = AudioFile.MR_createEntity()
        audioFile?.title = title
        audioFile?.category = category
        audioFile?.discURL = destinationPath
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return true
    }
    
    class func deleteAudioFile(audioFile: AudioFile) {
        SoundfullFileManager.deleteatPath(audioFile.discURL!)
        audioFile.MR_deleteEntity()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    class func allAudioFile() -> [AudioFile] {
        let audioFiles = AudioFile.MR_findAll() as? [AudioFile]
        return audioFiles!
    }
}

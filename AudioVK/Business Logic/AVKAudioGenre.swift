//
//  AVKAudioGenre.swift
//  AudioVK
//
//  Created by Intellectsoft on 08/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

import UIKit

class AVKAudioGenre: NSObject {
    class var genre: [Int:String] {
        return [
                0: "",
                1: "Rock",
                2: "Pop",
                3: "Rap & Hip-Hop",
                4: "Easy Listening",
                5: "Dance & House",
                6: "Instrumental",
                7: "Metal",
                21: "Alternative",
                8: "Dubstep",
                9: "Jazz & Blues",
                10: "Drum & Bass",
                11: "Trance",
                12: "Chanson",
                13: "Ethnic",
                14: "Acoustic & Vocal",
                15: "Reggae",
                16: "Classical",
                17: "Indie Pop",
                19: "Speech",
                22: "Electropop & Disco",
                18: "Other"]
    }

    class func genreStringFrom(number: NSNumber) -> String {
        return genre[number.integerValue]!
    }
}

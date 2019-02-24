//
//  WordsOfSong.swift
//  Player
//
//  Created by 王申宇 on 2019/2/11.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Alamofire

struct WordsOfSongHelper {
    static func getLastestNews(success: @escaping (WordsOfSong)->(), failure: @escaping (Error)->()) {
        MusicHelper.dataMusic(url: "https://music.163.com/api/lyric?id=\(MusicFigure.id) ", success: { dic in
            if let data1 = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let wordsOfSong = try? WordsOfSong(data1: data1) {
                success(wordsOfSong)
            }
        }, failure: { _ in
            
        })
    }
}

struct WordsOfSong: Codable {
    let sgc, sfy, qfy: Bool
    let lrc: Lrc
    let klyric: Klyric
    
    enum CodingKeys: String, CodingKey{
        case sgc, sfy, qfy
        case lrc
        case klyric
    }
}

struct Lrc: Codable {
    let version: Int
    let lyric: String
    
    enum CodingKeys: String, CodingKey {
        case version
        case lyric
    }
}

struct Klyric: Codable {
    let version: Int
    let lyric: String
    
    enum CodingKeys: String, CodingKey {
        case version
        case lyric
    }
}

extension WordsOfSong {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(WordsOfSong.self, from: data1)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data1 = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data1: data1)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data1: try Data(contentsOf: url))
    }
    
    func with(
        sgc: Bool? = nil,
        sfy: Bool? = nil,
        qfy: Bool? = nil,
        lrc: Lrc? = nil,
        klyric: Klyric? = nil
        ) -> WordsOfSong {
        return WordsOfSong(
            sgc: sgc ?? self.sgc,
            sfy: sfy ?? self.sfy,
            qfy: qfy ?? self.qfy,
            lrc: lrc ?? self.lrc,
            klyric: klyric ?? self.klyric
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Lrc {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(Lrc.self, from: data1)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data1 = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data1: data1)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data1: try Data(contentsOf: url))
    }
    
    func with(
        version: Int? = nil,
        lyric: String? = nil
        ) -> Lrc {
        return Lrc(
            version: version ?? self.version,
            lyric: lyric ?? self.lyric
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}




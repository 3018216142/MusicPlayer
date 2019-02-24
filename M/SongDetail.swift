//
//  WordsOfSong.swift
//  Player
//
//  Created by 王申宇 on 2019/2/11.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Alamofire

struct SongDetailHelper {
    static func getLastestNews(success: @escaping (SongDetail)->(), failure: @escaping (Error)->()) {
        MusicHelper.dataMusic(url: "https://music.163.com/api/song/detail/?ids=\(MusicFigure.id)&ids=%5B\(MusicFigure.id)%5D ", success: { dic in
            if let data1 = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let songDetail = try? SongDetail(data1: data1) {
                success(songDetail)
            }
        }, failure: { _ in
            
        })
    }
}

struct SongDetail: Codable {
    let songs: [Song]
    
    enum CodingKeys: String, CodingKey{
        case songs
    }
}

struct Song: Codable {
    let name, disc: String
    let id, status, fee, copyrightId, no: Int
    let alias: [String]
    let artists: [Artist]
    let album: Album
    
    enum CodingKeys: String, CodingKey {
        case name, disc
        case id, status, fee, copyrightId, no
        case alias
        case artists
        case album
    }
}

struct Artist: Codable {
    let name, briefDesc, trans: String
    let id, picId, imglvlId, albumSize, musicSize: Int
    let picUrl, imglvlUrl: String?
    let alias: [String]
    
    enum CodingKeys: String, CodingKey {
        case name, briefDesc, trans
        case id, picId, imglvlId, albumSize, musicSize
        case picUrl, imglvlUrl
        case alias
    }
}

struct Album: Codable {
    let name, type: String
    let id, size, picId, companyId: Int
    let blurPicUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name, type
        case id, size, picId, companyId
        case blurPicUrl
    }
}

extension SongDetail {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(SongDetail.self, from: data1)
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
        songs: [Song]? = nil
        ) -> SongDetail {
        return SongDetail(
            songs: songs ?? self.songs
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Song {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(Song.self, from: data1)
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
        name: String? = nil,
        disc: String? = nil,
        id: Int? = nil,
        status: Int? = nil,
        fee: Int? = nil,
        copyrightId: Int? = nil,
        no: Int? = nil,
        alias: [String]? = nil,
        artists: [Artist]? = nil,
        album: Album? = nil
        ) -> Song {
        return Song(
            name: name ?? self.name,
            disc: disc ?? self.disc,
            id: id ?? self.id,
            status: status ?? self.status,
            fee: fee ?? self.fee,
            copyrightId: copyrightId ?? self.copyrightId,
            no: no ?? self.no,
            alias: alias ?? self.alias,
            artists: artists ?? self.artists,
            album: album ?? self.album
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Artist {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(Artist.self, from: data1)
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
        name: String? = nil,
        briefDesc: String? = nil,
        trans: String? = nil,
        id: Int? = nil,
        picId: Int? = nil,
        imglvlId: Int? = nil,
        albumSize: Int? = nil,
        musicSize: Int? = nil,
        picUrl: String?? = nil,
        imglvlUrl: String?? = nil,
        alias: [String]? = nil
        ) -> Artist {
        return Artist(
            name: name ?? self.name,
            briefDesc: briefDesc ?? self.briefDesc,
            trans: trans ?? self.trans,
            id: id ?? self.id,
            picId: picId ?? self.picId,
            imglvlId: imglvlId ?? self.imglvlId,
            albumSize: albumSize ?? self.albumSize,
            musicSize: musicSize ?? self.musicSize,
            picUrl: picUrl ?? self.picUrl,
            imglvlUrl: imglvlUrl ?? self.imglvlUrl,
            alias: alias ?? self.alias
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Album {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(Album.self, from: data1)
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
        name: String? = nil,
        type: String? = nil,
        id: Int? = nil,
        size: Int? = nil,
        picId: Int? = nil,
        companyId: Int? = nil,
        blurPicUrl: String?? = nil
        ) -> Album {
        return Album(
            name: name ?? self.name,
            type: type ?? self.type,
            id: id ?? self.id,
            size: size ?? self.size,
            picId: picId ?? self.picId,
            companyId: companyId ?? self.companyId,
            blurPicUrl: blurPicUrl ?? self.blurPicUrl
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



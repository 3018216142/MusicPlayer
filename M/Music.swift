//
//  MusicCell.swift
//  Player
//
//  Created by 王申宇 on 2019/2/11.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Alamofire

struct MusicHelper {
    static func dataMusic(url: String, success: (([String: Any])->())? = nil, failure: ((Error)->())? = nil) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        success?(dict)
                    }
                }
            case .failure(let error):
                failure?(error)
                if let data = response.result.value  {
                    if let dict = data as? [String: Any],
                        let errmsg = dict["music"] as? String {
                        print(errmsg)
                    }
                } else {
                    print(error)
                }
            }
        }
    }
}

struct LastestMusicHelper {
    static func getLastestNews(success: @escaping (LastestMusic)->(), failure: @escaping (Error)->()) {
        MusicHelper.dataMusic(url: "https://music.163.com/api/song/url?id=\(MusicFigure.id) ", success: { dic in
            if let data1 = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let lastestNews = try? LastestMusic(data1: data1) {
                success(lastestNews)
            }
        }, failure: { _ in
            
        })
    }
}

struct MusicFigure {
    static var id = 0
}

struct LastestMusic: Codable {
    let data: [data]
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case code
    }
}

struct data: Codable {
    let id, br, size, code, expi, gain, fee, uf, payed, flag: Int
    let url: String?
    let md5, type: String
    let canExtend: Bool
    enum CodingKeys: String, CodingKey {
        case id, br, size, code, expi, gain, fee, uf, payed, flag
        case url
        case md5, type
        case canExtend
    }
}

extension LastestMusic {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(LastestMusic.self, from: data1)
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
        date: [data]? = nil,
        code: String? = nil
        ) -> LastestMusic {
        return LastestMusic(
            data: data ?? self.data,
            code: code ?? self.code
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension data {
    init(data1: Data) throws {
        self = try newJSONDecoder().decode(data.self, from: data1)
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
        id: Int? = nil,
        br: Int? = nil,
        size: Int? = nil,
        code: Int? = nil,
        expi: Int? = nil,
        gain: Int? = nil,
        fee: Int? = nil,
        uf: Int? = nil,
        payed: Int? = nil,
        flag: Int? = nil,
        url: String?? = nil,
        md5: String? = nil,
        type: String? = nil,
        canExtend: Bool? = nil
        ) -> data {
        return data(
            id: id ?? self.id,
            br: br ?? self.br,
            size: size ?? self.size,
            code: code ?? self.code,
            expi: expi ?? self.expi,
            gain: gain ?? self.gain,
            fee: fee ?? self.fee,
            uf: uf ?? self.uf,
            payed: payed ?? self.payed,
            flag: flag ?? self.flag,
            url: url ?? self.url,
            md5: md5 ?? self.md5,
            type: type ?? self.type,
            canExtend: canExtend ?? self.canExtend
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

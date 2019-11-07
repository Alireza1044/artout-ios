//
//  Formatter.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
protocol FormattingProtocol {
    associatedtype DecodeType:Codable
    associatedtype EncodeType:Codable
    func Decode(data: Data) -> DecodeType?
    func Encode(objDTO: EncodeType) -> Data?
}
class DTOFormatter<TypeDTO:Codable, TypeResponseDTO:Codable> {
    
    let Decoder = JSONDecoder()
    let Encoder = JSONEncoder()
    
    func Decode(data: Data) -> TypeResponseDTO? {
        if let object = try? Decoder.decode(TypeResponseDTO.self, from: data){
            return object
        }
        return nil
    }
    
    func Encode(objDTO: TypeDTO) -> Data? {
        if let data = try? Encoder.encode(objDTO) {
            return data
        }
        return nil
    }
        
        
        

}

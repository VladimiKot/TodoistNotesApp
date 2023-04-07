//
//  ApiClientProtocol.swift
//  TodoListNotesApp
//
//  Created by Владимир on 23.03.2023.
//

import Foundation

protocol ApiClientProtocol {
    
    func getRequest<T: Decodable>(url: URL?,
                                  parameters: [String: Any],
                                  completion: @escaping (Result<T?, Error>) -> Void)
    
    func deleteRequest<T: Decodable>(url: URL?,
                                     parameters: [String: Any],
                                     completion: @escaping (Result<T?, Error>) -> Void)
    
    func postRequest<T: Decodable, E: Encodable>(url: URL?,
                                                 parameters: [String: Any],
                                                 data: E,
                                                 completion: @escaping (Result<T?, Error>) -> Void)
}

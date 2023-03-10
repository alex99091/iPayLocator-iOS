//
//  SearchAPI.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/10.
//

import Foundation

enum SearchAPI {
    static let baseSearchURL = "https://openapi.naver.com/v1/search/local.json"
    static let baseReverseGeocodeURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"
    static let baseGeocodeURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
    
    enum ApiError: Error {
        case badStatus(code: Int)
        case decodingError
        case jsonEncoding
        case noContent
        case notAllowedURL
        case unknown(_ error: Error?)
        
        var info: String {
            switch self {
            case let .badStatus(code): return "에러 상태코드: \(code)입니다."
            case .decodingError: return "decoding 에러입니다."
            case .jsonEncoding: return "유효한 json형식이 아닙니다."
            case .noContent: return "데이터가 없습니다."
            case .notAllowedURL: return "잘못된 URL경로입니다."
            case .unknown(let error): return "알 수 없는 \(String(describing: error)): 에러입니다."
            }
        }
    }
}

extension SearchAPI {
    
    static func searchWithKeyword(keyword: String, completion: @escaping (Result<SearchData, ApiError>) -> Void) {
        guard let clientId: String = Bundle.main.SearchClientId else { return }
        guard let clientSecret: String = Bundle.main.SearchClientSecret else { return }
        let customAllowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: customAllowedSet) else { return }
        
        let queryString = encodedKeyword + "&display=3&start=1&sort=random"
        let urlString = baseSearchURL + "?query=" + queryString
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(error)))
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct 로 변경 즉 디코딩 즉 데이터 파싱
                    let searchData = try JSONDecoder().decode(SearchData.self, from: jsonData)
                    let items = searchData.items
                    
                    // 상태 코드는 200인데 파싱한 데이터에 따라서 에러처리
                    guard let items = items,
                          !items.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(searchData))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    static func fetchReverseGeocode(lat: Double, lng: Double, completion: @escaping (Result<GeocodeData, ApiError>) -> Void) {
        
        guard let NMFClientId: String = Bundle.main.NMFClientId else { return }
        guard let NMFClientSecret: String = Bundle.main.NMFClientSecret else { return }
        
        let coords = "coords=\(lng),\(lat)"
        let extraUrlString = "&sourcecrs=epsg:4326&output=json"
        
        let urlString = baseReverseGeocodeURL + coords + extraUrlString
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(NMFClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        urlRequest.addValue(NMFClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(error)))
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct 로 변경 즉 디코딩 즉 데이터 파싱
                    let geocodeData = try JSONDecoder().decode(GeocodeData.self, from: jsonData)
                    let results = geocodeData.results
                    
                    // 상태 코드는 200인데 파싱한 데이터에 따라서 에러처리
                    guard let results = results,
                          !results.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(geocodeData))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
}

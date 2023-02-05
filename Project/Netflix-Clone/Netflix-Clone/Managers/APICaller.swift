//
//  APICaller.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import Foundation

struct Constant {
    static let API_KEY = "02a2fe2f524300f6866a236ac4a43f0f"
    static let baseURL = "https://api.themoviedb.org"
    static let Youtobe_APIKEY = "AIzaSyBg0Jr6_47oAHL364yMkJE7hOdLEU_fTlE"
    static let Youtobe_BaseURL = "https://youtube.googleapis.com/youtube/v3/search"
    static let Youtobe_BaseURLPreView = "https://www.youtube.com/watch?v="
}

enum APIError: Error {
    case FailedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/movie/day?api_key=\(Constant.API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/tv/day?api_key=\(Constant.API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func getUpcomingFilms(completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/upcoming?api_key=\(Constant.API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func getPopularFilm(completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/popular?api_key=\(Constant.API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func getTopratedFilm(completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/top_rated?api_key=\(Constant.API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func getDiscoveryMovies(completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Constant.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    
    /// method này có đoạn query ma giáo
    func search(query: String , completion: @escaping (Result<[DataAPI], APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Constant.API_KEY)&query=\(query)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(ResultAPICaller.self, from: data)
                completion(Result.success(results.results))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func getMovieFromApiYoutobe(with query: String, completion: @escaping (Result<VideoElement, APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: "\(Constant.Youtobe_BaseURL)?q=\(query)&key=\(Constant.Youtobe_APIKEY)") else {return}
    
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
                
            do {
                let results = try JSONDecoder().decode(YoutobeSearchResults.self, from: data)
                completion(Result.success(results.items[0]))
            } catch {
                completion(Result.failure(.FailedToGetData))
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }.resume()
    }

}

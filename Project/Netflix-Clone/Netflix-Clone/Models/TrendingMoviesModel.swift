//
//  TrendingMoviesModel.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import Foundation

struct TrendingMoviesModel: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let overview: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
    let poster_path: String?
    
}

//{
//adult = 0;
//"backdrop_path" = "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg";
//"genre_ids" =             (
//28,
//12,
//878
//);
//id = 505642;
//"media_type" = movie;
//"original_language" = en;
//"original_title" = "Black Panther: Wakanda Forever";
//overview = "Queen Ramonda, Shuri, M\U2019Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T\U2019Challa\U2019s death. As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda.";
//popularity = "3907.516";
//"poster_path" = "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg";
//"release_date" = "2022-11-09";
//title = "Black Panther: Wakanda Forever";
//video = 0;
//"vote_average" = "7.546";
//"vote_count" = 2206;
//}

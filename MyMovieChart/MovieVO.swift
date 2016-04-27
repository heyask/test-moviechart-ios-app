//
//  MovieVO.swift
//  MyMovieChart
//
//  Created by 김승현 on 2016. 4. 27..
//  Copyright © 2016년 aivesoft. All rights reserved.
//

import Foundation
import UIKit

class MovieVO {
    init() {
        
    }
    
    //영화 섬네일 주소
    var thumbnail : String?
    
    //영화제목
    var title : String?
    
    //영화설명
    var description : String?
    
    //상세정보
    var detail : String?
    
    //개봉일
    var opendate : String?
    
    //평점
    var rating : Float?
    
    //영화 썸네일 이미지를 담을 UIImage 객체를 추가
    var thumbnailImage : UIImage?
}
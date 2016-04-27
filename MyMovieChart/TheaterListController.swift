//
//  TheaterListController.swift
//  MyMovieChart
//
//  Created by 김승현 on 2016. 4. 27..
//  Copyright © 2016년 aivesoft. All rights reserved.
//

import UIKit

class TheaterListController : UITableViewController {
    
    @IBOutlet var theaterTable: UITableView!
    
    //API를 통해 불러운 데이터를 저장할 배열변수
    var list = [NSDictionary]()
    
    //읽어올 데이터의 시작위치
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callTheaterAPI()
    }
    
    func callTheaterAPI() {
        let apiURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=351628b6c0aa40aed2040f78c394a08a&itemPerPage=10&curPage=1"
        
        let urlObj = NSURL(string: "\(apiURL)")
        
        do {
            let stringdata = try NSString(contentsOfURL: urlObj!, encoding: NSUTF8StringEncoding)
            
            let encdata = stringdata.dataUsingEncoding(NSUTF8StringEncoding)
            //NSLog(encdata as String)
            do {
                let apiArray = try NSJSONSerialization.JSONObjectWithData(encdata!, options: []) as! NSDictionary
                
                let movieListResult = apiArray["movieListResult"] as! NSDictionary
                let movie = movieListResult["movieList"] as! NSArray
                
                for obj in movie {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터 분석이 실패하였습니다", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "확인", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: false, completion: nil)
            }
            
        } catch {
            let alert = UIAlertController(title: "실패", message: "데이터를 불러오는데 실패하였습니다", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "확인", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: false, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue_map") {
            let path = self.theaterTable.indexPathForCell(sender as! UITableViewCell)
            
            let data = self.list[path!.row]
            
            (segue.destinationViewController as? TheaterViewController)?.param = data
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("tCell") as! TheaterCell
        
        cell.name?.text = obj["movieNm"] as? String
        cell.tel?.text = obj["movieNm"] as? String
        cell.addr?.text = obj["movieNm"] as? String
        
        return cell
    }
}
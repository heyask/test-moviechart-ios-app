import UIKit

class ListViewController : UITableViewController {
    @IBOutlet var movieTable: UITableView!
    @IBOutlet var moreBtn: UIButton!
    
    //테이블 뷰를 구성할 리스트 데이터를 담을 배열변수(=[MovieVO]())
    var list = Array<MovieVO>()
    
    //현재까지 읽어온 데이터의 페이지 정보
    var page = 1
    
    @IBAction func more(sender: AnyObject) {
        self.page += 1
        
        self.callMovieAPI()
        
        self.movieTable.reloadData()
        
        if self.page == 5 {
            self.moreBtn.hidden = true
        }
    }
    
    override func viewDidLoad() {
        self.callMovieAPI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //실행된 세그웨이의 식별자가 viewDetail 이라면
        if(segue.identifier == "segue_detail") {
            //세그웨이를 실행한 sender 인자값을 이용하여 사용자가 클릭한 행 정보를 얻는다
            let path = self.movieTable.indexPathForCell(sender as! MovieCell)
            
            //행정보를 이용하여 사용자가 선택한 영화데이터를 찾은 다음,
            //목적지 뷰 컨트롤러의 mvo변수에 연결해준다.
            (segue.destinationViewController as? DetailViewController)?.mvo = self.list[path!.row]
        }
    }
    
    func callMovieAPI()
    {
        let apiURI = NSURL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=351628b6c0aa40aed2040f78c394a08a&itemPerPage=10&curPage=\(self.page)")
        
        let apidata : NSData? = NSData(contentsOfURL: apiURI!)
        
        //NSLog("API Result=%@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
        
        do {
            let apiDictionary = try NSJSONSerialization.JSONObjectWithData(apidata!, options: []) as! NSDictionary
            
            let movieListResult = apiDictionary["movieListResult"] as! NSDictionary
            let movie = movieListResult["movieList"] as! NSArray
            
            var mvo : MovieVO
            
            for row in movie {
                mvo = MovieVO()
                
                mvo.title = row["movieNm"] as? String
                mvo.description = row["movieCd"] as? String
                //let newString = mvo.description?.substringToIndex(mvo.description!.startIndex.advancedBy(5))
                mvo.thumbnail = "http://dummyimage.com/300x40/000/fff&text=" + mvo.description!
                mvo.detail = "http://naver.com/"
                mvo.rating = (8.112).floatValue
                //var url = NSURL(string: mvo.thumbnail!)
                //var imageData = NSData(contentsOfURL: url!)
                //cell.thumbnail.image = UIImage(named: row.thumbnail!)
                //mvo.thumbnailImage = UIImage(data: imageData!)
                
                self.list.append(mvo)
            }
        } catch {
            
        }
    }
    
    
    func getThumbnailImage(index : Int) -> UIImage {
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            NSLog("이미다운")
            return savedImage
        } else {
            NSLog("다운\(mvo.thumbnail)\(mvo.title)")
            let imageUrl = mvo.thumbnail
            
            
            ImageLoader.sharedLoader.imageForUrl(imageUrl!, completionHandler:{(image: UIImage?, url: String) in
                NSLog("okokok")
                
            })
            //sleep(1);
            //mvo.thumbnailImage = UIImage(data:imageData!) //UIImage객체를 생성하여 MovieVO 객체에 우선 저장함
            //return mvo.thumbnailImage! //저장된 이미지를 반환
            return UIImage(named: "1.jpg")!
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //주어진 행에 맞는 데이터 소스를 가져옴
        let row = self.list[indexPath.row]
         
        //테이블 셀을 큐로부터 가져옴
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! MovieCell
         
        //추가: 보조레이블에 데이터 연결
        //cell.detailTextLabel?.text = row.description
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        //cell.thumbnail.image = row.thumbnailImage
        //수정) 비동기방식으로 섬네일 이미지를 읽어옴
        //NSLog("----호출전---제목:\(row.title!), 호출된 행번호:\(indexPath.row)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            dispatch_async(dispatch_get_main_queue(), {
                // update some UI
                cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
                NSLog("----비동기---제목:\(row.title!), 호출된 행번호:\(indexPath.row)")
                });
        });
        
        
        
        /*dispatch_async(dispatch_get_main_queue(), {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
            NSLog("----비동기---제목:\(row.title!), 호출된 행번호:\(indexPath.row)")
        })*/
        //NSLog("----호출후---제목:\(row.title!), 호출된 행번호:\(indexPath.row)")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Touch Table Row at %d", indexPath.row)
    }
}
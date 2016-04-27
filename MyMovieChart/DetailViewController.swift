import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet var navibar: UINavigationItem!
    @IBOutlet var wv: UIWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //목록에서 넘겨주는 영화데이터를 받을 변수
    var mvo : MovieVO? = nil
    
    override func viewDidLoad() {
        NSLog("linkurl = \(self.mvo?.detail), title=\(self.mvo?.title)")
        
        //내비게이션바의 타이틀에 영화명을 출력해준다.
        self.navibar.title = self.mvo?.title
        
        //detail을 이용하여 NSURLRequest객체를 만들고 loadRequest메소드를 호출한다. 로드가 끝나면 웹뷰에 웹페이지가 출력된다
        let req = NSURLRequest(URL: NSURL(string: (self.mvo?.detail)!)!)
        self.wv.loadRequest(req)
    }
    
    //웹뷰가 페이지를 로드하기 시작할때
    func webViewDidStartLoad(webView: UIWebView) {
        self.spinner.startAnimating()
    }
    
    //웹뷰가 웹페이지 로드를 완료했을때
    func webViewDidFinishLoad(webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadwithError error: NSError?) {
        self.spinner.stopAnimating()
        
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }
}
//
//  ViewController.swift
//  DFApiDemo
//
//  Created by ihoudf on 2021/4/30.
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let lb = UILabel()
        lb.frame = CGRect(x: 0, y: 200, width: 200, height: 400)
        lb.backgroundColor = .white
        self.view.addSubview(lb)

//        ApiRequest(target: .rankList) { (isSucc, res: RankinglistModel?, error) in
//            if isSucc {
//                guard let model = res else { return }
//                let ddd = model.rankinglist?.last
//                print("=======================" + (ddd?.subTitle ?? ""))
//                lb.text = ddd?.title ?? ""
//            }else{
//                print(error?.localizedDescription ?? "")
//            }
//        }

//
//        ApiRequest(target: .searchHot) { (isSucc, res: HotListModel?, _) in
//            if isSucc {
//                guard let model = res else { return }
//                print(model.hotItems?.first?.comic_id ?? "")
//                print(model.defaultSearch ?? "")
//            }else{
//                print("失败")
//            }
//        }
        
        // 这个接口是随便写的，所以会失败
        ApiRequest(target: .userInfo(userId: "2333")) { (isSucc, res: ApiEmptyModel?, _) in
            if isSucc {
                print("成功")
            }else{
                print("失败")
            }
        }


        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        btn.setTitle("切换环境", for: .normal)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(changeEnv), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func changeEnv() {
        ApiEnv.showEnvAlert()
    }
    

}

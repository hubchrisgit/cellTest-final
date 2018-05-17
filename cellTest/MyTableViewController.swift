//
//  MyTableViewController.swift
//  cellTest
//
//  Created by dong on 2018/4/2.
//  Copyright © 2018年 dong. All rights reserved.
//

import UIKit
import SQLite3

class MyTableViewController: UITableViewController {

    @IBOutlet var btnFavoirte: UIBarButtonItem!
    
    let kCloseCellHeight: CGFloat = 210
    let kOpenCellHeight: CGFloat = 600
    var kRowsCount = 10000
    var cellHeights: [CGFloat] = []
    
    var myViewController:ViewController!
    //紀錄查詢到的資料表（離線資料集）
    var animalobj:[[String:Any]] = []
    //圖片陣列
    var picdata:[Data] = []
    //目前被點選的資料行
    var currentRow = 0
    //資料庫連線指標
    var db:OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        //==============以下與資料庫相關==============
        if let delegate = UIApplication.shared.delegate as? AppDelegate
        {
            //由應用程式代理的實體，取得資料連線指標
            db = delegate.db
            print("view1資料庫連線成功")
        }
        else
        {
            print("view1資料庫連線失敗")
        }
        //=========================================
        animalobj = myViewController.searchResult
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        btnFavoirte.accessibilityElementsHidden = false
        tableView.reloadData()
    }
    
    //button
    @IBAction func btnFavoirteAction(_ sender: UIBarButtonItem)
    {
        //從storyboard上初始化新增畫面
        let favoirteVC = storyboard?.instantiateViewController(withIdentifier: "FavoirteTableViewController") as! FavoirteTableViewController
        //傳遞本頁給新增畫面
        favoirteVC.myTableViewController = self
    }
    
    @IBAction func favoirte(_ sender: UIButton)
    {
        let searchfavorite = "select animal_id from favorite_animals where animal_id = \"\(animalobj[currentRow]["animal_id"] as! String)\""
        print(searchfavorite)
        var response:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, searchfavorite, -1, &response, nil) == SQLITE_OK
        {
            if sqlite3_step(response) == SQLITE_ROW
            {
            //製作警告視窗
            let alert = UIAlertController(title: "我的最愛", message: "我的最愛重複!", preferredStyle: .alert)
            //加上視窗按鈕
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            //顯示警告視窗
            present(alert, animated: true, completion: nil)
            }
            else
            {
                // 把收到的變數轉成 C 語言類型的字串，因為下方的 SQL 要用
                let Canimal_id = animalobj[currentRow]["animal_id"] as! String
                let id = Canimal_id.cString(using: .utf8)
                
                let Cshelter_name = animalobj[currentRow]["shelter_name"] as! String
                let name = Cshelter_name.cString(using: .utf8)
                
                let Cshelter_address = animalobj[currentRow]["shelter_address"] as! String
                let address = Cshelter_address.cString(using: .utf8)
                
                let Cshelter_tel = animalobj[currentRow]["shelter_tel"] as! String
                let tel = Cshelter_tel.cString(using: .utf8)
                
                let Canimal_remark = animalobj[currentRow]["animal_remark"] as! String
                let remark = Canimal_remark.cString(using: .utf8)
                
                let Canimal_sex = animalobj[currentRow]["animal_sex"] as! String
                let sex = Canimal_sex.cString(using: .utf8)
                
                let Canimal_colour = animalobj[currentRow]["animal_colour"] as! String
                let colour = Canimal_colour.cString(using: .utf8)
                
                let Canimal_bodytype = animalobj[currentRow]["animal_bodytype"] as! String
                let bodytype = Canimal_bodytype.cString(using: .utf8)
                
                let Canimal_age = animalobj[currentRow]["animal_age"] as! String
                let age = Canimal_age.cString(using: .utf8)
                
                let Canimal_sterilization = animalobj[currentRow]["animal_sterilization"] as! String
                let sterilization = Canimal_sterilization.cString(using: .utf8)
                
                let Canimal_bacterin = animalobj[currentRow]["animal_bacterin"] as! String
                let bacterin = Canimal_bacterin.cString(using: .utf8)
                
                let Calbum_file = animalobj[currentRow]["album_file"] as! String
                let image = Calbum_file.cString(using: .utf8)
                
                let Canimal_foundplace = animalobj[currentRow]["animal_foundplace"] as! String
                let foundplace = Canimal_foundplace.cString(using: .utf8)
                // SQL 語法，插入一筆新的資料
                let sql = "INSERT INTO favorite_animals (animal_id, shelter_name, shelter_address, shelter_tel, animal_remark, animal_sex, animal_colour, animal_bodytype, animal_age, animal_sterillization, animal_bacterin, image, animal_foundplace) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                //        let csql = String(format: "INSERT INTO favorite_animals (animal_id, shelter_name, shelter_address, shelter_tel, animal_remark, animal_sex, animal_colour, animal_bodytype, animal_age, animal_sterillization, animal_bacterin, image) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",Canimal_id,Cshelter_name,Cshelter_address,Cshelter_tel,Canimal_remark,Canimal_sex,Canimal_colour,Canimal_bodytype,Canimal_age,Canimal_sterilization,Canimal_bacterin,Calbum_file)
                //        print(csql)
                //let sql = csql.cString(using: .utf8)!
                var statment: OpaquePointer? = nil
                sqlite3_prepare(db, sql, -1, &statment, nil)
                // 跟 ? 綁定
                sqlite3_bind_text(statment, 1, id, -1, nil)
                sqlite3_bind_text(statment, 2, name, -1, nil)
                sqlite3_bind_text(statment, 3, address, -1, nil)
                sqlite3_bind_text(statment, 4, tel, -1, nil)
                sqlite3_bind_text(statment, 5, remark, -1, nil)
                sqlite3_bind_text(statment, 6, sex, -1, nil)
                sqlite3_bind_text(statment, 7, colour, -1, nil)
                sqlite3_bind_text(statment, 8, bodytype, -1, nil)
                sqlite3_bind_text(statment, 9, age, -1, nil)
                sqlite3_bind_text(statment, 10, sterilization, -1, nil)
                sqlite3_bind_text(statment, 11, bacterin, -1, nil)
                sqlite3_bind_text(statment, 12, image, -1, nil)
                sqlite3_bind_text(statment, 13, foundplace, -1, nil)
                if sqlite3_step(statment) == SQLITE_DONE {
                    print("加入成功")
                    //製作警告視窗
                    let alert = UIAlertController(title: "我的最愛", message: "加到我的最愛！", preferredStyle: .alert)
                    //加上視窗按鈕
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                    //顯示警告視窗
                    present(alert, animated: true, completion: nil)
                    sender.setImage(UIImage(named: "icons8-heart-outline-48"), for: .normal)
                } else {
                    print("加入失敗")
                }
                // 釋放statment記憶體空間
                sqlite3_finalize(statment)
            }
        }
        // 釋放statment記憶體空間
        sqlite3_finalize(response)
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
    }
}

// MARK: - TableView

extension MyTableViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return animalobj.count
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as MyCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        
        //下載圖片並放到view上
        if let aPicUrl = animalobj[indexPath.row]["album_file"]
        {
            if aPicUrl as! String == ""
            {
                cell.containerViewPic.contentMode = .scaleToFill
                cell.foregroundViewPic.image = UIImage(named: "imgerror1")
                cell.containerViewPic.image = UIImage(named: "imgerror2")
            }
            else
            {
            cell.foregroundViewPic.image = UIImage(named: "img2")
            cell.containerViewPic.image = UIImage(named: "img1")
            let url = URL(string: aPicUrl as! String)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let dataTask = session.dataTask(with: url!, completionHandler:
                { (data, response, error) in
                    if error == nil
                    {
                        DispatchQueue.main.async
                        {
                            cell.containerViewPic.contentMode = .scaleAspectFit
                            cell.foregroundViewPic.image = UIImage(data: data!)
                            cell.containerViewPic.image = UIImage(data: data!)
                            if cell.foregroundViewPic.image == nil
                            {
                                cell.containerViewPic.contentMode = .scaleToFill
                                cell.foregroundViewPic.image = UIImage(named: "imgerror1")
                                cell.containerViewPic.image = UIImage(named: "imgerror2")
                            }
                        }
                    }
                    else
                    {
                        cell.containerViewPic.contentMode = .scaleToFill
                        cell.foregroundViewPic.image = UIImage(named: "imgerror1")
                        cell.containerViewPic.image = UIImage(named: "imgerror2")
                    }
                    
                })
                dataTask.resume()
            }
        
        }
        else
        {
            cell.containerViewPic.contentMode = .scaleToFill
            cell.foregroundViewPic.image = UIImage(named: "imgerror1")
            cell.containerViewPic.image = UIImage(named: "imgerror2")
        }
        //第一頁動物編號
        cell.Flbl_nimal_id.text = animalobj[indexPath.row]["animal_id"] as? String
        //第一頁性別
        if animalobj[indexPath.row]["animal_sex"] as? String == "F"
        {
            cell.Flbl_animal_sex.text = "女孩"
        }
        else if animalobj[indexPath.row]["animal_sex"] as? String == "M"
        {
            cell.Flbl_animal_sex.text = "男孩"
        }
        else
        {
            cell.Flbl_animal_sex.text = "未輸入"
        }
        //第一頁縣市
        if let nimal_area_pkid = animalobj[indexPath.row]["animal_area_pkid"] as? String
        {
            switch nimal_area_pkid{
            case "2":
                cell.Flbl_animal_area_pkid.text = "臺北市"
            case "3":
                cell.Flbl_animal_area_pkid.text = "新北市"
            case "4":
                cell.Flbl_animal_area_pkid.text = "基隆市"
            case "5":
                cell.Flbl_animal_area_pkid.text = "宜蘭縣"
            case "6":
                cell.Flbl_animal_area_pkid.text = "桃園市"
            case "7":
                cell.Flbl_animal_area_pkid.text = "新竹縣"
            case "8":
                cell.Flbl_animal_area_pkid.text = "新竹市"
            case "9":
                cell.Flbl_animal_area_pkid.text = "苗栗縣"
            case "10":
                cell.Flbl_animal_area_pkid.text = "臺中市"
            case "11":
                cell.Flbl_animal_area_pkid.text = "彰化縣"
            case "12":
                cell.Flbl_animal_area_pkid.text = "南投縣"
            case "13":
                cell.Flbl_animal_area_pkid.text = "雲林縣"
            case "14":
                cell.Flbl_animal_area_pkid.text = "嘉義縣"
            case "15":
                cell.Flbl_animal_area_pkid.text = "嘉義市"
            case "16":
                cell.Flbl_animal_area_pkid.text = "台南市"
            case "17":
                cell.Flbl_animal_area_pkid.text = "高雄市"
            case "18":
                cell.Flbl_animal_area_pkid.text = "屏東縣"
            case "19":
                cell.Flbl_animal_area_pkid.text = "花蓮縣"
            case "20":
                cell.Flbl_animal_area_pkid.text = "臺東縣"
            case "21":
                cell.Flbl_animal_area_pkid.text = "澎湖縣"
            case "22":
                cell.Flbl_animal_area_pkid.text = "金門縣"
            case "23":
                cell.Flbl_animal_area_pkid.text = "連江縣"
            default:
                cell.Flbl_animal_area_pkid.text = "未輸入"
            }
        }

        //open頁-id
        cell.open_animal_id.text = animalobj[indexPath.row]["animal_id"] as? String
        if cell.open_animal_id.text == ""
        {
            cell.open_animal_id.text = "未輸入"
        }
        //open頁-收容所名稱
        cell.open_shelter_name.text = animalobj[indexPath.row]["shelter_name"] as? String
        if cell.open_shelter_name.text == ""
        {
            cell.open_shelter_name.text = "未輸入"
        }
        //open頁-收容所地址
        cell.open_shelter_address.text = animalobj[indexPath.row]["shelter_address"] as? String
        if cell.open_shelter_address.text == ""
        {
            cell.open_shelter_address.text = "未輸入"
        }
        //open頁-收容所電話
        cell.open_shelter_tel.text = animalobj[indexPath.row]["shelter_tel"] as? String
        if cell.open_shelter_tel.text == ""
        {
            cell.open_shelter_tel.text = "未輸入"
        }
        //open頁-尋獲地點
        cell.open_animal_foundplace.text = animalobj[indexPath.row]["animal_foundplace"] as? String
        if cell.open_animal_foundplace.text == ""
        {
            cell.open_animal_foundplace.text = "未輸入"
        }
        //open頁-目前所在地
//        cell.open_animal_place.text = animalobj[indexPath.row]["animal_place"] as? String
//        if cell.open_animal_place.text == ""
//        {
//            cell.open_animal_place.text = "未輸入"
//        }
        //open頁-性別
        if animalobj[indexPath.row]["animal_sex"] as? String == "F"
        {
            cell.open_animal_sex.text = "女孩"
        }
        else if animalobj[indexPath.row]["animal_sex"] as? String == "M"
        {
            cell.open_animal_sex.text = "男孩"
        }
        else
        {
            cell.open_animal_sex.text = "未輸入"
        }
        //open頁-毛色
        cell.open_animal_colour.text = animalobj[indexPath.row]["animal_colour"] as? String
        if cell.open_animal_colour.text == ""
        {
            cell.open_animal_colour.text = "未輸入"
        }
        //open頁-體型
        cell.open_animal_bodytype.text = animalobj[indexPath.row]["animal_bodytype"] as? String
        if cell.open_animal_bodytype.text == "MINI"
        {
            cell.open_animal_bodytype.text = "迷你"
        }
        else if cell.open_animal_bodytype.text == "SMALL"
        {
            cell.open_animal_bodytype.text = "小型"
        }
        else if cell.open_animal_bodytype.text == "MEDIUM"
        {
            cell.open_animal_bodytype.text = "中型"
        }
        else if cell.open_animal_bodytype.text == "BIG"
        {
            cell.open_animal_bodytype.text = "大型"
        }
        else
        {
            cell.open_animal_bodytype.text = "未輸入"
        }
        
        //open頁-年紀
        cell.open_animal_age.text = animalobj[indexPath.row]["animal_age"] as? String
        if cell.open_animal_age.text == "CHILD"
        {
            cell.open_animal_age.text = "幼年"
        }
        else if cell.open_animal_age.text == "ADULT"
        {
            cell.open_animal_age.text = "成年"
        }
        else
        {
            cell.open_animal_age.text = "未輸入"
        }
        //open頁-結紮
        cell.open_animal_sterilization.text = animalobj[indexPath.row]["animal_sterilization"] as? String
        if cell.open_animal_sterilization.text == "T"
        {
            cell.open_animal_sterilization.text = "是"
        }
        else if cell.open_animal_sterilization.text == "F"
        {
            cell.open_animal_sterilization.text = "否"
        }
        else
        {
            cell.open_animal_sterilization.text = "未輸入"
        }
        //open頁-施打疫苗
        cell.open_animal_bacterin.text = animalobj[indexPath.row]["animal_bacterin"] as? String
        if cell.open_animal_bacterin.text == "T"
        {
            cell.open_animal_bacterin.text = "是"
        }
        else if cell.open_animal_bacterin.text == "F"
        {
            cell.open_animal_bacterin.text = "否"
        }
        else
        {
            cell.open_animal_bacterin.text = "未輸入"
        }
        //open頁-備註
        cell.open_animal_remark.text = animalobj[indexPath.row]["animal_remark"] as? String
        if cell.open_animal_remark.text! == ""
        {
            cell.open_animal_remark.text = "未輸入"
        }
        
        //愛心變換
        let searchfavorite = "select animal_id from favorite_animals where animal_id = \"\(animalobj[indexPath.row]["animal_id"] as! String)\""
        var response:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, searchfavorite, -1, &response, nil) == SQLITE_OK
        {
            if sqlite3_step(response) == SQLITE_ROW
            {
                cell.btnOpenFavorite.setImage(UIImage(named: "icons8-heart-outline-48"), for: .normal)
            }
            else
            {
                cell.btnOpenFavorite.setImage(UIImage(named: "heart1"), for: .normal)
            }
        }
        // 釋放statment記憶體空間
        sqlite3_finalize(response)
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    //當特定儲存格被點選時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MyCell

            //紀錄目前被點選的資料行
            currentRow = indexPath.row

        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    
    

    
}

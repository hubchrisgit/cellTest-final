

import UIKit
import SQLite3

class FavoirteTableViewController: UITableViewController, UINavigationControllerDelegate
{
    //紀錄上一頁的表格控制器實體
    var myTableViewController:MyTableViewController!
    var myViewController:ViewController!
    //資料庫連線指標
    var db:OpaquePointer?
    //紀錄最愛離線資料行
    var favoriteArr = [[String:Any]]()
    //目前被點選的資料行
    var currentRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if db != nil
        {
            var dicRow = [String:Any]()
            let sql = "Select * From favorite_animals"
            var response: OpaquePointer? = nil
            if sqlite3_prepare(db, sql, -1, &response, nil) == SQLITE_OK {
                while sqlite3_step(response) == SQLITE_ROW {
                    dicRow.removeAll()
                    
                    let id = String(cString: sqlite3_column_text(response, 1))
                    dicRow["animal_id"] = id
                    let name = String(cString: sqlite3_column_text(response, 2))
                    dicRow["shelter_name"] = name
                    let address = String(cString: sqlite3_column_text(response, 3))
                    dicRow["shelter_address"] = address
                    let tel = String(cString: sqlite3_column_text(response, 4))
                    dicRow["shelter_tel"] = tel
                    let remark = String(cString: sqlite3_column_text(response, 5))
                    dicRow["animal_remark"] = remark
                    let sex = String(cString: sqlite3_column_text(response, 6))
                    dicRow["animal_sex"] = sex
                    let colour = String(cString: sqlite3_column_text(response, 7))
                    dicRow["animal_colour"] = colour
                    let bodytype = String(cString: sqlite3_column_text(response, 8))
                    dicRow["animal_bodytype"] = bodytype
                    let age = String(cString: sqlite3_column_text(response, 9))
                    dicRow["animal_age"] = age
                    let sterillization = String(cString: sqlite3_column_text(response, 10))
                    dicRow["animal_sterilization"] = sterillization
                    let bacterin = String(cString: sqlite3_column_text(response, 11))
                    dicRow["animal_bacterin"] = bacterin
                    let image = String(cString: sqlite3_column_text(response, 12))
                    dicRow["album_file"] = image
                    let foundplace = String(cString: sqlite3_column_text(response, 13))
                    dicRow["animal_foundplace"] = foundplace
                    favoriteArr.append(dicRow)

                }
            }
            sqlite3_finalize(response)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        cell.fav_animal_id.text = favoriteArr[indexPath.row]["animal_id"] as? String
        if cell.fav_animal_id.text == ""
        {
            cell.fav_animal_id.text = "未輸入"
        }
        cell.favshelter_name.text = favoriteArr[indexPath.row]["shelter_name"] as? String
        if cell.favshelter_name.text == ""
        {
            cell.favshelter_name.text = "未輸入"
        }
        cell.favshelter_address.text = favoriteArr[indexPath.row]["shelter_address"] as? String
        if cell.favshelter_address.text == ""
        {
            cell.favshelter_address.text = "未輸入"
        }
        cell.favshelter_tel.text = favoriteArr[indexPath.row]["shelter_tel"] as? String
        if cell.favshelter_tel.text == ""
        {
            cell.favshelter_tel.text = "未輸入"
        }
        cell.favanimal_remark.text = favoriteArr[indexPath.row]["animal_remark"] as? String
        if cell.favanimal_remark.text == ""
        {
            cell.favanimal_remark.text = "未輸入"
        }
        cell.favanimal_sex.text = favoriteArr[indexPath.row]["animal_sex"] as? String
        if cell.favanimal_remark.text == "F"
        {
            cell.favanimal_remark.text = "女孩"
        }
        else if cell.favanimal_remark.text == "M"
        {
            cell.favanimal_remark.text = "男孩"
        }
        else
        {
            cell.favanimal_remark.text = "未輸入"
        }
        cell.favanimal_colour.text = favoriteArr[indexPath.row]["animal_colour"] as? String
        if cell.favanimal_colour.text == ""
        {
            cell.favanimal_colour.text = "未輸入"
        }
        cell.favanimal_bodytype.text = favoriteArr[indexPath.row]["animal_bodytype"] as? String
        if cell.favanimal_bodytype.text == "MINI"
        {
            cell.favanimal_bodytype.text = "迷你"
        }
        else if cell.favanimal_bodytype.text == "SMALL"
        {
            cell.favanimal_bodytype.text = "小型"
        }
        else if cell.favanimal_bodytype.text == "MEDIUM"
        {
            cell.favanimal_bodytype.text = "中型"
        }
        else if cell.favanimal_bodytype.text == "BIG"
        {
            cell.favanimal_bodytype.text = "大型"
        }
        else
        {
            cell.favanimal_bodytype.text = "未輸入"
        }
        cell.favanimal_age.text = favoriteArr[indexPath.row]["animal_age"] as? String
        if cell.favanimal_age.text == "CHILD"
        {
            cell.favanimal_age.text = "幼年"
        }
        else if cell.favanimal_age.text == "ADULT"
        {
            cell.favanimal_age.text = "成年"
        }
        else
        {
            cell.favanimal_age.text = "未輸入"
        }
        cell.favanimal_sterilization.text = favoriteArr[indexPath.row]["animal_sterilization"] as? String
        if cell.favanimal_sterilization.text == "T"
        {
            cell.favanimal_sterilization.text = "是"
        }
        else if cell.favanimal_sterilization.text == "F"
        {
            cell.favanimal_sterilization.text = "否"
        }
        else
        {
            cell.favanimal_sterilization.text = "未輸入"
        }
        cell.favanimal_bacterin.text = favoriteArr[indexPath.row]["animal_bacterin"] as? String
        if cell.favanimal_bacterin.text == "T"
        {
            cell.favanimal_bacterin.text = "是"
        }
        else if cell.favanimal_bacterin.text == "F"
        {
            cell.favanimal_bacterin.text = "否"
        }
        else
        {
            cell.favanimal_bacterin.text = "未輸入"
        }
        cell.favanimal_foundplace.text = favoriteArr[indexPath.row]["animal_foundplace"] as? String
        if cell.favanimal_foundplace.text == ""
        {
            cell.favanimal_foundplace.text = "未輸入"
        }
        //下載圖片並放到view上
        if let aPicUrl = favoriteArr[indexPath.row]["album_file"]
        {
            if aPicUrl as! String == ""
            {
                cell.favalbum_file.contentMode = .scaleToFill
                cell.favalbum_file.image = UIImage(named: "imgerror2")
            }
            else
            {
                cell.favalbum_file.image = UIImage(named: "img2")
                let url = URL(string: aPicUrl as! String)
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let dataTask = session.dataTask(with: url!, completionHandler:
                { (data, response, error) in
                    if error == nil
                    {
                        DispatchQueue.main.async
                            {
                                cell.favalbum_file.contentMode = .scaleAspectFit
                                cell.favalbum_file.image = UIImage(data: data!)
                                if cell.favalbum_file.image == nil
                                {
                                    cell.favalbum_file.contentMode = .scaleToFill
                                    cell.favalbum_file.image = UIImage(named: "imgerror2")
                                }
                        }
                    }
                    
                })
                dataTask.resume()
            }
            
        }
        else
        {
            cell.favalbum_file.contentMode = .scaleToFill
            cell.favalbum_file.image = UIImage(named: "imgerror2")
        }

        return cell
    }
    
    //指定向左滑動時顯示的按鈕
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        //右側增加"刪除"按鈕
        let deleteAction = UITableViewRowAction(style: .destructive, title: "刪除") { (rowAction, indexPath) in
            //實際刪除資料庫資料
            if self.db != nil
            {
                //取得目前滑動刪除的動物編號
                var currentNo = ""
                currentNo = self.favoriteArr[self.currentRow]["animal_id"] as! String
                //準備SQL指令（數位檔案使用?）
                let sql = String(format: "delete from favorite_animals where animal_id='%@'",currentNo)
                //將SQL指令轉成C語言字串
                let cSql = sql.cString(using: .utf8)!
                //宣告儲存執行結果的變數
                var statement:OpaquePointer?
                //準備執行SQL指令
                sqlite3_prepare_v2(self.db, cSql, -1, &statement, nil)
                //執行SQL指令
                if sqlite3_step(statement) == SQLITE_DONE
                {
                    //製作警告視窗
                    let alert = UIAlertController(title: "我的最愛", message: "資料刪除！", preferredStyle: .alert)
                    //加上視窗按鈕
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                    //顯示警告視窗
                    self.present(alert, animated: true, completion: nil)
                }
                //釋放SQL指令的連線
                sqlite3_finalize(statement)
            }
            //刪除對應的陣列元素（離線資料集）
            self.favoriteArr.remove(at: indexPath.row)
            //Step3.刪除表格中的特定儲存格
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        //回傳"刪除"按鈕組成的陣列
        return [deleteAction]
    }
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600.0
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

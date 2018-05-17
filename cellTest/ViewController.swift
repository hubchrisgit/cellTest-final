
import UIKit


class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate
{
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var areaTxtField: UITextField!
    @IBOutlet weak var typeTxtField: UITextField!
    @IBOutlet weak var sizeTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var colorTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    
    //紀錄目前輸入元件的Y軸底緣位置
    var currentObjectBottomYPosition:CGFloat = 0
    //目前正在操作的資料列
    var currentRow = 0
    //紀錄查詢到的資料表（離線資料集）
    var VCanimalobj:[[String:Any]] = []
    //儲存搜尋篩選過後的結果
    var searchResult = [[String:Any]]()
    
    //輸入時才會推入的PickerView
    var pkvArea:UIPickerView!
    var pkvType:UIPickerView!
    var pkvSize:UIPickerView!
    var pkvAge:UIPickerView!
    var pkvColor:UIPickerView!
    var pkvGender:UIPickerView!
    
    //PickerView的資料來源
    let arrArea = ["不限","基隆市","臺北市","新北市","桃園市","新竹市","新竹縣","苗栗縣","臺中市","彰化縣","南投縣","雲林縣","嘉義市","嘉義縣","台南市","高雄市","屏東縣","臺東縣","花蓮縣","宜蘭縣","澎湖縣","金門縣","連江縣"]
    let arrType = ["不限","狗","貓"]
    let arrSize = ["不限","迷你","小","中","大"]
    let arrAge = ["不限","幼年","成年"]
    let arrColor = ["不限","白","黑","棕","黃","米色","虎斑","玳瑁","咖啡","花色","其他"]
    let arrGender = ["不限","女","男"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let globalQueue = DispatchQueue.global(qos: .default)
        let mainBtnSearch = DispatchQueue.main
        globalQueue.async {
            //原始大檔案
            let url = URL(string: "https://quality.data.gov.tw/dq_download_json.php?nid=9842&md5_url=58c4f9225bcb1e6447bdb0605bdbe340")
            do
            {
                let json_byte_data = try Data(contentsOf: url!)
                self.VCanimalobj = try JSONSerialization.jsonObject(with: json_byte_data, options: .allowFragments) as! [[String:AnyObject]]
            }
            catch
            {
                print("error")
            }
            mainBtnSearch.async {
                if self.VCanimalobj.count != 0
                {
                    self.btnSearch.isEnabled = true
                    self.btnSearch.isHidden = false
                    self.btnSearch.setTitle("Search", for: .normal)
                }
            }

        }
        
        //註冊鍵盤彈出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        //註冊鍵盤收合的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(viewTouched))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        //建立Area的PickerView
        pkvArea = UIPickerView()
        pkvArea.tag = 0
        areaTxtField.inputAccessoryView = toolBar
        //建立Type的PickerView
        pkvType = UIPickerView()
        pkvType.tag = 1
        typeTxtField.inputAccessoryView = toolBar
        //建立Size的PickerView
        pkvSize = UIPickerView()
        pkvSize.tag = 2
        sizeTxtField.inputAccessoryView = toolBar
        //建立Age的PickerView
        pkvAge = UIPickerView()
        pkvAge.tag = 3
        ageTxtField.inputAccessoryView = toolBar
        //建立Color的PickerView
        pkvColor = UIPickerView()
        pkvColor.tag = 4
        colorTxtField.inputAccessoryView = toolBar
        //建立Gender的PickerView
        pkvGender = UIPickerView()
        pkvGender.tag = 5
        genderTxtField.inputAccessoryView = toolBar
        
        //指派PickerView的代理人及資料來源
        pkvArea.delegate = self
        pkvArea.dataSource = self
        pkvType.delegate = self
        pkvType.dataSource = self
        pkvSize.delegate = self
        pkvSize.dataSource = self
        pkvAge.delegate = self
        pkvAge.dataSource = self
        pkvColor.delegate = self
        pkvColor.dataSource = self
        pkvGender.delegate = self
        pkvGender.dataSource = self
        
        //指定性別與班別輸入時，對應的輸入方式為PickerView
        areaTxtField.inputView = pkvArea
        typeTxtField.inputView = pkvType
        sizeTxtField.inputView = pkvSize
        ageTxtField.inputView = pkvAge
        colorTxtField.inputView = pkvColor
        genderTxtField.inputView = pkvGender
        

        
    }
    
    //MARK: 自定函式
    func doneButtonhide()
    {
        
    }
    //鍵盤彈出觸發事件
    @objc func keyboardWillShow(_ sender:Notification)
    {
        print("鍵盤彈出")
        print("通知資訊：\(sender.userInfo!)")
        
        if let keyboardHeight = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
        {
            print("鍵盤高度：\(keyboardHeight)")
            //計算可視高度 = 底view的總高度 - 鍵盤高度
            let visiableHeight = view.frame.size.height - keyboardHeight
            //如果Y軸底緣位置比可視高度還高，表示元件被鍵盤遮住
            if currentObjectBottomYPosition > visiableHeight
            {
                //移動Y軸底緣位置與可視高度之間的差值
                view.frame.origin.y = -(currentObjectBottomYPosition - visiableHeight + 10)
            }
        }
        print("包含熱點欄的高度：\(UIApplication.shared.statusBarFrame.size.height)")
    }
    
    //鍵盤收合觸發事件
    @objc func keyboardWillHide()
    {
        print("鍵盤收合")
        //還原Y軸位置到原點
        if UIApplication.shared.statusBarFrame.size.height == 20 || UIApplication.shared.statusBarFrame.size.height == 40    //除了iPhoneX以外的狀態列高度
        {
            if UIApplication.shared.statusBarFrame.size.height < 40
            {
                //沒有熱點狀態列時
                view.frame.origin.y = 0
            }
            else
            {
                //有熱點狀態列時
                view.frame.origin.y = 20
            }
        }
        else    //iPhoneX的狀態列，不包含熱點為44pt
        {
            if UIApplication.shared.statusBarFrame.size.height < 44
            {
                //沒有熱點狀態列時
                view.frame.origin.y = 0
            }
            else
            {
                //有熱點狀態列時
                view.frame.origin.y = 20
            }
        }
    }
    
    //MARK: Target Action
    //當文字輸入時，按下鍵盤的return鍵，會觸發Did End On Exit（設定此事件才會自動收起鍵盤）
    @IBAction func didEndOnExit(_ sender: UITextField)
    {
        //        print("Did End On Exit")
    }
    
    @IBAction func editDidBegin(_ sender: UITextField)
    {
        print("\(sender.tag):開始編輯")
        //紀錄目前輸入元件的Y軸底緣位置
        currentObjectBottomYPosition = sender.frame.origin.y + sender.frame.size.height
        
        switch sender.tag
        {
            
        case 0:
            areaTxtField.text = arrArea[0]
        case 1:
            typeTxtField.text = arrType[0]
        case 2:
            colorTxtField.text = arrColor[0]
        case 3:
            sizeTxtField.text = arrSize[0]
        case 4:
            ageTxtField.text = arrAge[0]
        case 5:
            genderTxtField.text = arrGender[0]
        default:
            sender.keyboardType = .default
        }
    }
    
    @IBAction func editDidEnd(_ sender: UITextField)
    {
        print("\(sender.tag):結束編輯")
        //收起鍵盤(交出第一回應權)
        sender.resignFirstResponder()
    }
    
    @IBAction func viewTouched(_ sender: UITapGestureRecognizer)
    {
        print("點擊了底面")
        //收起鍵盤(交出第一回應權)
        //        //<方法一>請所有會喚出鍵盤的物件都交出第一回應權
        //        for subView in view.subviews
        //        {
        //            if subView is UITextField
        //            {
        //                subView.resignFirstResponder()
        //            }
        //        }
        
        //<方法二>由底View執行收起鍵盤
        view.endEditing(true)
    }
    
    //MARK:UIPickerViewDataSource
    //每一個滾輪有幾段
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    //每一段滾輪有幾行資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return arrArea.count
        }
        else if pickerView.tag == 1
        {
            return arrType.count
        }
        else if pickerView.tag == 2
        {
            return arrSize.count
        }
        else if pickerView.tag == 3
        {
            return arrAge.count
        }
        else if pickerView.tag == 4
        {
            return arrColor.count
        }
        else
        {
            return arrGender.count
        }
    }
    
    //MARK: UIPickerViewDelegate
    //提供PickerView的每一段每一行的文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 0
        {
            return arrArea[row]
        }
        else if pickerView.tag == 1
        {
            return arrType[row]
        }
        else if pickerView.tag == 2
        {
            return arrSize[row]
        }
        else if pickerView.tag == 3
        {
            return arrAge[row]
        }
        else if pickerView.tag == 4
        {
            return arrColor[row]
        }
        else
        {
            return arrGender[row]
        }
    }
    
    //選定滾輪的特定資料行時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("滾輪\(pickerView.tag):\(row)")
        if pickerView.tag == 0
        {
            areaTxtField.text = arrArea[row]
        }
        else if pickerView.tag == 1
        {
            typeTxtField.text = arrType[row]
        }
        else if pickerView.tag == 2
        {
            sizeTxtField.text = arrSize[row]
        }
        else if pickerView.tag == 3
        {
            ageTxtField.text = arrAge[row]
        }
        else if pickerView.tag == 4
        {
            colorTxtField.text =  arrColor[row]
        }
        else if pickerView.tag == 5
        {
            genderTxtField.text =  arrGender[row]
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton)
    {
        var tempo1 = [[String:Any]]()
        var tempo2 = [[String:Any]]()
        if VCanimalobj.count != 0
        {
            ///////type//////////
            if VCanimalobj.count > 0
            {
                for typei in 0...(VCanimalobj.count - 1)
                {
                    if typeTxtField.text == "貓"
                    {
                        if VCanimalobj[typei]["animal_kind"] as! String == "貓"
                        {
                            tempo1.append(VCanimalobj[typei])
                        }
                    }
                    else if typeTxtField.text == "狗"
                    {
                        if VCanimalobj[typei]["animal_kind"] as! String == "狗"
                        {
                            tempo1.append(VCanimalobj[typei])
                        }
                    }
                    else
                    {
                        tempo1.append(VCanimalobj[typei])
                    }
                }
            }
            ///////type//////////
            
            ///////age//////////
            if tempo1.count > 0
            {
                for agei in 0...(tempo1.count - 1)
                {
                    if ageTxtField.text == "幼年"
                    {
                        if tempo1[agei]["animal_age"] as! String == "CHILD"
                        {
                            tempo2.append(tempo1[agei])
                        }
                    }
                    else if ageTxtField.text == "成年"
                    {
                        if tempo1[agei]["animal_age"] as! String == "ADULT"
                        {
                            tempo2.append(tempo1[agei])
                        }
                    }
                    else
                    {
                        tempo2.append(tempo1[agei])
                    }
                }
            }
            ///////age//////////
            
            ///////size//////////
            tempo1.removeAll()
            if tempo2.count > 0
            {
                for sizei in 0...(tempo2.count - 1)
                {
                    if sizeTxtField.text == "迷你"
                    {
                        if tempo2[sizei]["animal_bodytype"] as! String == "MINI"
                        {
                            tempo1.append(tempo2[sizei])
                        }
                    }
                    else if sizeTxtField.text == "小"
                    {
                        if tempo2[sizei]["animal_bodytype"] as! String == "SMALL"
                        {
                            tempo1.append(tempo2[sizei])
                        }
                    }
                    else if sizeTxtField.text == "中"
                    {
                        if tempo2[sizei]["animal_bodytype"] as! String == "MEDIUM"
                        {
                            tempo1.append(tempo2[sizei])
                        }
                    }
                    else if sizeTxtField.text == "大"
                    {
                        if tempo2[sizei]["animal_bodytype"] as! String == "BIG"
                        {
                            tempo1.append(tempo2[sizei])
                        }
                    }
                    else
                    {
                        tempo1.append(tempo2[sizei])
                    }
                }
            }
            ///////size//////////
            
            ///////color//////////
            tempo2.removeAll()
            if tempo1.count > 0
            {
                for genderi in 0...(tempo1.count - 1)
                {
                    if genderTxtField.text == "女"
                    {
                        if tempo1[genderi]["animal_sex"] as! String == "F"
                        {
                            tempo2.append(tempo1[genderi])
                        }
                    }
                    else if genderTxtField.text == "男"
                    {
                        if tempo1[genderi]["animal_sex"] as! String == "M"
                        {
                            tempo2.append(tempo1[genderi])
                        }
                    }
                    else
                    {
                        tempo2.append(tempo1[genderi])
                    }
                }
            }
            ///////color//////////
            
            ///////area//////////
            //let arrArea = ["不限","基隆市","臺北市","新北市","桃園市","新竹市","新竹縣","苗栗縣","臺中市","彰化縣","南投縣","雲林縣","嘉義市","嘉義縣","台南市","高雄市","屏東縣","臺東縣","花蓮縣","宜蘭縣","澎湖縣","金門縣","連江縣"]
            tempo1.removeAll()
            if tempo2.count > 0
            {
                for areai in 0...(tempo2.count - 1)
                {
                    if areaTxtField.text == "臺北市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "2"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "新北市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "3"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "基隆市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "4"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "宜蘭縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "5"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "桃園市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "6"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "新竹縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "7"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "新竹市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "8"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "苗栗縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "9"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "臺中市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "10"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "彰化縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "11"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "南投縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "12"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "雲林縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "13"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "嘉義縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "14"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "嘉義市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "15"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "台南市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "16"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "高雄市"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "17"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "屏東縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "18"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "花蓮縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "19"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "臺東縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "20"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "澎湖縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "21"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "金門縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "22"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else if areaTxtField.text == "連江縣"
                    {
                        if tempo2[areai]["animal_area_pkid"] as! String == "23"
                        {
                            tempo1.append(tempo2[areai])
                        }
                    }
                    else
                    {
                        tempo1.append(tempo2[areai])
                    }
                }
            }
            ///////area//////////
            
            ///////colour//////////animal_colour["不限","白","黑","棕","黃","米色","虎斑","玳瑁","咖啡","花色","其他"]
            tempo2.removeAll()
            if tempo1.count > 0
            {
                for colouri in 0...(tempo1.count - 1)
                {
                    if colorTxtField.text == "白"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("白") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "黑"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("黑") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "棕"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("棕") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "黃"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("黃") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "米"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("米") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "虎斑"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("虎斑") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "玳瑁"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("玳瑁") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "咖啡"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("咖啡") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "花色"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("花色") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else if colorTxtField.text == "其他"
                    {
                        if (tempo1[colouri]["animal_colour"] as! String).contains("其他") == true
                        {
                            tempo2.append(tempo1[colouri])
                        }
                    }
                    else
                    {
                        tempo2.append(tempo1[colouri])
                    }
                }
            }
            ///////colour//////////
            searchResult = tempo2
            
        }
        else
        {
            print("資料尚未下載完")
        }
    }
    
    //由導覽線換頁時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        print("由導覽線換頁")
        if segue.identifier == "gotoMyTableView"
        {
            let myTableVC = segue.destination as! MyTableViewController
            //通知詳細資料頁面，第一頁的表格控制器實體所在位置
            myTableVC.myViewController = self
        }
        else if  segue.identifier == "gotoFavorite1"
        {
            let favoirteVC = storyboard?.instantiateViewController(withIdentifier: "FavoirteTableViewController") as! FavoirteTableViewController
            //傳遞本頁給新增畫面
            favoirteVC.myViewController = self
        }
 
    }
}


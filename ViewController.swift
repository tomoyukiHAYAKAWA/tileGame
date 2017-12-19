//
//  ViewController.swift
//  opencvTest
//
//  Created by Tomoyuki Hayakawa on 2017/12/08.
//  Copyright © 2017年 Tomoyuki Hayakawa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //--------------------------OpenCVファイルのインポート
    let openCV = opencvWrapper()
    //--------------------------
    
    // 答えを表示するUIImageView
    @IBOutlet var ansImage : UIImageView!
    
    // タイルのUIImageview
    @IBOutlet var tileImage_0 : UIImageView!
    @IBOutlet var tileImage_1 : UIImageView!
    @IBOutlet var tileImage_2 : UIImageView!
    @IBOutlet var tileImage_3 : UIImageView!
    @IBOutlet var tileImage_4 : UIImageView!
    @IBOutlet var tileImage_5 : UIImageView!
    @IBOutlet var tileImage_6 : UIImageView!
    @IBOutlet var tileImage_7 : UIImageView!
    @IBOutlet var tileImage_8 : UIImageView!
    @IBOutlet var tileImage_9 : UIImageView!
    @IBOutlet var tileImage_10 : UIImageView!
    @IBOutlet var tileImage_11 : UIImageView!
    @IBOutlet var tileImage_12 : UIImageView!
    @IBOutlet var tileImage_13 : UIImageView!
    @IBOutlet var tileImage_14 : UIImageView!
    @IBOutlet var tileImage_15 : UIImageView!
    
    @IBOutlet weak var chooseBtn : UIButton!
    @IBOutlet weak var takePictureBtn : UIButton!
    @IBOutlet weak var newGameBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    
    
    // 分割画像格納配列
    var imageArray : [UIImage] = []
    var imagePos : [Int] = []
    var currentPos : [Int] = []
    var posiNum : [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    // タッチフラグ
    var isChoosePhoto : Bool!
    
    var shuffleTimes : Int!

    // 再生する音源のインスタンス
    var audioPlayerInstance : AVAudioPlayer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--------------------------------------------------------------------------タッチイベントのためのタグ付け
        for index in 0..<16 {
            let tileImage = value(forKey: "tileImage_\(index)") as! UIImageView
            tileImage.isUserInteractionEnabled = true
            tileImage.tag = index
        }
        //--------------------------------------------------------------------------
        
        // 写真を選んだフラグ
        isChoosePhoto = false
        // 難易度
        shuffleTimes = 8
        // サウンドファイルのパスを生成
        let soundFilePath = Bundle.main.path(forResource: "slide", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        audioPlayerInstance.prepareToPlay()
        
        // ボタン無効化
        restartBtn.isEnabled = false
        newGameBtn.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------------------------------------------写真を選ぶボタン
    @IBAction func chooseBtn(sender: Any) {
        // カメラロールが利用できるかどうか
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            pickerView.allowsEditing = true
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    //--------------------------------------------------------------------------
    
    @IBAction func takePictureBtn(_ sender: Any) {
        
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let pickerView = UIImagePickerController()
            pickerView.sourceType = sourceType
            pickerView.delegate = self
            pickerView.allowsEditing = true
            
            self.present(pickerView, animated: true, completion: nil)
            
        }
    }
    
    
    //--------------------------------------------------------------------------新規スタートボタン
    @IBAction func newGameBtn(_ sender: Any) {
        //アラートの表示
        let alertController = UIAlertController(title: "Attention!", message: "Do you want start new game?", preferredStyle: UIAlertControllerStyle.alert)
        // OKボタン
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            // OKがクリックされた時の処理
            self.reset()
        }
        // CANCELボタンの実装
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        // ボタンの追加
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        // アラートの表示
        present(alertController,animated: true,completion: nil)
    }
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------やり直しボタン
    @IBAction func restartBtn(_ sender: Any) {
        // アラートの表示
        let alertController = UIAlertController(title: "Attention!", message: "Do you want reset this game?", preferredStyle: UIAlertControllerStyle.alert)
        // OKボタン
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            // OKがクリックされた時の処理
            for index in 0..<16 {
                // indexでポジションを選ぶ
                let tileImage = self.value(forKey: "tileImage_\(index)") as! UIImageView
                tileImage.image = self.imageArray[self.imagePos[index]]
            }
        }
        // CANCELボタンの実装
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        // ボタンの追加
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        // アラートの表示
        present(alertController,animated: true,completion: nil)
    }
    //--------------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------------撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        // 選ばれた画像の右下を塗りつぶしてchooseImageへ入れる
        let chooseImage = openCV.createModel(image)
        // ビューに表示する
        self.ansImage.image = chooseImage
        imageArray = openCV.splitImage(chooseImage) as! [UIImage];
        
        // タイルシャッフル関数
        shuffle()
        
        // 写真選択フラッグ
        isChoosePhoto = true
        
        // 写真撮影，選択ボタンの無効化
        takePictureBtn.isEnabled = false
        chooseBtn.isEnabled = false
        
        // リセット，新規ゲームボタンの有効化
        restartBtn.isEnabled = true
        newGameBtn.isEnabled = true
        
        print(currentPos)
        //print(imagePos)
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------タッチイベントの検出
    //--------------------------------------------------------------------------タイルの移動
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isChoosePhoto == true {
            audioPlayerInstance.play()
            for touch: UITouch in touches {
                let tag = touch.view!.tag
                switch tag {
                case 0:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 1:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                
                case 2:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 3:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 左
                    if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 4:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 5:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 6:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 7:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 8:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 9:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 10:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 11:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 下
                    } else if currentPos[tag+4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+4]
                        currentPos[tag+4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 12:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 13:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 14:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 右
                    if currentPos[tag+1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag+1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag+1]
                        currentPos[tag+1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 左
                    } else if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                    
                case 15:
                    let tmpImage : UIImage!
                    let tmpNum : Int!
                    let tile_c = value(forKey: "tileImage_\(tag)") as! UIImageView
                    // 左
                    if currentPos[tag-1] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-1)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-1]
                        currentPos[tag-1] = currentPos[tag]
                        currentPos[tag] = tmpNum
                        
                    // 上
                    } else if currentPos[tag-4] == 15 {
                        let tile_n = value(forKey: "tileImage_\(tag-4)") as! UIImageView
                        tmpImage = tile_c.image
                        tile_c.image = tile_n.image
                        tile_n.image = tmpImage
                        tmpNum = currentPos[tag-4]
                        currentPos[tag-4] = currentPos[tag]
                        currentPos[tag] = tmpNum
                    }
                default:
                    break
                }
                print(currentPos)
                // 判定
                judge()
            }
        }
    }
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------タイルシャッフル
    func shuffle() {
        // ポジションシャッフル
        for _ in 0..<shuffleTimes {
            let index1 = Int(arc4random_uniform(UInt32(UInt(posiNum.count))))
            var index2 : Int!
            while true {
                index2 = Int(arc4random_uniform(UInt32(UInt(posiNum.count))))
                if index1 != index2 {
                    break
                }
            }
            print(posiNum[index1])
            print(posiNum[index2])
            let tmp = posiNum[index1]
            posiNum[index1] = posiNum[index2]
            posiNum[index2] = tmp
            print(posiNum)
        }
        // ポジション決めループ
        for i in 0..<16 {
            imagePos.append(posiNum[i])
        }
        // 表示ループ
        for index in 0..<16 {
            // indexでポジションを選ぶ
            let tileImage = value(forKey: "tileImage_\(index)") as! UIImageView
            tileImage.image = imageArray[imagePos[index]]
            currentPos.append(imagePos[index])
            // 各画像の現在地
        }
    }
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------リセット処理
    func reset() {
        for index in 0..<16 {
            // タイルの画像を全て消す
            let tileImage = value(forKey: "tileImage_\(index)") as! UIImageView
            tileImage.image = UIImage(named: "")
            // ポジションの初期化
            posiNum[index] = index
        }
        
        imageArray.removeAll()
        imagePos.removeAll()
        currentPos.removeAll()
        
        // 答えの画像を消す
        ansImage.image = UIImage(named: "")
        // 写真選んだフラグを折る
        isChoosePhoto = false
        // 各ボタンの無効化有効化
        newGameBtn.isEnabled = false
        restartBtn.isEnabled = false
        chooseBtn.isEnabled = true
        takePictureBtn.isEnabled = true
    }
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------完成したか判定
    func judge() {
        // 正解数
        var trueCount : Int = 0
        // 配列を操作し，正解している数を数える
        for index in 0..<16 {
            if currentPos[index] == index {
                trueCount = trueCount+1
            }
        }
        // 全て正しい位置
        if trueCount == 16 {
            // クリア通知
            let alertController = UIAlertController(title: "Well Done", message: "You were completed this pazzle.", preferredStyle: UIAlertControllerStyle.alert)
            // OKボタン
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                // OKがクリックされた時の処理
                self.reset()
            }
            // CANCELボタンの実装
            let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
            // ボタンの追加
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
            // アラートの表示
            present(alertController,animated: true,completion: nil)
        }
    }
    //--------------------------------------------------------------------------
}

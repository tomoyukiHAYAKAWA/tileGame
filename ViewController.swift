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
        // Do any additional setup after loading the view, typically from a nib.
        // タッチイベントのためのタグ付け
        for index in 0..<16 {
            let tileImage = value(forKey: "tileImage_\(index)") as! UIImageView
            tileImage.isUserInteractionEnabled = true
            tileImage.tag = index
        }
        // 写真を選んだフラグ
        isChoosePhoto = false
        
        // 難易度
        shuffleTimes = 32
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 写真を選ぶボタン
    @IBAction func chooseBtn() {
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

    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
        print(currentPos)
        //print(imagePos)
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    // タッチイベントの検出
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
    
    // タイルシャッフル
    func shuffle() {
        // ポジションシャッフル
        for _ in 0...shuffleTimes {
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
    
    // 完成したか判定
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
            print("クリア")
        
        // そうじゃない時
        } else {
            print("まだ")
        }
    }
}

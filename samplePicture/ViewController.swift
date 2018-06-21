//
//  ViewController.swift
//  samplePicture
//
//  Created by yuka on 2018/06/21.
//  Copyright © 2018年 yuka. All rights reserved.
//

import UIKit

class ViewController: UIViewController
    ,UIImagePickerControllerDelegate
    ,UINavigationControllerDelegate
{

    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // カメラボタンが押されたら発動
    @IBAction func tapCameraButton(_ sender: UIBarButtonItem) {
        
        // カメラが使えるかチェックする　シミュレータはスキップされます
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            print("カメラが使える")
            
            // UIImagePickerControllerのインスタンス作成
            let picker = UIImagePickerController()
            
            // 使用するソースの設定
            picker.sourceType = .camera
            
            // デリゲートメソッド（撮影後に発動する技）が使えるように設定
            picker.delegate = self
            
            // 撮影モード画面を表示
            present(picker, animated: true, completion: nil)
            
            
        }
        
    }
    
    // フォルダボタンが押されたら発動
    @IBAction func tapLibraryButton(_ sender: UIBarButtonItem) {
        
        // カメラが使えるかチェックする　シミュレータはスキップされます
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            print("フォトライブラリが使える")
            
            // UIImagePickerControllerのインスタンス作成
            let picker = UIImagePickerController()
            
            // 使用するソースの設定
            picker.sourceType = .savedPhotosAlbum
            
            // デリゲートメソッド（撮影後に発動する技）が使えるように設定
            picker.delegate = self
            
            // 撮影モード画面を表示
            present(picker, animated: true, completion: nil)
            
            
        }
    }
    
    // カメラが撮り終わった後に発動する  、　フォトライブラリから選択した時にも発動
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print(info)
        
        // infoの中から撮影されたイメージを取り出し
        let takenimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 表示
        pictureImageView.image = takenimage
        
        if info[UIImagePickerControllerImageURL] == nil {
            // フォトライブラリに保存
            UIImageWriteToSavedPhotosAlbum(takenimage, nil, nil, nil)

        }
        
        // モーダルで表示した撮影モード画面を閉じる
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


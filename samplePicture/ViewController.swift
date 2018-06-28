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
        // Documentsフォルダを見るためにプリント
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
    }


    // Actionボタンが押されたら発動
    @IBAction func tapShare(_ sender: UIBarButtonItem) {
        // シェア用画面の作成（インスタンス)
        let controller = UIActivityViewController(activityItems: [pictureImageView.image!,"文章が入れられます"], applicationActivities: nil)
        
        controller.popoverPresentationController?.sourceView = self.view
        
        // シェア用画面
        present(controller, animated: true, completion: nil)
        
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
        
        storeJpgImageInDocument(image: takenimage, name: "1.jpg")
        
    }
    
    
    
    //=========================
    // JPGをDocumentsフォルダへ保存
    //=========================
    // documentDirectoryはユーザが生成したデータをアプリ内に保存する
    // 他にもtmp,Libray/Cacheなどがある
    func storeJpgImageInDocument(image: UIImage , name: String) {
        let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // [String]型
        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true) //URL型 Documentpath
        
        let dataPath = dataUrl.appendingPathComponent(name)
        //URL型 documentへのパス + ファイル名
        
        // UIImageJPEGRepresentationの後ろは1が最大のクオリティ
        // https://qiita.com/marty-suzuki/items/159b1c5d47fb00c11fda
        let myData = UIImageJPEGRepresentation(image, 1.0)! as NSData // Data?型　→ NSData型
        
        myData.write(toFile: dataPath.path , atomically: true) // NSData型の変数.write(String型,Bool型)
    }
    
    //=============================
    // JPGをdocumentフォルダから読み出し
    //==============================
    func readJpgImageInDocument(nameOfImage: String) -> UIImage? {
        let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // [String]型

        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true)  //URL型 Documentpath
        let dataPath = dataUrl.appendingPathComponent(nameOfImage)
        
        do {
            
            let myData = try Data(contentsOf: dataPath, options: [])
            let image =  UIImage.init(data: myData)

            return image
            
        }catch {
            print(error)
            return nil
        }
        
    }
    
    //===========================
    // JPGをdocumentフォルダから削除
    //===========================
    func deleteJpgImageInDocument(nameOfImage: String){
        let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // [String]型
        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true)  //URL型 Documentpath
        let dataPath = dataUrl.appendingPathComponent(nameOfImage)
        
        
        do {
            let fileManager = FileManager.default
            // Check if file exists

            if fileManager.fileExists(atPath: dataPath.path) {
                // Delete file
                try fileManager.removeItem(atPath: dataPath.path)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  Vibe
//
//  Created by 신민우 on 2020/02/09.
//  Copyright © 2020 신민우. All rights reserved.
//

//카메라 포토 라이브러리를 사용하기 위해서 imagePickerController와
//이 컨트롤러를 사용하기 위한 델리게이트 프로토콜이 필요하다.
//그리고 미디어 타입이 정의된 헤더 파일이 있어야 한다.
import UIKit
import MobileCoreServices //다양한 타입들을 정의해 놓은 헤더 파일

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //인스턴스 변수 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    //촬영하거나 포토라이브러리에서 불러온 이미지 저장하는 변수
    var captureImage: UIImage!
    //녹화한 비디오의 url을 저장하는 변수
    var videoURL: URL!
    //이미지 저장 여부를 나타낼 변수
    var flagImageSave = false
    
    @IBOutlet var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //비디오 촬영
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton){
        //카메라의 사용가능 여부를 확인
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            //이미지 저장 허용
            flagImageSave = true
            
            imagePicker.delegate = self
            //이미지 피커의 소스 타입을 camera로 설정
            imagePicker.sourceType = .camera
            //미디어 타입설정
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            //편집 사용 안함
            imagePicker.allowsEditing = false
            //뷰 컨트롤러를 imagePicker로 대채
            present(imagePicker,animated: true,completion: nil)
        } else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    //사진이나 비디오 촬영을 하거나 포토 라이브러리에서 선택이 끝났을 때 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //미디어 종류 확인
        let mediaType = info[.mediaType] as! NSString
        
        //미디어 종류가 비디오일 경우
        if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            if flagImageSave {
                //촬영한 비디오를 포토 라이브러리에 저장
                videoURL = (info[.mediaURL] as! URL)
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        //현재의 뷰 컨트롤러 제거. 즉, 뷰에서 이미지 피커 화면을 제거하여 초기 뷰를 보여준다.
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //비디오 불러오기
    @IBAction func btnLoadVideoFromLibary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("photo album inaccessable", message: "Application cannot access the photo album")
        }
    }
          
    //경고 표시용 메서드 작성하기
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}



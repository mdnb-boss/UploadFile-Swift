//
//  ViewController.swift
//  UploadFiles
//
//  Created by Marcelo Brasil on 04/02/20.
//  Copyright © 2020 Marcelo Daniel. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let rest = RestManager()
    
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        img.image = UIImage(named: "podcast")
        
    }
    
    func uploadSingleFile() {
        let fileURL = Bundle.main.url(forResource: "sampleText", withExtension: "txt")
        let fileInfo = RestManager.FileInfo(withFileURL: fileURL, filename: "sampleText.txt", name: "uploadedFile", mimetype: "text/plain")
        
        rest.httpBodyParameters.add(value: "Hello 😀 !!!", forKey: "greeting")
        rest.httpBodyParameters.add(value: "AppCoda", forKey: "user")
        
        upload(files: [fileInfo], toURL: URL(string: "http://192.168.0.72:3000/upload"))
    }
    
    
    
    func uploadMultipleFiles() {
        let textFileURL = Bundle.main.url(forResource: "sampleText", withExtension: "txt")
        let textFileInfo = RestManager.FileInfo(withFileURL: textFileURL, filename: "sampleText.txt", name: "uploadedFile", mimetype: "text/plain")
        
        let pdfFileURL = Bundle.main.url(forResource: "samplePDF", withExtension: "pdf")
        let pdfFileInfo = RestManager.FileInfo(withFileURL: pdfFileURL, filename: "samplePDF.pdf", name: "uploadedFile", mimetype: "application/pdf")
        
        let imageFileURL = Bundle.main.url(forResource: "sampleImage", withExtension: "jpg")
        let imageFileInfo = RestManager.FileInfo(withFileURL: imageFileURL, filename: "sampleImage.jpg", name: "uploadedFile", mimetype: "image/jpg")
        
        upload(files: [textFileInfo, pdfFileInfo, imageFileInfo], toURL: URL(string: "http://192.168.0.72:3000/multiupload"))
    }
    
    
    
    func upload(files: [RestManager.FileInfo], toURL url: URL?) {
        if let uploadURL = url {
            rest.upload(files: files, toURL: uploadURL, withHttpMethod: .post) { (results, failedFilesList) in
                print("HTTP status code:", results.response?.httpStatusCode ?? 0)
                
                if let error = results.error {
                    print(error)
                }
                
                if let data = results.data {
                    if let toDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        print(toDictionary)
                    }
                }
                
                if let failedFiles = failedFilesList {
                    for file in failedFiles {
                        print(file)
                    }
                }
            }
        }
    }
    
    
    @IBAction func handlerUpload(_ sender: Any) {
        let img = UIImage(named: "podcast.png")
        // uploadMultipleFiles()
        
        // let fileURL = Bundle.main.url(forResource: "sampleText", withExtension: "txt")
        
        
        let fileInfo = RestManager.FileInfo(withFileData: img?.pngData(), filename: "podcast.png", name: "uploadedFile", mimetype: "image/png")
        
        rest.httpBodyParameters.add(value: "Hello 😀 !!!", forKey: "greeting")
        rest.httpBodyParameters.add(value: "AppCoda", forKey: "user")
        
        upload(files: [fileInfo], toURL: URL(string: "http://192.168.0.72:3000/upload"))
    }
    
}

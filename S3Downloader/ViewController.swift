//
//  ViewController.swift
//  S3Downloader
//
//  Created by Bryan on 12/3/16.
//  Copyright © 2016 bcattle. All rights reserved.
//

// source: https://aws.amazon.com/blogs/mobile/amazon-s3-transfer-utility-for-ios/
// alternative: AWSS3TransferManager, 
//      see the process at http://docs.aws.amazon.com/mobile/sdkforios/developerguide/s3transfermanager.html#download-an-object 

import UIKit
import AWSS3

class ViewController: UIViewController {

    var downloadTask:AWSTask<AWSS3TransferUtilityDownloadTask>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func startTapped() {
        if downloadTask == nil {
            doDownload()
        }
    }

    func doDownload() {
        // Download the file using the S3 Transfer Utility
        let sourceBucket = "com.github.bcattle.s3downloader.assets"
        let sourceKey = "%23282+Max+Graham_+Cycles+Radio.mp3"
        let targetUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("download.mp3")!
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = progressHandler
        
        let transferUtility = AWSS3TransferUtility.default()
        downloadTask = transferUtility.download(to: targetUrl, bucket: sourceBucket, key: sourceKey, expression: expression, completionHander: nil)
        downloadTask!.continue({ (task: AWSTask<AWSS3TransferUtilityDownloadTask>) -> AnyObject? in
            
            if let error = task.error {
                print("Error: \(error)")
            }
            if let exception = task.exception {
                print("Exception: \(exception)")
            }
            if let downloadTask = task.result {
                // Do something with downloadTask.
                // it should be a AWSS3TransferUtilityDownloadTask
                print("Result: \(downloadTask)")
            }
            
            return nil
        })
    }
    
    func progressHandler(task: AWSS3TransferUtilityTask, progress:Progress) {
        DispatchQueue.main.async {
            
            // ...
        }
    }
    
    func downloadCompleteHandler(task: AWSS3TransferUtilityDownloadTask, location: NSURL?, data: NSData?, error: NSError?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Error: \(error)")
            }
            else if let location = location {
                print("Finished download to \(location)")
            }
            else {
                print("Error, didn't get a location back")
            }
            
            // ...
            
        }
        downloadTask = nil
    }
}


/*

    投稿時　録画することで添付する
    録画画面

*/


import UIKit
import AVFoundation
import AssetsLibrary
import Photos

class VideoRecordViewController: UIViewController , AVCaptureFileOutputRecordingDelegate {
    
    private var videoOutput : AVCaptureMovieFileOutput!
    private var filePath : String?
    
    private var isRecording : Bool = false
    
    var delegate : AppendImageDelegate! = nil
    
    
    //時間制限用
    var count : Float = 0
    var timer : NSTimer!
    @IBOutlet weak var timerLabel: UILabel!
    
  
    @IBOutlet weak var backButton: UIButton!
    @IBAction func pushedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButtonPush(sender: AnyObject) {
        if !videoOutput.recording {
            //録画時
            self.isRecording = true
            self.recordButton.setTitle("停止", forState: UIControlState.Normal)
            
            let path = NSTemporaryDirectory()
            
            // フォルダ.
            let tempDirectory = path
            
            // ファイル名.
            filePath = "\(tempDirectory)/temp.mp4"
            
            // URL.
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)!
            
            // 録画開始.
            videoOutput.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
        } else {
            // 停止時
            self.isRecording = false
            self.recordButton.setTitle("録画", forState: UIControlState.Normal)
            videoOutput.stopRecording()
        }
    }
   


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let session     : AVCaptureSession          = AVCaptureSession()
        var device      : AVCaptureDevice!
        let devices     = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        let audioDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio)
        let audioInput  = AVCaptureDeviceInput.deviceInputWithDevice(audioDevice[0] as! AVCaptureDevice, error: nil) as! AVCaptureInput
        
        
        for dev in devices {
            if (dev.position == AVCaptureDevicePosition.Back) {
                device = dev as! AVCaptureDevice
            }
        }
        
        
        let videoInput  = AVCaptureDeviceInput.deviceInputWithDevice(device, error: nil) as! AVCaptureInput
        
        session.addInput(videoInput)
        session.addInput(audioInput)
        
        
        videoOutput = AVCaptureMovieFileOutput()
        videoOutput.maxRecordedDuration = CMTimeMakeWithSeconds(10 * 30, 30)
        videoOutput.minFreeDiskSpaceLimit = 1024 * 1024
        
        session.addOutput(videoOutput)
        
        
        videoOutput.connectionWithMediaType(AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.LandscapeRight
        
        
        //画面表示部
        let videoLayer : AVCaptureVideoPreviewLayer =
        AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        
        
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoLayer.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
        
        self.view.layer.addSublayer(videoLayer)
        session.startRunning()
        
        self.view.bringSubviewToFront(recordButton)
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(timerLabel)
    }
    
    
    //録画開始時に発動される
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        println("recording starts")
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerCount:", userInfo: nil, repeats: true)
    }
    
    
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        println("recording finished")
        
        let asset : AVURLAsset = AVURLAsset(URL: outputFileURL, options: nil)
        let imageGenerator : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let cutPoint   : CMTime = CMTimeMake(0, 30)
        let actualTime : CMTime = CMTimeMake(0, 30)
        let imageRef : CGImageRef!
        = imageGenerator.copyCGImageAtTime(asset.duration, actualTime: nil, error: nil)
        let image = UIImage(CGImage: imageRef)
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let writeData : NSData = NSData(contentsOfURL: outputFileURL)!
        
        if let path = self.filePath {
            let pathURL = NSURL(fileURLWithPath: path)!
            self.delegate.returnData(image!, url: pathURL, rawData: writeData , mediaType : PHAssetMediaType.Video)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func timerCount(timer : NSTimer) {
        self.count += 0.1
        timerLabel.text = "\(count)"
        
        if count > 6.0 {
            count = 6.0
            timerLabel.text = "\(count)"
            timer.invalidate()
            videoOutput.stopRecording()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

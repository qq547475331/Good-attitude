import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var audioChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 配置音频会话通道
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    audioChannel = FlutterMethodChannel(name: "good_mindset/audio", binaryMessenger: controller.binaryMessenger)
    
    audioChannel?.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "configureAudioSession" {
        self.configureAudioSession()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    // 添加音频会话中断通知
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleAudioSessionInterruption),
      name: AVAudioSession.interruptionNotification,
      object: AVAudioSession.sharedInstance()
    )
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureAudioSession() {
    do {
      try AVAudioSession.sharedInstance().setCategory(
        .playback,
        mode: .default,
        options: [.mixWithOthers, .duckOthers]
      )
      try AVAudioSession.sharedInstance().setActive(true)
      
      // 设置后台任务
      UIApplication.shared.beginReceivingRemoteControlEvents()
    } catch {
      print("无法设置音频会话: \(error)")
    }
  }
  
  @objc func handleAudioSessionInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else {
      return
    }
    
    let type = AVAudioSession.InterruptionType(rawValue: typeValue)
    
    // 向Flutter发送中断状态
    if type == .began {
      // 音频被中断
      audioChannel?.invokeMethod(
        "onAudioInterruption",
        arguments: ["interrupted": true]
      )
    } else if type == .ended {
      // 中断结束
      let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt
      let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue ?? 0)
      
      // 如果可以恢复播放
      if options.contains(.shouldResume) {
        // 延迟一点再恢复，确保系统准备好
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.audioChannel?.invokeMethod(
            "onAudioInterruption",
            arguments: ["interrupted": false]
          )
        }
      }
    }
  }
  
  override func applicationWillTerminate(_ application: UIApplication) {
    NotificationCenter.default.removeObserver(self)
    super.applicationWillTerminate(application)
  }
}

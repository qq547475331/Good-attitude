import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLooping = false;
  String? _currentAsset;
  
  // 播放状态
  bool get isPlaying => _isPlaying;
  
  // 循环状态
  bool get isLooping => _isLooping;
  
  // 当前资源
  String? get currentAsset => _currentAsset;
  
  // 初始化
  Future<void> init() async {
    // 配置播放模式为媒体播放器
    try {
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      print('设置播放模式错误: $e');
    }
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
    
    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      if (_isLooping) {
        play();
      }
    });
  }
  
  // 播放音频
  Future<void> play({String? asset}) async {
    try {
      if (asset != null) {
        if (_currentAsset != asset) {
          _currentAsset = asset;
          await _audioPlayer.stop();
          
          // 根据audioplayers文档，AssetSource应该不包含'assets/'前缀
          // 因为这个前缀会由AssetSource自动添加
          String assetPath = asset;
          if (assetPath.startsWith('assets/')) {
            assetPath = assetPath.substring(7); // 移除'assets/'前缀
          }
          
          print('播放音频: $assetPath');
          await _audioPlayer.setSource(AssetSource(assetPath));
          
          // 设置循环模式
          await _audioPlayer.setReleaseMode(_isLooping ? ReleaseMode.loop : ReleaseMode.release);
        }
      }
      
      if (_currentAsset != null) {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print('音频播放错误: $e');
      _isPlaying = false;
    }
  }
  
  // 暂停音频
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }
  
  // 停止音频
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }
  
  // 设置音量
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }
  
  // 设置循环
  Future<void> setLooping(bool looping) async {
    _isLooping = looping;
    
    // 如果当前正在播放，更新循环模式
    if (_isPlaying && _currentAsset != null) {
      await _audioPlayer.setReleaseMode(_isLooping ? ReleaseMode.loop : ReleaseMode.release);
    }
  }
  
  // 设置播放位置
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  
  // 获取当前位置
  Future<Duration> getCurrentPosition() async {
    return await _audioPlayer.getCurrentPosition() ?? Duration.zero;
  }
  
  // 获取总时长
  Future<Duration> getDuration() async {
    return await _audioPlayer.getDuration() ?? Duration.zero;
  }
  
  // 释放资源
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
} 
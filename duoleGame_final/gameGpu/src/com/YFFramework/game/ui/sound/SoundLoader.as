package com.YFFramework.game.ui.sound
{
	import com.YFFramework.core.debug.print;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午12:21:40
	 * 单首歌的声音基本控制
	 */
	public class SoundLoader
	{
		protected var _sound:Sound;
		protected var _soundChannel:SoundChannel;
		protected var _soundTransform:SoundTransform;
		protected var _request:URLRequest;
		/** 当加载到这个值时可以开始播放了*/		
		protected var _playPercent:int;
		/** 播放音乐的音量*/
		protected var _volume:Number;
		/**错误*/		
		public var errorCallBack:Function;
		
		public function SoundLoader()
		{
			_request=new URLRequest();
		}
		
		public function initSound():void
		{
			dispose();
			
			_sound=new Sound();
			_soundTransform=new SoundTransform();
			_soundTransform.volume=0.5;
		}
		
		/**  该函数支持多次调用;支持百分比显示;调用后将会自动卸载掉前一次的
		 */		
		public function play(url:String,playPercent:int=0):void
		{	
			initSound();
			
			_playPercent=playPercent;
			
			_request.url=url;
			_sound.load(_request);
			
			_sound.addEventListener(Event.COMPLETE,onComplete);
			if(_playPercent > 0)
				_sound.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_sound.addEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		
		protected function onComplete(e:Event):void
		{
			removeEvent();
			_soundChannel=_sound.play();
			if(_soundChannel)
			{
				_soundChannel.soundTransform=_soundTransform;
			}
//			_soundChannel.addEventListener(Event.SOUND_COMPLETE,playEnd);
		}
		
//		private function playEnd(e:Event):void
//		{
//			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,playEnd);
//			SoundBgManager.Instance.playEnd();
//		}
		
		protected function removeEvent():void
		{
			if(_sound)
			{
				_sound.removeEventListener(Event.COMPLETE,onComplete);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			}
			
			if(_playPercent > 0)
				_sound.removeEventListener(ProgressEvent.PROGRESS,onProgress);	
		}
		
		protected function onProgress(e:ProgressEvent):void
		{
			var loadedPecent:int=int(100*e.bytesLoaded/e.bytesTotal);
			if((loadedPecent>=_playPercent)&&(_soundChannel==null))
			{
				_soundChannel=_sound.play();
				//需要显示什么内容
			}
		}
		
		protected function onError(e:IOErrorEvent):void
		{
			dispose();
			print(this,"SoundLoader::音乐加载发生流错误,错误地址为::"+_request.url);
			if(errorCallBack!=null)errorCallBack();
		}
		
		public function gotoAndPlay(startTime:Number):void
		{
			if(_sound)
				_soundChannel=_sound.play(startTime);
		}
		
		/** 停止在该声道中播放声音 ,可用于暂停音乐
		 */		
		public function stop():void
		{
			if(_soundChannel) 
			{
				_soundChannel.stop();
			}
		}
		
		/** 得到当前播放歌曲的位置
		 * @return （以毫秒为单位）
		 */		
		public function get position():Number
		{
			if(_soundChannel) return _soundChannel.position;
			return 0;
		}
		
		/** 当前声音的长度
		 * @return （以毫秒为单位）
		 */		
		public function  get length():Number
		{
			if(_sound) return _sound.length;
			return 0;
		}
		
		/** 播放音乐的音量*/
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			if(_soundChannel)
			{
				_volume = value;
				_soundTransform.volume=_volume;
				_soundChannel.soundTransform=_soundTransform;
			}
		}
		
		public function dispose():void
		{
			if(_sound)
			{
				stop();
				removeEvent();
				_sound=null;
				_soundTransform=null;
				_soundChannel=null;
			}
		}
		
	}
}
package com.YFFramework.core.music
{
	import com.YFFramework.core.debug.Log;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午12:21:40
	 * 声音控制
	 */
	public class SoundLoader
	{
		protected var _sound:Sound
		protected var _channel:SoundChannel;
		protected var _transform:SoundTransform;
		protected var _request:URLRequest;
		protected var _loadedPecent:int;////已经加载了的百分比
		protected var _playPercent:int;//当加载到这个值时可以开始播放了
		protected var _volume:Number;///播放音乐的音量
		public function SoundLoader()
		{
			_request=new URLRequest();
			
		}
		protected function initSound():void
		{
			_sound=new Sound();
			_sound.addEventListener(Event.COMPLETE,onComplete);
			_sound.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_sound.addEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		protected function onComplete(e:Event):void
		{
			removeEvent();
		}
		protected function onProgress(e:ProgressEvent):void
		{
			_loadedPecent=int(100*e.bytesLoaded/e.bytesTotal);
			if((_loadedPecent>=_playPercent)&&(_channel==null))
			{
				_channel=_sound.play();
				_transform=SoundMixer.soundTransform;
				_transform.volume=_volume;
				SoundMixer.soundTransform=_transform;
			}
		}
		protected function onError(e:IOErrorEvent):void
		{
			destroy();
			trace("SoundLoader::音乐加载发生流错误,错误地址为::",_request.url);
			Log.Instance.e("SoundLoader::音乐加载发生流错误,错误地址为::"+_request.url);
		}
		
		/**  播放音乐 该函数支持多次调用   调用后将会自动卸载掉前一次的
		 */		
		public function play(urlKey:String,_playPercent:int=0,_volume:Number=1):void
		{
			if(_sound) 
			{
				pause();
				destroy();
			}
			initSound();
			var url:String=urlKey+".mp3";
			this._playPercent=_playPercent;
			this._volume=_volume;
			_request.url=url;
			_sound.load(_request);
		}
		/**暂停 
		 */		
		public function pause():Number
		{
			if(_channel) 
			{
				_channel.stop();
				return _channel.position;
			}
			else return NaN;
		}
		/**  继续播放
		 */		
		public function goOnPlay(position:Number=0):void
		{
			if(_channel) _channel.stop();
			_channel=_sound.play(position);
		}
		protected function destroy():void
		{
			removeEvent();
			_sound=null;
			_channel=null;
		}
		protected function removeEvent():void
		{
			_sound.removeEventListener(Event.COMPLETE,onComplete);
			_sound.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		public function get position():Number
		{
			if(_channel) return _channel.position;
			else return NaN;
		}
		public function  get length():Number
		{
			if(_sound) return _sound.length;
			else return NaN;
		}
	}
}
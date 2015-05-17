package com.YFFramework.core.music.manager
{
	import com.YFFramework.core.debug.print;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	

	/**@author yefeng
	 *2013-4-9下午9:55:43
	 */
	public class SoundItem
	{
		protected var _sound:Sound;
		protected var _channel:SoundChannel;
		protected var _transform:SoundTransform;
		protected var _request:URLRequest;
		protected var _loadedPecent:int;////已经加载了的百分比
		protected var _playPercent:int;//当加载到这个值时可以开始播放了
		protected var _volume:Number;///播放音乐的音量
		public function SoundItem()
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
			print(this,"SoundLoader::音乐加载发生流错误,错误地址为::",_request.url);
		}

		
		
		
	}
}
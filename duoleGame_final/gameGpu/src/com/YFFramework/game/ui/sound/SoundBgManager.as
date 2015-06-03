package com.YFFramework.game.ui.sound
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.events.Event;

	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午02:39:50
	 * 背景音乐控制类
	 */
	public final class SoundBgManager
	{
		private static var _instance:SoundBgManager;
		private var _songs:Array;
		private var _loader:SoundLoader;
		private var _currentMusicIndex:int=0;
		/** 歌曲总数*/		
		private var _songsNum:int;
		/** 上次歌曲播放到的位置 */		
		private var _lastPlayPos:Number;
		/** 调节音量 */		
		private var _volume:Number;
		
		public function SoundBgManager()
		{
			_songs=[];
			_loader=new SoundLoader();
			UpdateManager.Instance.framePer.regFunc(update);//就是EnterFrame
			_loader.errorCallBack=erroCallBack;
		}
		
		private function erroCallBack():void
		{
			playNext();
		}
		
		public static  function get Instance():SoundBgManager
		{
			if(!_instance) _instance=new SoundBgManager();
			return _instance;
		}
		/** 填充 音乐地址  然后就可以调用play函数进行播放了
		 */		
		public function  initData(songs:Array):void
		{
			_songs=songs;
			_songsNum=_songs.length;
		}
		
		protected function update():void
		{
			if((_loader.position>0)&&(_loader.length>0)&&(_loader.position+40>=_loader.length))
			{
				playEnd();
			}
		}
		
		/** 播放下一个
		 */		
		public function playNext():void
		{
			_currentMusicIndex++;
			_currentMusicIndex=_currentMusicIndex%_songsNum;
			play(_currentMusicIndex);
		}
		/**播放上一个
		 */		
		public function playPre():void
		{
			_currentMusicIndex--;
			_currentMusicIndex =(_currentMusicIndex+_songsNum)%_songsNum;
			play(_currentMusicIndex);
		}
		/**随机播放
		 */		
		private function playRandom():void
		{
			var random:int=int(_songsNum*Math.random());
			_currentMusicIndex +=(_songsNum+random)%_songsNum;
			play(_currentMusicIndex);
		}
	
		/** 选择播放歌曲
		 * @param index 歌曲的序号
		 */		
		public function play(index:int=0):void//原来默认值是-1
		{
			if(_songs.length==0) return ;
			_loader.play(_songs[index]);
//			if(index>-1)
//			{
//				var muIndex:int=index%_songs.length;
//				_loader.play(_songs[muIndex]);
//				_currentMusicIndex=muIndex;
//				_currentMusicIndex++;
//				_currentMusicIndex=_currentMusicIndex%_songs.length;
//			}
//			else 
//			{
//				_loader.play(_songs[_currentMusicIndex]);
//				_currentMusicIndex++;
//				_currentMusicIndex=_currentMusicIndex%_songs.length;
//			}
		}
		
		public function playEnd():void
		{
			_currentMusicIndex = (_currentMusicIndex<_songs.length-1)?_currentMusicIndex+1:_currentMusicIndex=0;
			play(_currentMusicIndex);
		}
		
		/** 暂停后继续播放 */		
//		public function gotoAndPlay():void
//		{
//			_loader.gotoAndPlay(_lastPlayPos);
//		}
		
		/** 暂停音乐 */		
//		public function mute():void
//		{
//			_lastPlayPos=_loader.position;
//			stop();
//		}

		/** 停止音乐 */		
//		public function stop():void
//		{
//			_loader.stop();
//		}
		
		/** 读取歌曲序列*/
		public function get currentIndex():int
		{
			return _currentMusicIndex;
		}

		/** 设置歌曲序列 */
		public function set currentIndex(value:int):void
		{
			_currentMusicIndex = value;
			_loader.dispose();
			play(_currentMusicIndex);
		}

		/** 读取调节音量 */
		public function get volume():Number
		{
			return _volume;
		}

		/** 设置调节音量 */
		public function set volume(value:Number):void
		{
			_volume = value;
			_loader.volume=_volume;
		}
 
	}
}
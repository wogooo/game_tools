package com.YFFramework.core.sound
{
	import com.YFFramework.core.center.manager.update.UpdateManager;

	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午02:39:50
	 * 背景音乐控制类
	 */
	public final class SoundBgManager
	{
		private static var _instance:SoundBgManager;
		private var arr:Array;
		private var loader:SoundLoader;
		private var currentIndex:int=0;
		private var _len:int;
		public function SoundBgManager()
		{
			arr=[];
			loader=new SoundLoader();
			UpdateManager.Instance.framePer.regFunc(update);
			loader.errorCallBack=erroCallBack;
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
		public function  initData(soundArr:Array):void
		{
				loader.pause();
				arr=soundArr;
				_len=arr.length;
		}
		
		protected function update():void
		{
			if((loader.position>0)&&(loader.length>0)&&(loader.position+40>=loader.length))
			{
				play(currentIndex);
			}
		}
		/** 播放下一个
		 */		
		public function playNext():void
		{
			currentIndex++;
			currentIndex=currentIndex%_len;
			play(currentIndex);
		}
		/**播放上一个
		 */		
		public function playPre():void
		{
			currentIndex--;
			currentIndex =(currentIndex+_len)%_len;
			play(currentIndex);
		}
		/**随机播放
		 */		
		private function playRandom():void
		{
			var random:int=int(_len*Math.random());
			currentIndex +=(_len+random)%_len;
			play(currentIndex);
		}
	
		public function play(index:int=-1,volume:Number=1):void
		{
			if(arr.length==0) return ;
			if(index>-1)
			{
				var muIndex:int=index%arr.length;
				loader.play(arr[muIndex],0,volume);
				currentIndex=muIndex;
				currentIndex++;
				currentIndex=currentIndex%arr.length;
			}
			else 
			{
				loader.play(arr[currentIndex],0,volume);
				currentIndex++;
				currentIndex=currentIndex%arr.length;
			}
		}
		public function stop():void
		{
			loader.pause();
		}
	}
}
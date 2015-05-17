package com.YFFramework.core.center.manager
{
	import com.YFFramework.core.net.loader.sound.SoundLoader;
	import com.YFFramework.core.center.manager.update.UpdateManager;

	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午02:39:50
	 * 背景音乐控制类
	 */
	public final class SoundBgManager
	{
		private static var _instance:SoundBgManager;
		private var arr:Vector.<String>=new Vector.<String>();
		private var loader:SoundLoader;
		private var currentIndex:int=0;
		public function SoundBgManager()
		{
			if(_instance) throw new Error("请使用Instance属性");
			else initSound();
		}
		
		public static  function get Instance():SoundBgManager
		{
			if(!_instance) _instance=new SoundBgManager();
			return _instance;
		}
		/** 填充 音乐地址  然后就可以调用play函数进行播放了
		 */		
		public function  initData(soundArr:Vector.<String>):void
		{
				arr=soundArr;
		}
		
		protected function update():void
		{
			if((loader.position>0)&&(loader.length>0)&&(loader.position+40>=loader.length))
			{
				play(currentIndex);
			}
		}
		
		public function play(index:int=-1,volume:Number=0.05):void
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
		protected function initSound():void
		{
			loader=new SoundLoader();
			UpdateManager.Instance.framePer.regFunc(update);
		}
		public function stop():void
		{
			loader.pause();
		}
	}
}
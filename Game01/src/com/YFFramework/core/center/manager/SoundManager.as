package com.YFFramework.core.center.manager
{
	import com.YFFramework.core.net.loader.sound.SoundLoader;

	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午12:16:27
	 * 
	 * 控制游戏技能音效播放  播放音效一般是很短暂的   ！背景音乐由另外类控制
	 */
	public final class SoundManager extends SoundLoader
	{
		private static  var _instance:SoundManager;
		public function SoundManager()
		{
			if(_instance) throw new Error("请使用Instance属性");
		}
		public static function get Instance():SoundManager
		{
			if(!_instance) _instance=new SoundManager();
			return _instance;
		}
		
	}
}
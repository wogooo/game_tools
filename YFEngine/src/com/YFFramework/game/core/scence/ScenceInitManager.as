package com.YFFramework.game.core.scence
{
	import com.YFFramework.core.center.face.IScence;
	
	import flash.display.Scene;

	/**
	 * 创建管理中心
	 * @author yefeng
	 *2012-4-21下午7:11:45
	 */
	public class ScenceInitManager
	{
		public static var GameOn:IScence;
		public static var GameOut:IScence;
		public static var GameLogin:IScence;
		public function ScenceInitManager()
		{
		}
		public static function initScence():void
		{  
			GameOn=new ScenceGameOn();
			GameOut=new ScenceGameOut();
			GameLogin=new ScenceLogin();  
		}
	} 
}
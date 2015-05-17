package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.face.IHandle;

	/** 初始化各个handler模块 
	 * 2012-8-2 上午10:25:01
	 *@author yefeng
	 */
	public class HandlerInitManager
	{
		/**登陆模块通讯处理
		 */		
		private  static var handlerLogin:IHandle;
		/** 场景模块通讯处理 
		 */
		private  static var handlerMapScence:IHandle;
		/**背包通讯模块
		 */		
		private static var handleBackpack:IHandle;
		/**  技能处理模块
		 */		
		private static var handleSkill:IHandle;
		
		/**宠物模块
		 */		
		private static var handlePet:IHandle;
		/**坐骑模块
		 */		
		private static var handleMount:IHandle;
		
		public function HandlerInitManager()
		{
		}
		
		public static function inithandler():void
		{
			handlerLogin=new HandleLogin();
			handlerMapScence=new HandleMapSence();
			handleBackpack=new HandleBackpack();
			handleSkill=new HandleSkill();
			handlePet=new HandlePet();
			handleMount=new HandleMount();
		}
			
	}
}
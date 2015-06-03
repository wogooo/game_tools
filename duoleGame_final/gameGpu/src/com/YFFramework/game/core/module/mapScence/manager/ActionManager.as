package com.YFFramework.game.core.module.mapScence.manager
{
	/**动作管理器
	 * @author yefeng
	 * 2013 2013-8-28 上午10:21:50 
	 */
	public class ActionManager
	{
		
		/**记录上一次按下的  技能id 
		 * 默认值为 -1
		 */
		public var lastSkillId:int=-1;
		
		
		
		
		
		///控制主角自己的 攻击动作播放   不断轮播 
		/**普通攻击动作
		 */
		public static const  NormalAtk:int=0;
		
		/**特殊攻击动作1  
		 */
		public static const SpecialAtk_1:int=1;
		
		/**攻击动作个数
		 */
		public static const totalAtk:int=2;
		

		/**当前的攻击动作
		 */
		private var _currentAtk:int=0;
		private static var _instance:ActionManager;
		public function ActionManager()
		{
		}
		
		public static function get Instance():ActionManager
		{
			if(!_instance) _instance=new ActionManager();
			return _instance;
		}
		
		/**获取当前的攻击动作
		 */
		public function getAtkAction():int
		{
			return _currentAtk;
		}
		/** 改变
		 */
		public function change():void
		{
			_currentAtk++;
			_currentAtk=_currentAtk%totalAtk;
		}
			
		
			

	}
}
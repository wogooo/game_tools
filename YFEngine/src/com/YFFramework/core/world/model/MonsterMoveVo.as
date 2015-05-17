package com.YFFramework.core.world.model
{
	/**2012-8-28 上午11:44:20
	 *@author yefeng
	 */
	public class MonsterMoveVo extends PlayerMoveVo
	{
		
		/**怪物的动态id 
		 */ 
		public var dyId:String;
		public function MonsterMoveVo()
		{
			super();
		}
		override public function reset():void
		{
			super.reset();
			dyId=null;
		}
	}
}
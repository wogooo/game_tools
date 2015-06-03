package com.YFFramework.game.core.module.activity.model
{
	/**活动枚举  
	 * 
	 * @author yefeng
	 * 2013 2013-9-30 下午2:14:18 
	 */
	public class TypeActivity
	{
	//	.场景类型有三个值：0->无；1->副本；2->公共场景；
		/**0
		 */
		public static const SceneType_None:int=0;
		/**副本场景
		 */
		public static const SceneType_Raid:int=1;
		/**公共场景
		 */
		public static const SceneType_World:int=2;
		public function TypeActivity()
		{
		}
	}
}
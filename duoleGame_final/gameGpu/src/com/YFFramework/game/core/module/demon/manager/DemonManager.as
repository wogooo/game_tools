package com.YFFramework.game.core.module.demon.manager
{
	/**
	 * @version 1.0.0
	 * creation time：2013-10-12 上午10:15:24
	 */
	public class DemonManager
	{
		/**特效表  大炮 的特效 映射id  该 id 映射 constmaop 表的 id 
		 */
		public static const FightEffect_DaPao_ConstId:int=950;
		/**特效表 月井的特效 映射id  该 id 映射 constmaop 表的 id 
		 */
		public static const FightEffect_YueJing_ConstId:int=951;
		/**历史最高波数
		 */		
		public static var highestLevelReached:int;
		/**女神的动态ID*/		
		public static var goddessDyId:int=0;
		/**当前波数
		 */		
		public static var current_wave:int=0;
		/**下一波数时间
		 */		
		public static var next_wave_seconds:int=0;
		
		public function DemonManager(){
		}
		
		
	}
} 
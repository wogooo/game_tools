package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.URLTool;

	/**游戏中常用  一些固定资源的地址， 比如 怪物出生特效地址     人物升级 特效地址   
	 * @author yefeng
	 *2012-10-27下午8:15:42
	 */
	public class CommonEffectURLManager
	{
		/**怪物出生特效
		 */		
		public static const MonsterBirthURL:String=URLTool.getCommonEffect_HSWF("MonsterBirth");
		/**打坐时的人物特效
		 */ 
		public static const SitEffectURL:String=URLTool.getCommonEffect_HSWF("sitEffect");
		
		/**传送点特效
		 */ 
		public static const TransferPtURL:String=URLTool.getMapBuilding("transferPt.yf2d");
		
		public static const MouseEffectURL:String=URLTool.getCommonEffect_HSWF("mouseEffect");
		
		public function CommonEffectURLManager()
		{
		}
	}
}
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
		public static const MonsterBirthURL:String=URLTool.getCommonEffect_yf2d("MonsterBirth");
		/**打坐时的人物特效
		 */ 
		public static const SitEffectURL:String=URLTool.getCommonEffect_yf2d("sitEffect");
		
		/**角色选中 特效
		 */		
		public static const SelectRole:String=URLTool.getCommonEffect_yf2d("roleSelect");
		/**  技能目标点选取特效
		 */		
		public static const SkillPointSelectView:String=URLTool.getCommonEffect_Chitu("roleSelect");

		/**玩家升级特效
		 */		
		public static const LevelUp:String=URLTool.getCommonEffect_yf2d("levelUp");
		
		/**传送点特效
		 */ 
		public static const TransferPtURL:String=URLTool.getMapBuilding("transferPt.yf2d");
		
		/**  鼠标点击地面效果
		 */
		public static const MouseEffectURL:String=URLTool.getCommonEffect_yf2d("mouseEffect");
		/**怪物死亡效果
		 */		
		public static const MonsterDeadEffect:String=URLTool.getCommonEffect_yf2d("monsterDeadEffect");
		
		/**物品掉落特效
		 */		
		public static const DropGoodsEffectNormal:String=URLTool.getCommonEffect_yf2d("dropEffeft");
		
		public function CommonEffectURLManager()
		{
		}
	}
}
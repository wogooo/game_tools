package com.YFFramework.game.core.global.event
{
	/**全局事件  各个模块交叉部分的事件  以及共有的s事件
	 * @author yefeng
	 *2012-4-27下午10:44:12
	 */
	public class GlobalEvent
	{
		private static var Path:String="com.YFFramework.game.core.global.events.";
		
		/////键盘事件
		
		/** 按下数字键1  事件
		 */ 
		public static const  KeyDownNum_1:String=Path+"KeyDownNum_1";
		/** 按下数字键2  事件
		 */ 
		public static const  KeyDownNum_2:String=Path+"KeyDownNum_2";
		/** 按下数字键3 事件
		 */ 
		public static const  KeyDownNum_3:String=Path+"KeyDownNum_3";
		/** 按下数字键4  事件
		 */ 
		public static const  KeyDownNum_4:String=Path+"KeyDownNum_4";
		/** 按下数字键5  事件
		 */ 
		public static const  KeyDownNum_5:String=Path+"KeyDownNum_5";
		/** 按下数字键6  事件
		 */ 
		public static const  KeyDownNum_6:String=Path+"KeyDownNum_6";
		/** 按下数字键7  事件
		 */ 
		public static const  KeyDownNum_7:String=Path+"KeyDownNum_7";
		/** 按下数字键8  事件
		 */ 
		public static const  KeyDownNum_8:String=Path+"KeyDownNum_8";
		/** 按下数字键9  事件
		 */ 
		public static const  KeyDownNum_9:String=Path+"KeyDownNum_9";
		/** 按下数字键0  事件
		 */ 
		public static const  KeyDownNum_0:String=Path+"KeyDownNum_0";
		/**空格键
		 */
		public static const  KeyDownSpace:String=Path+"KeyDownSpace";
		
		//---------------
		////Ui打开 
		
		/**  单击   主界面 背包  按钮 
		 */		
		public static const  BackPackUIClick:String=Path+"UIBackPackClick";
		
		
		/**好友按钮单击 弹出好友面板
		 */		
		public static const FriendUIClick:String=Path+"FriendUIClick";
		/**人物界面Ui打开
		 */		
		public static const CharacterUIClick:String=Path+"CharacterUIClick";
		/**打开技能UI面板
		 */ 
		public static const SkillUIClick:String=Path+"SkillUIClick";
		/**打开 宠物 UI面板 
		 */		
		public static const PetUIClick:String=Path+"PetUIClick";
		/**装备打造面板
		 */		
		public static const ForgeUIClick:String=Path+"ForgeUIClick";
		/**单击弹出小场景地图
		 */		
		public static const SmallMapUIClick:String="SmallMapUIClick";
		
		
		/** 主界面 下方技能 区域  鼠标弹起事件
		 */		
		public static const SkillPaneMouseUp:String=Path+"SkillPaneMouseUp";
		
		
		
		/**  游戏登陆进入后触发    进入游戏后触发各个 游戏中的模块
		 */
		public static const GameIn:String=Path+"GameIn";
		
		
		
		/** 游戏角色成功登陆
		 */
		public static const Login:String=Path+"Login";
		
		
		/**鼠标点击场景  这里的的场景不包含  UIRoot层  只是单击人物   以及 背景地图场景 时触发
		 */		
		public static const ScenceClick:String=Path+"ScenceClick";
		
		
		/**震屏
		 */
		public static const ScenceShake:String=Path+"ScenceShake";
		
		
		
		
		
		////场景模块
		/**切换场景   smallMap模块去监听该事件
		 */		
		public static const MapChange:String=Path+"MapChange";
		/**切换场景时 配置文件加载完成时触发
		 */		
		public static const MapConfigLoadComplete:String=Path+"MapConfigLoadComplete";

		
		
		///小地图场景
		/**  移动到某点
		 */		
		public static const SmallMapMoveToPt:String=Path+"SmallMapMoveToPt";
		/**小地图上点击npc向npc靠近
		 */		
		public static const SmallMapMoveToNPC:String=Path+"SmallMapMoveToNPC";
		/**小地图上点击怪物向怪物靠近准备攻击怪物
		 */
		public static const SmallMapMoveToMonster:String=Path+"SmallMapMoveToMonster";
		
		/**小地图获取移动路径
		 */		
		public static const SmallMapGetMovePath:String=Path+"SmallMapGetMovePath";
		/**瞬间跳到目标点  小地图点击飞鞋进行跳动
		 */
		public static const SKipToPoint:String=Path+"SKipToPoint";
		/**瞬间跳到玩家附近
		 */			
		public static const SKipToPlayer:String=Path+"SKipToPlayer";

		
		
		//////宠物模块
		
		/**宠物出战  宠物模块通知模块 宠物出战
		 */		
		public static const PetPlay:String=Path+"PetPlay";
		/**宠物发生移动 用于宠物更新
		 */		
		public static const PetMoving:String=Path+"HeroMoving";
		/**npc clicker事件  单击npc  走到相应的位置响应的事件
		 */		
		public static const NPCClicker:String=Path+"NPCClicker";
		
		
		
		//技能模塊
		/**按快捷鍵觸發技能
		 */		
		public static const SkillTrigger:String=Path+"SkillTrigger";
		/**技能播放CD動畫
		 */		
		public static const SKillPlayCD:String=Path+"SKillPlayCD";
		
		
		
		
		
		
		
		public function GlobalEvent()
		{
		}
	}
}
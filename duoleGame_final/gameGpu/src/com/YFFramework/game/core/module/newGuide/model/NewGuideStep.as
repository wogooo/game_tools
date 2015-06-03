package com.YFFramework.game.core.module.newGuide.model
{
	/**新手引导步骤
	 * @author yefeng
	 * 2013 2013-10-14 下午5:06:01 
	 */
	public class NewGuideStep
	{
		
		
		////背包新手礼包 引导步骤 
		
		
		/**新手礼包引导步骤
		 */
		public static var BagPackGuideStep:int=-1;
		
		
		//		/**背包功能开启
		//		 */
		//		public static var BagPackFuncOpen:int=31;
		
		/**给背包按钮画圈圈
		 */
		public static var BagPackMainUIBtn:int=12;
		
		/**引导打开背包
		 */
		public static var BagPackOpen:int=13;
		
		/**关闭背包
		 */
		public static var BagPackCloseBagWindow:int=14;
		
		/**背包新手礼包清除
		 */
		public static var BagPackNone:int=15;
		
		
		
		
		
		
		
		/**宠物引导步骤
		 */
		public static var  PetGuideStep:int=-1;
		/**孵化宠物
		 */
		public static const CreatePet:int=21;
		
		/**宠物功能按钮开启 
		 */
		public static const PetFuncOpen:int=22;

		
		/**引导宠物出战，引导主界面 宠物面板的打开
		 */
		public static const PetMainUIBtn:int=23;

		
		/**出战宠物
		 */
		public static const PetFight:int=24;
		
		/**引导宠物关闭窗口
		 */
		public static const PetCloseWindow:int=25;
		
		/**关闭宠物 
		 */
		public static const PetNone:int=26;

		
		
		//人物面板引导
		
		/**人物面板引导步骤
		 */
		public static var CharactorGuideStep:int=-1; 

		
		/** 主界面 人物面板按钮 引导触发该按钮
		 */
		public static const CharactorMainUI:int=31;
		
		
		/**人物面板 引导推荐按钮
		 */
		public static const CharactorGuideTuiJian:int=32;
		
		/**人物面板引导确定
		 */
		public static const CharactorGuideQueDing:int=33;

		
		/**人物面板  关闭按钮
		 */
		public static const CharactorCloseWindow:int=34;

		/**人物引导去掉 
		 */
		public static const CharactorNone:int=35;

		///坐骑 引导
		
		//坐骑引导
		
		/**坐骑引导步骤
		 */
		public static var MountGuideStep:int=-1;

		/**孵化坐骑
		 */
		public static const CreateMount:int=42;
		
		/**坐骑新功能开启
		 */
		public static const MountGuideFuncOpen:int=43;
		
		/**主界面 坐骑 按钮  给他画框
		 */
		public static const MountMainUIMountBtn:int=44;
		
		/** 引导 坐骑面板坐骑出战  给坐骑出战按钮画方框
		 */
		public static const MountWindowRectFightBtn:int=45;

		/**坐骑面板 关闭按钮
		 */
		public static const MountWindowRectCloseBtn:int=46;

		/**坐骑窗口 
		 */
		public static const MountWindowNone:int=40;
		
		
		
		
		
		
	

		
		
		
		
		///  装备升级步骤
		
		
		/** 装备升级引导
		 */ 
		public static var EquipLevelUpStep:int=-1;

		/**引导主界面画框 
		 */
		public static const EquipLevelUp_MainUI:int=53;
		
		/**装备升级步骤  锻造面板单击要锻造的装备
		 */
		public static const EquipLevelUp_ToClickEquip:int=54;
		
		/**单击锻造面板升级按钮
		 */
		public static const EquipLevelUp_ToClickLevelUpBtn:int=55;

		/**关闭铸造面板
		 */
		public static const EquipLevelUp_ToCloseForageWindow:int=56;


		public static const EquipLevelUp_None:int=50;
 
		
		
		
		//引导技能
		
		public static var SkillGuideStep:int=-1;
		
		/**引导给主界面技能画框
		 */
		public static const SkillMainUI:int=61;

		/**引导单击技能
		 */
//		public static const SkillGuideCickSkill:int=62;

		/**引导点击学习按钮
		 */
		public static const SkillGuideRectStudyBtn:int=63;

		/**引导关闭技能面板
		 */
		public static const SkillGuideCloseWindow:int=64;

		/**技能取消
		 */
		public static const SkillGuideNone:int=65;
		
		
		
		
		///翅膀 引导
		public static var WingGuideStep:int=-1;
		
		/**翅膀引导 获取翅膀 
		 */
		public static const WingGuideCreateWing:int=71;
		
		
		/**翅膀功能开启
		 */
		public static const WingGuideFunOpen:int=72;

		/**商城引导步骤
		 */
		public static var MallGuideStep:int=-1;
		
		/**商城 功能打开
		 */
		public static const MallGuideFuncOpen:int=81;
		
		
		//组队引导 
		
		/**组队引导步骤 
		 */
		public static var TeamGuideStep:int=-1
		
		/**开启组队
		 */
		public static const TeamGuideFuncOpen:int=91;

		//市场引导
		
		/**市场引导
		 */
		public static var MarketGuideStep:int=-1;
		
		/**开启市场 
		 */
		public static var MarketGuideFuncOpen:int=101;
		
		/**工会开启 
		 */
		public static var GuildGuideStep:int=-1;
		/**工会开启 
		 */
		public static var GuildGuideFuncOpen:int=111;
		
		public function NewGuideStep()
		{
		}
	}
}
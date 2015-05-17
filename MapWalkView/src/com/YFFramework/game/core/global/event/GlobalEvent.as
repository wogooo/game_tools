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
		/**P键
		 */
		public static const  P:String=Path+"P";
		
		/**
		 * 背包快捷键B 
		 */		
		public static const  B:String=Path+"B";
		
		/**
		 * 角色快捷键 
		 */		
		public static const C:String=Path+"C"; 
		//---------------
		////Ui打开 
		
		/**  单击   主界面 背包  按钮 
		 */		
		public static const  BagUIClick:String=Path+"BagUIClick";

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
		
		/** HorseUIClick  坐骑按钮单机
		 */		
		public static const HorseUIClick:String=Path+"HorseUIClick";
		
		/**商店UI单击
		 */ 
		public static const ShopUIClick:String=Path+"ShopUIClick";
		/**组队面板单击
		 */
		public static const TeamUIClick:String=Path+"TeamUIClick";

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
		
		/**添加buff显示buff 图标  主界面显示图标
		 */		
		public static const AddBuff:String=Path+"AddBuff";
		/**删除  buff  删除buff图标   主界面 删除图标
		 */		
		public static const DeleteBuff:String=Path+"DeleteBuff";

		
		

		
		
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
		/**宠物发生移动 用于宠物更新
		 */		
		public static const PetMoving:String=Path+"PetMoving";
		/**npc clicker事件  单击npc  走到相应的位置响应的事件
		 */		
		public static const NPCClicker:String=Path+"NPCClicker";
		/**宠物加血发送给场景宠物Icon的消息
		 */		
		public static const PetHpChg:String=Path+"PetHpChg";
		
		/**宠物场景UI
		 */	
		public static const PetChange:String=Path+"PetChange";
		/**宠物掉血通知面板
		 */	
		public static const petDropHp:String=Path+"petDropHp";
		
		/**
		 * 当用户点击卖鼠标 
		 */
		public static const USER_SELL_CLICK:String =Path+ "userSellClick";
		
		//组队模块
		/**组队邀请面板打开 
		 */
		public static const InviteUIClick:String = Path + "InviteUIClick";
		
		/**邀请面板通知场景把组队组件按钮去掉
		 */
		public static const RemoveTeamInviteBtn:String = Path + "RemoveTeamInviteBtn";
		
		/**初始化组队场景组件
		 */
		public static const InitTeamIcons:String = Path + "InitTeamIcons";
		
		/**组队场景组件 - 新成员
		 */
		public static const AddTeamIcons:String = Path + "AddTeamIcons";
		
		/**组队场景组件 - 刪除全部成員
		 */
		public static const RemoveAllTeamIcons:String = Path + "RemoveAllTeamIcons";
		
		/**组队场景组件 - 刪除一個成員
		 */
		public static const RemoveTeamIcons:String = Path + "RemoveTeamIcons";
		
		/**组队场景组件 - 换队长位置
		 */
		public static const SwitchTeamIcons:String = Path + "SwitchTeamIcons";
		
		/**组队面板通知显示“组”按钮
		 */
		public static const DisplayTeamBtn:String = Path + "DisplayTeamBtn";
		
		
		/**
		 * 用户点击商店面板的修理按钮 
		 */
		public static const USER_FIX_CLICK:String =Path+ "userFixClick";
		
		/**
		 * 用户点击商店面板的全部修理按钮 
		 */
		public static const USER_FIX_ALL_CLICK:String =Path+ "userFixAllClick";
		
		
		
		/**
		 * 当商店的回购列表需要刷新时 
		 */
		public static const BUY_BACK_UPDATE:String =Path+ "buyBackUpdate";
		
		
		
		//技能模塊
		/**按快捷鍵觸發技能
		 */		
		public static const SkillTrigger:String=Path+"SkillTrigger";
		/**技能播放CD動畫
		 */		
		public static const SKillPlayCD:String=Path+"SKillPlayCD";
		
		public static const BUY_STATE:String =Path+ "buyState";
		
		
		/**
		 * 技能树需要刷新 
		 */
		public static const SKILL_TREE_UPDATE:String = "skillTreeUpdate";

		//背包模块
		
		/**
		 *打开宠物对应面板 
		 */		
		public static const OPEN_PET_PANEL:String=Path+"OPEN_PET_PANEL";
		
		/**
		 * 背包有任何改变都要通知其他模块 
		 */		
		public static const BagChange:String=Path+"BagChange";
		/**
		 * 告诉快捷栏使用成功 
		 */		
		public static const BagDrugUseItemResp:String=Path+"BagUseItemResp";
		/**
		 * 告诉宠物面板喂养或驯养成功 
		 */		
		public static const PetUseItemResp:String=Path+"PetUstItemResp";
		///人物面板模块
		/**金币发生改变
		 */		
		public static const MoneyChange:String=Path+"MoneyChange";
		/**角色经验发生改变
		 */		
		public static const HeroExpChange:String=Path+"HeroExpChange";
		/** 角色信息改变  血量，魔法  改变 有可能是当前主角  也有可能是其他玩家  判断玩家对象 通过roleDyVo判断
		 * 战斗FigntView场景出发了该事件    人物模块 ModuleCharacter也会发生属性改变触发该事件   该事件带参数RoleDyVo
		 *  该事件通知主界面 去更新
		 */		
		public static const RoleInfoChange:String=Path+"RoleInfoChange";
		/**鼠标单机其他角色
		 */		
		public static const MouseClickOtherRole:String=Path+"MouseClickOtherRole";
		
		
		/**主角升级
		 */		
		public static const HeroLevelUp:String=Path+"HeroLevelUp";
		
		
		
		////////ModuleSceneUI   普通场景模块
		/** 弹出主角选职业的界面
		 */		
		public static const ShowSelectCareerWindow:String=Path+"ShowSelectCareerWindow";
		/**主角转职成功
		 */		
		public static const HeroChangeCareerSuccess:String=Path+"HeroChangeCareerSuccess";
		
		/**
		 * 装备强化等级更改 
		 */
		public static const EquipEnhanceLevelChange:String = "EquipEnhanceLevelChange";
		/**
		 * 镶嵌宝石更改 
		 */
		public static const EquipGemChange:String = "EquipGemChange";

		
		public function GlobalEvent()
		{
		}
	}
}
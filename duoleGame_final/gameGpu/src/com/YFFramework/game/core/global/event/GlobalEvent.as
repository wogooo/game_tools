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
		
		
		/**  Q 
		 */ 
		public static const  KeyDownQ:String=Path+"KeyDownQ";
		/**W
		 */ 
		public static const  KeyDownW:String=Path+"KeyDownW";
		/** E
		 */ 
		public static const  KeyDownE:String=Path+"KeyDownE";
		/**R
		 */ 
		public static const  KeyDownR:String=Path+"KeyDownR";
		/**T
		 */ 
		public static const  KeyDownT:String=Path+"KeyDownT";
		/** A
		 */ 
		public static const  KeyDownA:String=Path+"KeyDownA";
		/**S
		 */ 
		public static const  KeyDownS:String=Path+"KeyDownS";
		/**D
		 */ 
		public static const  KeyDownD:String=Path+"KeyDownD";
		/**F
		 */ 
		public static const  KeyDownF:String=Path+"KeyDownF";
		/**G
		 */ 
		public static const  KeyDownG:String=Path+"KeyDownG";
		
		/**空格键
		 */
		public static const  KeyDownSpace:String=Path+"KeyDownSpace";
		
		//---------------
		////Ui打开 
		
		/**  单击   主界面 背包  按钮  */		
		public static const  BagUIClick:String=Path+"BagUIClick";
		/** 背包满，带参数，true->满，false->不满 */
		public static const BagFull:String=Path+"BagFull";

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
		/**打开 坐骑 UI面板 
		 */		
		public static const MountUIClick:String=Path+"MountUIClick";
		/**商店UI单击
		 */ 
		public static const ShopUIClick:String=Path+"ShopUIClick";
		/**组队面板单击
		 */
		public static const TeamUIClick:String=Path+"TeamUIClick";
		/**任务面板单击
		 */
		public static const TaskUIClick:String=Path+"TaskUIClick";

		/**装备打造面板
		 */		
		public static const ForgeUIClick:String=Path+"ForgeUIClick";
		
		/**打开锻造面板   用于 任务面板快捷键触发  打开锻造界面进行升级
		 */
		public static const ForgeUIOpenForLevelUp:String=Path+"ForgeUIOpenForLevelUp";
		
		/** 背包打开 进行新手礼包的获取
		 */
		public static const BagPackOpenForOpenNewPack:String=Path+"BagPackOpenForOpenNewPack";
		
		/**武器强化
		 */
		public static const WeaponStrenthen:String=Path+"WeaponStrenthen";
		/**宝石镶嵌
		 */
		public static const GemInlay:String=Path+"GemInlay";
		/**  翅膀进阶
		 */
		public static const WingLevelUp:String=Path+"WingLevelUp";

		/**单击弹出小场景地图
		 */		
		public static const SmallMapUIClick:String="SmallMapUIClick";

		/** 主界面 下方技能 区域  鼠标弹起事件
		 */	
		public static const SkillPaneMouseUp:String=Path+"SkillPaneMouseUp";
		/**
		 * 商城UI单击 
		 */		
		public static const MallUIClick:String=Path+"MallUIClick";
		/**
		 *市场UI单击
		 */		
		public static const MarketUIClick:String=Path+"MarketUIClick";
		/**
		 *排行榜UI单击
		 */		
		public static const RankUIClick:String=Path+"RankUIClick";
		
		/**交易UI单击 
		 */		
		public static const TradeUIClick:String=Path+"TradeUIClick";
		/**养成任务UI单击 
		 */		
		public static const GrowTaskUIClick:String=Path+"GrowTaskUIClick";
		/**养成任务图标特效更新*/
		public static const GrowTaskEffUpdate:String=Path+"GrowTaskEffUpdate";
		
		/**挂机UI单击 
		 */		
		public static const AutoUIClick:String=Path+"AutoUIClick";
		/**翅膀UI单击 
		 */		
		public static const WingUIClick:String=Path+"WingUIClick";
		/**  切磋UI单击
		 */		
		public static const CompeteUIClick:String=Path+"CompeteUIClick";
		/**
		 *系统UI单击 
		 */		
		public static const SystemUIClick:String=Path+"SystemUIClick";
		/**活动按钮单击  */
		public static const ActivityUIClick:String=Path+"ActivityUIClick";
		/**
		 *公会按钮点击 
		 */		
		public static const GuildUIClick:String=Path+"GuildUIClick";
		/**公会邀请按钮点击*/
		public static const GuildInviteClick:String=Path+"GuildInviteClick";
		/**公会有人申请入会时特效图标刷新*/
		public static const GuildFlashIconUpdate:String=Path+"GuildFlashIconUpdate";
		/**  好友按钮 , 类似 组队按钮 切磋按钮的  玩家请求后显示的 小图标    单击派发的事件
		 */
		public static const FriendBtnUIClick:String=Path+"FriendBtnUIClick";
		/** 好友 私聊按钮图标 单击
		 */
		public static const FriendPrivateChatIconClick:String=Path+"FriendPrivateChatIconClick";

		
		/**  游戏登陆进入后触发    进入游戏后触发各个 游戏中的模块
		 */
		public static const GameIn:String=Path+"GameIn";
		
		/** 场景初始化完成
		 */
		public static const GameSceneInitOk:String=Path+"GameSceneInitOk";
		
		/**聊天服务器验证成功，可以开始聊天
		 */		
		public static const ChatCheckOK:String=Path+"ChatCheckOK";
		/**其他模块需要显示在聊天框的事件通知
		 */		
		public static const ChatDisplay:String=Path+"ChatDisplay";
		/**其他模块需要直接发送到世界频道的事件通知
		 */		
		public static const ChatAutoSend:String=Path+"ChatAutoSend";
		
		/** 游戏角色成功登陆
		 */
		public static const Login:String=Path+"Login";
		
		
		/**鼠标点击场景  这里的的场景不包含  UIRoot层  只是单击人物   以及 背景地图场景 时触发
		 */		
		public static const ScenceClick:String=Path+"ScenceClick";
		
		
		/**震屏
		 */
		public static const ScenceShake:String=Path+"ScenceShake";
		
		/**请求切换场景  用于副本模块  副本模块用来弹出窗口 提示  是否离开副本
		 */		
		public static const RequestChangeMap:String=Path+"RequestChangemap"; 		
		////场景模块
		/**切换场景     切换到不同场景调用的方法
		 */		
		public static const EnterDifferentMap:String=Path+"DifMapChange";
		/**同一场景切换   从场景的 一点 跳到另一点
		 */		
		public static const SameMapChange:String=Path+"SameMapChange";
		/**切换场景时 配置文件加载完成时触发
		 */		
		public static const MapConfigLoadComplete:String=Path+"MapConfigLoadComplete";
		
		/**添加buff显示buff 图标  主界面显示图标
		 */		
		public static const HeroAddBuff:String=Path+"HeroAddBuff";
		/**删除  buff  删除buff图标   主界面 删除图标
		 */		
		public static const HeroDeleteBuff:String=Path+"HeroDeleteBuff";
		
		/** 主角宠物添加 buff    客户端 需要 根据此消息 改变血量 和 更新 buff图标
		 */		
		public static const HeroPetAddBuff:String=Path+"HeroPetAddBuff";
		/**主角宠物删除buff   删除 buff图标
		 */		
		public static const HeroPetDeleteBuff:String=Path+"HeroPetDeleteBuff";

		/**面板通知场景把组件按钮去掉
		 */
		public static const RemoveEjectBtn:String = Path + "RemoveEjectBtn";
		/**npc离开视野
		 */		
		public static const NPCExitView:String=Path+"NPCExitView";
		
		////切磋 pK 
		////请求切磋
		
		/**去进行 切磋  
		 */	
		public static const C_RequestCompete:String=Path+"C_RequestCompete";

		/** 去 进行交易
		 */		
		public static const ToTrade:String=Path+"ToTrade";
		
		///小地图场景
		/**  移动到某点（小地图上按）  使用  SmallMapMoveToWorldPt来进行代替
		 */		
//		public static const SmallMapMoveToPt:String=Path+"SmallMapMoveToPt";
		/**  移动到某一点上（其他模块触发）
		 */	
		public static const MoveToPlayer:String=Path+"MoveToPt";
		/**小地图上点击npc向npc靠近
		 */		
		public static const SmallMapMoveToNPC:String=Path+"SmallMapMoveToNPC";

		/**小地图上点击怪物向怪物区域靠近
		 */
		public static const SmallMapMoveToMonsterZone:String=Path+"SmallMapMoveToMonsterZone";
		/** 小地图上面点击世界地图上面任何一点
		 */		
		public static const SmallMapMoveToWorldPt:String=Path+"SmallMapMoveToWorldPt";

		/**小地图获取移动路径
		 */		
		public static const SmallMapGetMovePath:String=Path+"SmallMapGetMovePath";
		/**瞬间跳到目标点  小地图点击飞鞋进行跳动    带有 FlyBootVo数据 结构
		 */
		public static const SKipToPoint:String=Path+"SKipToPoint";
		/**瞬间跳到玩家附近   只准在 同一场景跳转  带有 FlyBootVo数据 结构
		 */			
		public static const SKipToPlayer:String=Path+"SKipToPlayer";

		
		/** 用于切换商店买、卖、修理状态，1-买，2-买卖，3-修理  */
		public static const USER_SHOP_MODE:String =Path+"userShopMode";
		
		///宠物模块
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
		/**宠物升级  宠物升级 场景模块进行接受处理 播放升级动画
		 */		
		public static const PetLevelUp:String=Path+"PetLevelUp";

		///坐骑模块
		/**坐骑上马下马请求
		 */		
		public static const RideMountReq:String = Path+ "RideMountReq";
		//组队模块
		/**组队邀请面板打开 
		 */
		public static const InviteUIClick:String = Path + "InviteUIClick";
		/**打开组队申请者列表*/
		public static const JoinTeamOpen:String = Path + "JoinTeamOpen";
		
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

		/**新进入队伍的成员通知场景
		 */		
		public static const TeamAddMember:String = Path +"TeamAddMember";
		
		/**新推出的队伍成员通知场景
		 */		
		public static const TeamRemoveMember:String = Path +"TeamRemoveMember";
		
		/** 显示弹出按钮
		 */		
		public static const DisplayBtn:String = Path + "DisplayBtn";
		/** 显示 场景上 好友聊天 图标 弹出按钮  
		 */		
		public static const DisplayFriendIcon:String = Path + "DisplayFriendIcon";
		/**移除好友聊天 图标 弹出按钮  
		 */		
		public static const RemoveFriendIcon:String = Path + "RemoveFriendIcon";


		/**
		 * 用户点击商店面板的修理按钮 
		 */
//		public static const USER_FIX_CLICK:String =Path+ "userFixClick";

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
		
		/**播放自己的CD 触发技能预先播放
		 */
		public static const SKillSelfPlayCD:String=Path+"SKillSelfPlayCD";
		
		public static const BUY_STATE:String =Path+ "buyState";
		
		/*****************************背包模块******************************/		
		/**打开宠物对应面板  */		
		public static const OPEN_PET_PANEL:String=Path+"OPEN_PET_PANEL";
		/** 打开锻造对应面板 */		
		public static const OPEN_FORGE_PANEL:String=Path+'OPEN_FORGE_PANEL';
		/** 打开坐骑对应面板 */		
		public static const OPEN_MOUNT_PANEL:String=Path+'OPEN_MOUNT_PANEL';
		/** 打开大喇叭面板 */		
		public static const OPEN_SPEAKER_PANEL:String=Path+'OPEN_SPEAKER_PANEL';
		/** 使用背包物品 */		
		public static const USE_ITEM:String=Path+"USE_ITEM";
		/** 背包有任何改变都要通知其他模块  */		
		public static const BagChange:String=Path+"BagChange";
		/** 告诉快捷栏使用成功  */		
		public static const BagDrugUseItemResp:String=Path+"BagUseItemResp";
		/** 告诉宠物面板喂养或驯养成功  */		
		public static const PetUseItemResp:String=Path+"PetUstItemResp";
		/** 移动到交易面板  */		
		public static const MoveToTrade:String=Path+"MoveToTrade";
		/** 成功从交易面板移动到背包  */		
		public static const MoveToBagSuccess:String=Path+"MoveToBagSuccess";
		/** 删除角色面板上的格子 */		
		public static const DelBodyGrid:String=Path+"DelBodyGrid";
		/**移动到寄售面板  */		
		public static const MoveToConsignment:String=Path+'MoveToConsignment';
		/**清空寄售面板  */		
		public static const clearConsignPanel:String=Path+'clearConsignPanel';
		/** 装备进阶成功后背包对应装备刷新 */		
		public static const EQUIP_LEVEL_UP:String = Path + 'EQUIP_LEVEL_UP';
		
		/******************************人物面板模块********************************/
		/**金币发生改变 */		
		public static const MoneyChange:String=Path+"MoneyChange";
		/**角色经验发生改变 */		
		public static const HeroExpChange:String=Path+"HeroExpChange";
		/**人物阅历发生改变*/
		public static const SeeChange:String=Path+"SeeChange";
		/**当人物身上装备改变时，告诉装备强化面板 */		
//		public static const CharacterEquipChange:String=Path+"CharacterEquipChange";
		/** 角色信息改变  血量，魔法  改变 有可能是当前主角  也有可能是其他玩家  判断玩家对象 通过roleDyVo判断
		 * 战斗FigntView场景出发了该事件    人物模块 ModuleCharacter也会发生属性改变触发该事件   该事件带参数RoleDyVo
		 *  该事件通知主界面 去更新
		 */		
		public static const RoleInfoChange:String=Path+"RoleInfoChange";
		/**鼠标单机其他角色
		 */		
		public static const MouseClickOtherRole:String=Path+"MouseClickOtherRole";
		
		/**隐藏 选中目标的的图像信息
		 */
		public static const HideOtherRoleInfo:String=Path+"HideOtherRoleInfo";

		
		
		/**主角升级
		 */		
		public static const HeroLevelUp:String=Path+"HeroLevelUp";
		
		///称号模块
//		public static const TITLE_OPEN:String=Path+"TITLE_OPEN";//打开称号面板
//		public static const TITLE_CLOSE:String=Path+"TitleClose";//关闭称号面板
		public static const TITLE_UPDATE:String=Path+"TITLE_UPDATE";//更新人物面板的称号
		/** 隐藏称号，带参数：true隐藏，false显示 */
		public static const TITLE_HIDE:String=Path+"TITLE_HIDE";
		
		/** 查询人物详细信息
		 */	
		public static const SEARCH_CHARACTER_INFO:String=Path+'searchCharacterInfo';
		/** 查询宠物详细信息 
		 */
		public static const SEARCH_PET_INFO:String=Path+'searchPetInfo';
		
		///ModuleSceneUI   普通场景模块
		/** 弹出主角选职业的界面 调试用
		 */		
//		public static const ShowSelectCareerWindowForDebug:String=Path+"ShowSelectCareerWindow";
		/**主角转职成功
		 */		
		public static const HeroChangeCareerSuccess:String=Path+"HeroChangeCareerSuccess";
		
		/**
		 * 装备强化等级更改 
		 */
		public static const EquipEnhanceLevelChange:String =Path+ "EquipEnhanceLevelChange";
		/**
		 * 镶嵌宝石更改 
		 */
		public static const EquipGemChange:String =Path+ "EquipGemChange";
		
		///交易模块
		/**取消交易
		 */		
		public static const CancelTrade:String=Path+"CancelTrade";
		/**交易时通知背包改为交易状态 
		 */		
		public static const TradeMode:String=Path+"TradeMode";
		/**交易锁定道具；交易面板通知背包面板该物品已锁定 
		 */		
		public static const LockItem:String=Path+"LockItem";
		/**交易锁定道具解锁通知；交易面板通知背包面板锁定物品改为未锁定 
		 */		
		public static const UnlockItem:String=Path+"UnlockItem";
		
		
		/**通过  商店  id 打开商店
		 */		
		public static const OpenShopById:String=Path+"OpenShopById";
		
		
		/**
		 * 接受任务成功 （附带任务ID参数） 返回 
		 */
		public static const acceptTaskOK:String =Path+ "acceptTaskOK";
		
		/**
		 * 接受任务失败  （附带任务ID参数） 返回 
		 */
		public static const acceptTaskFaild:String =Path+ "acceptTaskFaild";

		/**
		 * 完成任务成功  （附带任务ID参数） 返回 
		 */
		public static const finishTaskOK:String =Path+ "finishTaskOK";
		
		/**
		 * 完成任务失败  （附带任务ID参数） 返回 
		 */
		public static const finishTaskFaild:String =Path+ "finishTaskFaild";
		
		/**
		 * 放弃任务成功  （附带任务ID参数） 返回 
		 */
		public static const giveUpTaskOK:String =Path+ "giveUpTaskOK";
		
		/**
		 * 放弃任务失败  （附带任务ID参数） 返回 
		 */
		public static const giveUpTaskFaild:String =Path+ "giveUpTaskFaild";
		/**
		 * 放弃任务成功  （附带任务ID参数） 返回 
		 */
		public static const dialogNPCTaskOK:String =Path+ "dialogNPCTaskOK";
		
		/**
		 * 放弃任务失败  （附带任务ID参数） 返回 
		 */
		public static const dialogNPCTaskFaild:String =Path+ "dialogNPCTaskFaild";

		/**  请求接受任务  数据为  TaskNPCHandleVo
		 */		
		public static const C_RequestAcceptTask:String=Path+"C_RequestAcceptTask";
		/**请求完成任务   TaskNPCHandleVo
		 */		
		public static const C_RequestFinishTask:String=Path+"C_RequestFinishTask";
		/** NPC对话    参数   传给任务模块 ，完成任务对话
		 */		
		public static const C_NpcDialogTask:String=Path+"C_NpcDialogTask";
		/** 向  目标点靠近打开npc面板或者攻击怪物     任务   任务   向 npc 靠近    参数 TaskMoveVo
		 */		
		public static const TaskMoveToNPC:String=Path+"TaskMoveToNPC";

		/** 获取可接任务列表
		 */		
		public static const taskGetAbleList:String = "taskGetAbleList";
		/**获取当前任务列表
		 **/		
		public static const taskGetNowList:String = "taskGetNowList";
		/**任务列表更新
		 */		
		public static const taskListUpdate:String = "taskListUpdate";
		
		
		/**开始切磋
		 */		
		public static const BeginCompeting:String=Path+"BeginCompeting";
		/**  进入副本 npc 触发 NPCItemVIew*/		
		public static const EnterRaid:String=Path+"EnterRaid";
		
		/**准备  进入副本
		 */
		public static const GotoEnterRaid:String=Path+"GotoEnterRaid";

		
		/**  进入副本 npc 不通过npc*/		
		public static const EnterRaidWONPC:String=Path+"EnterRaidWONPC";
		
		/**   关闭副本 npc 触发 NPCItemVIew
		 */		
		public static const CloseRaid:String=Path+"CloseRaid";


		/**副本离开传送点是否显示
		 */
		public static const ExitAppearable:String=Path+"ExitAppearable";
		/**副本离开,通知场景可以发送切换场景的协议给服务端
		 */
		public static const RaidLeave:String=Path+"RaidLeave";
		
		/**挂机进入副本怪物更新
		 */		
		public static const AutoMonsterUpdate:String = Path + "AutoMonsterUpdate";
		
		/////好友    模块----------------------------------------------------------------------------------
		/** 请求加好友， 点击人物图像 添加
		 */		
		public static const C_RequestAddFriend:String=Path+"C_RequestAddFriend";
		
		/**添加好友成功发送的事件
		 */		
		public static const AddFriendSuccess:String=Path+"AddFriendSuccess";

		/**请求组队  传的数据是 玩家id 
		 */		
//		public static const C_RequestAddTeamer:String=Path+"C_RequestAddTeamer";
		
		//陌生人的私聊  暂时走  密聊 频道 只处理 陌生人的私聊
		/** 私聊   带有数据PrivateTalkContentVo
		 */		
		public static const C_PrivateTalk:String=Path+"C_PrivateTalk";	
		
		/**打开私聊窗口
		 */
		public static const PrivateTalkToOpenWindow:String=Path+"PrivateTalkToOpenWindow";
		
		/*************************系统设置************************/
		/** 一个专门从系统设置来控制小地图旁是否禁音的事件
		 */		
		public static const BGMControl:String=Path+"SoundControl";
		/** 小地图旁开启关闭静音改变后，告诉系统设置是否刷新面板
		 */		
		public static const BGMMute:String=Path+"SoundMute";
		
		/**************************公会***************************/
		
		/**玩家离开公会*/
		public static const GuildExit:String=Path+"GuildExit";
		/**玩家加入公会*/
		public static const GuildEnter:String=Path+"GuildEnter";
		/**开始挂机事件：挂机面板通知场景
		 */		
		public static const StartAutoFight:String=Path+"StartAutoFight";
		/**聊天文本发送到场景
		 */		
		public static const ChatToScene:String=Path+"ChatToScene";
		
		/*************************各种活动************************/
		/** 开启活动入口(带的参数为activity_type) */		
		public static const showActivityIcon:String=Path+'StartActivity';
		/** 关闭活动入口  */	
		public static const CloseActivity:String=Path+'CloseActivity';
		/** 
		 * 1.已经报名参加某项活动(带的参数为activity_type);如果报名不成功，不会发送这个事件，而是直接提示“XX活动报名不成功”
		 * 2.每个活动接受这条消息时要检查是不是自己的活动
		 *   */		
		public static const JoinedActivity:String=Path+'JoinedActivity';
		/** 打开智者千虑活动UI */
		public static const AnswerActivityUIClick:String=Path+'AnswerActivityUIClick';
		/** 进入特殊地图，副本、竞技场等，要发送这条消息，隐藏所有活动入口 */		
		public static const EnterActivity:String=Path+'EnterActivity';
		/** 退出特殊地图，显示所有活动入口 */		
		public static const QuitActivity:String=Path+'QuitActivity';
		/** 更新活动次数，因为是要请求的，有可能会出现：要显示的位置没有立即更新次数,因为请求的信息还未到 */
		public static const ActivityTimesUpdate:String=Path+'ActivityTimesUpdate';
		/***************************兑换系统******************************/
		/**打开兑换UI*/
		public static const ExchangeUIshow:String= Path + "ExchangeUIshow";
		
		/****************************系统奖励*********************************/
		/**系统奖励按钮点击*/
		public static const SystemRewardUIClick:String = Path + "SystemRewardUIClick";
		/**系统奖励按钮显示*/
		public static const SystemRewardBtnShow:String = Path + "SystemRewardBtnShow";
		/**系统奖励按钮隐藏**/
		public static const SystemRewardBtnHide:String = Path + "SystemRewardBtnHide";
		
		/***************************礼包************************************/
		/**礼包UI点击*/
		public static const GiftUIClick:String=Path + "GiftUIClick";
		/**礼包UI特效更新*/
		public static const GiftUiUpdate:String= Path+"GiftUiUpdate";
		
		/****************************在线奖励**************************************/
		/**初始化在线奖励UI*/
		public static const OnlineRewardInit:String=Path + "OnlineRewardInit";
		
		/******************************黑市商店*********************************/
		public static const BlackShopUIClick:String=Path+'BlackShopUIClick';
		
		/******************************魔族入侵活动*********************************/
		public static const DemonUIClick:String=Path+'DemonUIClick';
		
		/******************************勇者大乱斗活动*********************************/
		public static const BraveUIClick:String=Path+'BraveUIClick';
		
		/** 服务器返回成功才会向各个地方发送这个事件，带的数据是obj的，内含arena_id和ready_time
		 */		
		public static const EnterArena:String=Path+'EnterArena';
		/** 竞技场玩家或分数发生改变 */		
		public static const UpdateArenaInfo:String=Path+'UpdateArenaInfo';
		/** 关闭竞技场，带arena_id */		
		public static const CloseArena:String=Path+'CloseArena';
		/** 退出竞技场，带竞技场id */		
		public static const QuitArena:String=Path+'QuitArena';
		
		/********************************GM工具*******************************************/
		public static const GMToolOpen:String=Path+"GMToolOpen";
		/*****************************天命神脉************************************************/
		public static const DivinePulseClick:String = Path+"DivinePulseClick";
		/****************************feed分享**************************************************/
		public static const FeedSend:String=Path+"FeedSend";
		/**黄钻礼包*/
		public static const YellowVipUIClick:String = Path+"YellowVipUIClick";
		/**黄钻特效*/
		public static const YellowVipEffUpdate:String = Path + "YellowVipEffUpdate";
		/**充值*/
		public static const Recharge:String= Path+"Recharge";
		
		
		
		
		//功能开启事件
		
		/**新功能开启 
		 */
		public static const NewFuncOpen:String=Path+"NewFuncOpen";
		
		/**主角  死亡
		 */
		public static const HeroDead:String=Path+"HeroDead";
		/**主角复活
		 */
		public static const HeroRevive:String=Path+"HeroRevive";

		public function GlobalEvent()
		{
		}
	}
}
package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.gameConfig.URLTool;

	/**游戏中常用  一些固定资源的地址， 比如 怪物出生特效地址     人物升级 特效地址   
	 * @author yefeng
	 *2012-10-27下午8:15:42
	 */
	public class CommonEffectURLManager
	{	
		
		/**自动挂机UI动画
		 */		
		public static const GuaJi:String=URLTool.getCommonAssets("guaji.swf");
		/** 自动寻路UI动画
		 */		
		public static const ZiDongXunLu:String=URLTool.getCommonAssets("zidongxunlu.swf");
		
		/**npc对话框背景
		 */		
		public static const NpcDialogUrl:String=URLTool.getCommonAssets("npcDialogBg.swf");
		
		/** 新功能开启按钮测试
		 */
		public static const NewFuncOpenFuncEffectUrl:String=URLTool.getCommonAssets("kaiqixingongneng.chitu");
		
		
		
//		/**  任务奖励线条背景
//		 */
//		public static const NpcTaskRewardBg:String=URLTool.getCommonAssets("npcTaskRewardBg.png");
		/** 欢迎新手界面
		 */
		public static const WecomeFresh:String=URLTool.getCommonAssets("wecomefresh.swf");

		/** 新手引导 的小人
		 */		
		public static const NewGuideArrowURL:String=URLTool.getCommonAssets("guideRole.chitu");//URLTool.getCommonAssets("guideArrow.swf");  guideRole.chitu
		/**    说话表情地址
		 */		
		public static const FaceURL:String=URLTool.getCommonAssets("face.swf");
		/** 喇叭 说话的光效
		 */		
		public static const SpeakerFlash:String=URLTool.getCommonAssets("speakerflash.chitu");
		
		/**翻牌特效MC 
		 */
		public static const FlopCardMovie:String=URLTool.getCommonAssets("cardMovieMC.swf");
		
		
		
		///按钮光效 
		/**  按钮光效
		 */
		public static const ButtonEffectURL:String=URLTool.getCommonAssets("buttonEffect.swf");
		
		/**主界面 图标环绕光效特效  
		 */
		public static const LightEffectURL:String=URLTool.getCommonEffect_Chitu("lightEffect");
		
		
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
//		public static const SkillPointSelectView:String=URLTool.getCommonEffect_Chitu("roleSelect");
		public static const SkillPointSelectView:String=URLTool.getCommonEffect_swf("skillPoint");
		/**人物在水上面的水波纹效果
		 */
		public static const WaterPtEffect:String=URLTool.getCommonEffect_yf2d("waterPt");

		/**玩家升级特效
		 */		
		public static const LevelUp:String=URLTool.getCommonEffect_yf2d("levelUp");
		
		/**传送点特效
		 */ 
		public static const TransferPtURL:String=URLTool.getMapBuilding("transferPt.atfMovie");
		
		/**  鼠标点击地面效果
		 */
		public static const MouseEffectURL:String=URLTool.getCommonEffect_yf2d("mouseEffect");
		/**怪物死亡效果
		 */		
		public static const MonsterDeadEffect:String=URLTool.getCommonEffect_yf2d("monsterDeadEffect");
		
		/**物品掉落特效
		 */		
		public static const DropGoodsEffectNormal:String=URLTool.getCommonEffect_yf2d("dropEffeft");
		
		/**  切磋胜利特效
		 */		
		public static const CompeteWinEffect:String=URLTool.getCommonEffect_yf2d("jigaoyichou");
		/** 切磋中的特效
		 */		
		public static const CompetingEffect:String=URLTool.getCommonEffect_yf2d("qiecuo");		
		
		/**完成任务特效
		 */		
		public static const FinishTaskEffect:String=URLTool.getCommonEffect_Chitu("task_finish");	
		/** 接收任务特效
		 */		
		public static const AcceptTaskEffect:String=URLTool.getCommonEffect_Chitu("task_accept");	
		
		/** 黄色 可接任务
		 */		
		public static const Task_Yellow_keJie:String=URLTool.getCommonEffect_yf2d("task_yellow_kejie");
		/** 黄色可完成任务
		 */				
		public static const Task_Yellow_keWanCheng:String=URLTool.getCommonEffect_yf2d("task_yellow_keWanCheng");
		/**  任务进行中
		 */
		public static const Task_JingXingZhong:String=URLTool.getCommonEffect_yf2d("task_jinxingZhong");
		
		
		//////////怪物 特效
		/**  精英怪特效  精英怪上层特效
		 */
		public static const MonsterEliteUpEffect:String=URLTool.getCommonEffect_yf2d("MonsterEliteUpEffect");
		/**精英怪下层特效
		 */		
		public static const MonsterEliteDownEffect:String=URLTool.getCommonEffect_yf2d("MonsterEliteDownEffect");

		/**  Boss怪特效  Boss怪上层特效
		 */
		public static const MonsterBossUpEffect:String=URLTool.getCommonEffect_yf2d("MonsterBossUpEffect");
		/**精英怪下层特效
		 */		
		public static const MonsterBossDownEffect:String=URLTool.getCommonEffect_yf2d("MonsterBossDownEffect");
		
		
		
		public function CommonEffectURLManager()
		{
		}
	}
}
package com.YFFramework.core.ui.layer
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.controls.YFHpTips;
	
	import flash.display.DisplayObjectContainer;

	/**@author yefeng
	 *2012-4-20下午9:48:19
	 */
	public class LayerManager
	{
		/**根容器 包含所有的容器
		 */
		public static var RootView:DisplayObjectContainer;
	//	public static var GameSceneLayer:AbsView;
		/**地图背景层
		 */
		public static var BgMapLayer:AbsView; 
		/**路点轨迹层
		 */
//		public static var DrawPathLayer:AbsView;
		/**   地图特效层  用于放建筑
		 */
		public static var BgEffectLayer:AbsView;
		
		/**  地图背景上的技能层
		 */
		public static var BgSkillLayer:SkillLayer;
		/**人物阴影层
		 */
	//	public static var MouseEffectLayer:AbsView;
		/** 角色层
		 */
		public static var PlayerLayer:AbsView;
		
		/**
		 *天空特效层   比如 天气系统
		 */
		public static var SkyEffectLayer:AbsView;
		
		/** 上层 技能特效层
		 */
		public static var SkySKillLayer:SkillLayer;
		
		/**战斗的文字说明层  比如  加伤害  加防御   减伤害  减防御  加血   减血  等等 和战斗相关的文字描述
		 */ 
		public static var FightTextLayer:AbsView;
		
		/**包含所有的ui  所有 的ui的层的根容器  用于检测该层是否透明 来判断人物是否可走 
		 */
		public static var UIViewRoot:AbsView;
		
		/**  界面UI层  比如  任务  任务小图像 等等 之类的层  左下角聊天窗口的层
		 */ 
		public static var UILayer:AbsView;
		/** 弹出面板层   人物装备层 等等  
		 */
		public static var WindowLayer:WindowsLayer;

		/**  tips层
		 */
		public static var TipsLayer:AbsView;
		/**  menuList层
		 */		
		public static var MenuListLayer:AbsView;
		
		/**
		 *不具有交互性的一层     物品拖动 也是在该层拖动
		 */
		public static var DisableLayer:AbsView;
		
		/** 人物血量少的提示层
		 */		
		public static var HpTipsLayer:YFHpTips;
		/**  游戏广播 消息层
		 */
		public static var NoticeLayer:AbsView;
		
		/** 模态 等类似的Alert窗口弹出层
		 */
		public static var PopLayer:AbsView;
		
		
		/**调试层
		 */
		public static var DebugLayer:AbsView;
		
		public function LayerManager()
		{
		}
		public static function initLayer(rootView:DisplayObjectContainer):void
		{
			RootView=rootView;
		//	GameSceneLayer=new AbsView(false);
			BgMapLayer=new AbsView(false);
//			DrawPathLayer=new AbsView();
			BgEffectLayer=new AbsView(false);//场景特效层  比如建筑
			BgSkillLayer=new SkillLayer();
	//		MouseEffectLayer=new AbsView(false);
			PlayerLayer=new AbsView(false);
			SkyEffectLayer=new AbsView(false);
			SkySKillLayer=new SkillLayer();
			FightTextLayer=new AbsView(false);
			UIViewRoot=new AbsView(false); 
			UILayer=new AbsView(false);
			WindowLayer=new WindowsLayer();
			TipsLayer=new AbsView(false);
			MenuListLayer=new AbsView(false);
			DisableLayer=new AbsView(false);
			HpTipsLayer=new YFHpTips();
			NoticeLayer=new AbsView(false);
			PopLayer=new AbsView(false);
			DebugLayer=new AbsView(false);
			
		//	rootView.addChild(GameSceneLayer);
			///场景层
			rootView.addChild(BgMapLayer);
		//	rootView.addChild(DrawPathLayer)
	//		DrawPathLayer.mouseChildren=DrawPathLayer.mouseEnabled=false

			rootView.addChild(BgEffectLayer);
			rootView.addChild(BgSkillLayer);
	//		rootView.addChild(MouseEffectLayer);
			rootView.addChild(PlayerLayer);
			
			rootView.addChild(SkyEffectLayer);
			rootView.addChild(SkySKillLayer);
			
			rootView.addChild(UIViewRoot);
			UIViewRoot.addChild(FightTextLayer);
			UIViewRoot.addChild(UILayer);
			UIViewRoot.addChild(WindowLayer);
			UIViewRoot.addChild(TipsLayer);
			UIViewRoot.addChild(MenuListLayer);
			UIViewRoot.addChild(DisableLayer);
			UIViewRoot.addChild(NoticeLayer);
			UIViewRoot.addChild(PopLayer);
			UIViewRoot.addChild(DebugLayer);
			
			BgMapLayer.mouseChildren=false;
			BgEffectLayer.mouseChildren=BgEffectLayer.mouseEnabled=false;
			BgSkillLayer.mouseChildren=BgSkillLayer.mouseEnabled=false;
			
			SkyEffectLayer.mouseChildren=SkyEffectLayer.mouseEnabled=false;
			SkySKillLayer.mouseChildren=SkySKillLayer.mouseEnabled=false;
			TipsLayer.mouseChildren=TipsLayer.mouseEnabled=false;
			DisableLayer.mouseChildren=DisableLayer.mouseEnabled=false;
			FightTextLayer.mouseChildren=FightTextLayer.mouseEnabled=false;
			Draw.DrawRect(BgMapLayer.graphics,1700,1200,0x0);

		}
		
	}
}
package com.YFFramework.game.ui.layer
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.game.debug.Debug;
	import com.YFFramework.game.ui.controls.YFHpTips;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**@author yefeng
	 *2012-4-20下午9:48:19
	 */
	public class LayerManager
	{
		/**根容器 包含所有的容器
		 */
		public static var RootView:DisplayObjectContainer;
		/**  背景根容器   包含 背景地图  背景特效 以及 人物层   天空层等
		 */		
		public  static var YF2dContainer:Abs2dView;
		/**地图背景层
		 */
		public static var BgMapLayer:Abs2dView; 
		/**路点轨迹层
		 */
//		public static var DrawPathLayer:AbsView;
		/**   地图特效层  用于放建筑
		 */
		public static var BgEffectLayer:Abs2dView;
		
		/**地面影子层
		 */		
		public static var ShadowLayer:Abs2dView;
		/**  地图背景上的技能层
		 */
		public static var BgSkillLayer:SkillLayer;
		/** 角色层
		 */
		public static var PlayerLayer:Abs2dView;
		
		/**
		 *天空特效层   比如 天气系统
		 */
//		public static var SkyEffectLayer:Abs2dView;
		
		/** 上层 技能特效层
		 */
		public static var SkySKillLayer:SkillLayer;
		
		/** flash场景层
		 */		
		public static var flashSceneLayer:AbsView;
		
		/** flash特效场景层 用于上层的地图特效
		 */
		public static var flashEffectLayer:AbsView;
		 
		/**包含所有的ui  所有 的ui的层的根容器  用于检测该层是否透明 来判断人物是否可走 
		 */
		public static var UIViewRoot:AbsView;
		
		/**  界面UI层  比如  任务  任务小图像 等等 之类的层  左下角聊天窗口的层
		 */ 
		public static var UILayer:AbsView;
		/** 弹出面板层   人物装备层 等等  
		 */
		public static var WindowLayer:AbsView;
		/**  tips层
		 */
		public static var TipsLayer:AbsView;
		/**
		 *不具有交互性的一层     物品拖动 也是在该层拖动 只处理物品拖动
		 */
		public static var DisableLayer:AbsView;
		
		/** 人物血量少的提示层
		 */
		public static var HpTipsLayer:YFHpTips;
		
		/**  剧情层
		 */		
		public static var StoryLayer:AbsView;
		
		/** 模态 等类似的Alert窗口弹出层
		 */
		public static var PopLayer:AbsView;
		
		/**新手引导挖洞层
		 */		
		public static var NewGuideLayer:AbsView;

		
		
//		public static var TopLayer:AbsView;
		
		
		
		/**  游戏广播 消息层
		 */
		public static var NoticeLayer:GameNoticeLayer;

		
		/**调试层
		 */
		public static var DebugLayer:YFDebugLayer;
		
		private static var _sceneX:int=0;
		
		private static var _sceneY:int=0;
		
		
//		private static var DrawLayer:AbsView;
		
		public function LayerManager()
		{
		}
		public static function initLayer(rootView:DisplayObjectContainer):void
		{
//			MonsterDebugger.initialize(rootView);	
			RootView=rootView;
			YF2dContainer=new Abs2dView();
//			YF2dContainer.name="BgScene";
			BgMapLayer=new Abs2dView();
//			BgMapLayer.name="BgMapLayer";
			BgEffectLayer=new Abs2dView();//场景特效层  比如建筑
//			BgEffectLayer.name="BgEffectLayer";
			ShadowLayer=new Abs2dView();
//			ShadowLayer.name="ShadowLayer";
			BgSkillLayer=new SkillLayer();
//			BgSkillLayer.name="BgSkillLayer";
			PlayerLayer=new Abs2dView();
//			PlayerLayer.name="PlayerLayer";
//			SkyEffectLayer=new Abs2dView();
//			SkyEffectLayer.name="SkyEffectLayer";
			SkySKillLayer=new SkillLayer();
//			SkySKillLayer.name="SkySKillLayer";
			flashSceneLayer=new AbsView(false);
			
			flashEffectLayer=new AbsView(false);
//			flashSceneLayer.name="flashSceneLayer";
//			FightTextLayer=new AbsView(false);
//			FightTextLayer.name="FightTextLayer";
			UIViewRoot=new AbsView(false); 
//			UIViewRoot.name="UIViewRoot";
			UILayer=new AbsView(false);
			UILayer.name="UILayer";
			WindowLayer=new AbsView(false);
			WindowLayer.name="WindowLayer";
			TipsLayer=new AbsView(false);
			TipsLayer.name="TipsLayer";
			DisableLayer=new AbsView(false);
			DisableLayer.name="DisableLayer";
			HpTipsLayer=new YFHpTips();
			HpTipsLayer.name="HpTipsLayer";
			StoryLayer=new AbsView(false);
			StoryLayer.name="StoryLayer";
//			NoticeLayer.name="NoticeLayer";
			PopLayer=new AbsView(false);
			PopLayer.name="PopLayer";
			NewGuideLayer=new AbsView(false);
			NewGuideLayer.name="NewGuideLayer";
			DebugLayer=new YFDebugLayer();
			DebugLayer.name="DebugLayer";
//			TopLayer=new AbsView(false);
			NoticeLayer=new GameNoticeLayer();
			NoticeLayer.name="NoticeLayer";
//			DrawLayer=new AbsView(false);

//			DebugLayer.name="DebugLayer";
			///场景层
			YF2d.Instance.scence.addChild(YF2dContainer);
			YF2dContainer.addChild(BgMapLayer);
			YF2dContainer.addChild(BgEffectLayer);
			YF2dContainer.addChild(ShadowLayer);
			YF2dContainer.addChild(BgSkillLayer);
			YF2dContainer.addChild(PlayerLayer);
//			YF2dContainer.addChild(SkyEffectLayer);
			YF2dContainer.addChild(SkySKillLayer);
//			rootView.addChild(NameLayer);
			rootView.addChild(flashSceneLayer);
			rootView.addChild(flashEffectLayer);
			rootView.addChild(UIViewRoot);
			
//			rootView.addChild(TopLayer);
			rootView.addChild(NoticeLayer);
			
//			UIViewRoot.addChild(FightTextLayer);
			UIViewRoot.addChild(UILayer);
			UIViewRoot.addChild(WindowLayer);
			UIViewRoot.addChild(TipsLayer);
			UIViewRoot.addChild(DisableLayer);
			UIViewRoot.addChild(StoryLayer);
//			UIViewRoot.addChild(NoticeLayer);
			UIViewRoot.addChild(PopLayer);
			
			UIViewRoot.addChild(NewGuideLayer);

			

			//UIViewRoot.addChild(DebugLayer);
			
			rootView.addChild(DebugLayer);
			

//			rootView.addChild(DrawLayer);

			ShadowLayer.mouseChildren=ShadowLayer.mouseEnabled=false;
			BgMapLayer.mouseChildren=false;
			BgEffectLayer.mouseChildren=BgEffectLayer.mouseEnabled=false;
			BgSkillLayer.mouseChildren=BgSkillLayer.mouseEnabled=false;
//			SkyEffectLayer.mouseChildren=SkyEffectLayer.mouseEnabled=false;
			SkySKillLayer.mouseChildren=SkySKillLayer.mouseEnabled=false;
//			TipsLayer.mouseChildren=TipsLayer.mouseEnabled=false;
			DisableLayer.mouseChildren=DisableLayer.mouseEnabled=false;
//			FightTextLayer.mouseChildren=FightTextLayer.mouseEnabled=false;
			flashSceneLayer.mouseChildren=flashSceneLayer.mouseEnabled=false;
//			flashSceneLayer.cacheAsBitmap=true;
			flashEffectLayer.mouseChildren=flashEffectLayer.mouseEnabled=false;
//			TopLayer.mouseChildren=TopLayer.mouseEnabled=false;
			NoticeLayer.mouseEnabled=false;
			
			DebugLayer.mouseChildren=DebugLayer.mouseEnabled=false;
			
			NewGuideLayer.mouseChildren=NewGuideLayer.mouseEnabled=false;
//			DrawLayer.mouseChildren=DrawLayer.mouseEnabled=false;
		//	StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);
		//	onResize();
			
			
//			StageProxy.Instance.stage.addEventListener(MouseEvent.CLICK,onDebug);
			
		}
		private static function onDebug(e:MouseEvent):void
		{
			Debug.log("skySkillLayer:num:",SkySKillLayer.numChildren);
			Debug.log("bgSkillLayer:num:",BgSkillLayer.numChildren);
			Debug.log("PlayerLayer:num:",PlayerLayer.numChildren);
			Debug.log("flashSceneLayer:num:",flashSceneLayer.numChildren);

		}
//		private static function onResize(e:Event=null): void
//		{
//			Draw.DrawRect(DrawLayer.graphics,StageProxy.Instance.getWidth(),StageProxy.Instance.getHeight(),0xFFFFFF,0);
//		}
		
		
//		private static const MoveLen:int=40;
//		private static const MoveLenXY:Number=40;
//		private static const WaitTime:int=30;
		/**
		 * @param direction    方向   向 哪个方向震屏
		 */		
		public static function  shake(direction:int=-1,MoveLen:int=40,WaitTime:int=30):void
		{
			var timer:TimeOut;
//			sceneMove(0,-MoveLen);
//			timer=new TimeOut(WaitTime,callIt);
//			timer.start();
			var mx:Number=0;
			var my:Number=0;
			mx=YF2dContainer.x
			my=YF2dContainer.y;
			switch(direction)
			{
//				case TypeDirection.Up:
//					sceneMove(0,-MoveLen);
//					timer=new TimeOut(WaitTime,callIt);
//					timer.start();
//					break;
//				case TypeDirection.RightUp:
//					sceneMove(MoveLenXY,-MoveLenXY);
//					timer=new TimeOut(WaitTime,callIt);
//					timer.start();
//					break;
				case TypeDirection.Right:
					
					sceneMove(MoveLen,0);
					timer=new TimeOut(WaitTime,callIt);
					timer.start();
					break;
//				case TypeDirection.RightDown:
//					sceneMove(MoveLenXY,-MoveLenXY);
//					timer=new TimeOut(WaitTime,callIt);
//					timer.start();
//					break;
//				case TypeDirection.Down:
//					sceneMove(0,MoveLen);
//					timer=new TimeOut(WaitTime,callIt);
//					timer.start();
//					break;
//				case TypeDirection.LeftDown:
//					sceneMove(-MoveLenXY,MoveLenXY);
//					timer=new TimeOut(WaitTime,callIt);
//					timer.start();
//					break;
				case TypeDirection.Left:
					sceneMove(-MoveLen,0);
					timer=new TimeOut(WaitTime,callIt);
					timer.start();
					break;
//				case TypeDirection.LeftUp:
//					sceneMove(-MoveLenXY,-MoveLenXY);
//					timer=new TimeOut(WaitTime,callIt);
//					timer.start();
//					break;
				default:
					sceneMove(0,MoveLen);
					timer=new TimeOut(WaitTime,callIt);
					timer.start();
					break;
			}
		}
		private static function callIt(obj:Object):void
		{
//			sceneMove(0,0);
			sceneMove(_sceneX,_sceneY);
		}
		
		/**场景 进行震屏 移动
		 */		
		public static function sceneMove(x:Number,y:Number):void
		{
//			YF2dContainer.x=x;
//			YF2dContainer.y=y;
			YF2dContainer.setXY(x,y);
			flashSceneLayer.x=x;
			flashSceneLayer.y=y;
			flashEffectLayer.x=x;
			flashEffectLayer.y=y;
		}
		public static function sceneMoveX(x:Number):void
		{
			_sceneX=x;
			sceneMove(_sceneX,_sceneY);
		}
		public static function sceneMoveY(y:Number):void
		{
			_sceneY=y;
			sceneMove(_sceneX,_sceneY);
		}


		
		/**获取其在  windowLayer下的坐标
		 */		
		public static function getWindowLayePos(view:DisplayObject):Point
		{
			var mX:Number=0; 
			var mY:Number=0;
			var curentObj:DisplayObject=view;
			while(curentObj!=LayerManager.WindowLayer)
			{
				mX +=curentObj.x;
				mY +=curentObj.y;
				curentObj=curentObj.parent;
			}
			return new Point(mX,mY);
		}
		
		
		/**获取其在  UILayer下的坐标
		 */		
		public static function getUILayePos(view:DisplayObject):Point
		{
			var mX:Number=0;
			var mY:Number=0;
			var curentObj:DisplayObject=view;
			while(curentObj!=LayerManager.UILayer)
			{
				mX +=curentObj.x;
				mY +=curentObj.y;
				curentObj=curentObj.parent;
			}
			return new Point(mX,mY);
		}


	}
}
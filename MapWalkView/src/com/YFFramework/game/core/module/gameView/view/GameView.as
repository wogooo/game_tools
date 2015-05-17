package com.YFFramework.game.core.module.gameView.view
{
	/**@author yefeng
	 *2012-4-20下午10:08:10
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.debug.Stats;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.movie.player.HeroPositionProxy;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import yf2d.core.YF2d;
	
	public class GameView
	{
		
		public var gameViewHandle:GameViewHandle;
		
		//左上角 人物图像ui
		private var pepleUI:MovieClip;
		
		private var smallPicUI:MovieClip;
		private var  bottomUI:MovieClip;
		/**小地圖容器
		 */ 
		public static var smallMap:MovieClip;
		
		/**主面板技能UI
		 */ 
		public static var SkillPaneUI:MovieClip;
		public function GameView()
		{
			initLoadingUI();
			initGameUI();
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
		}
		private  function initViewMain():void
		{
			locateUI();
			addEvents();
			
		}
		/**定位ui
		 */		
		protected function locateUI():void
		{
			
			LayerManager.UILayer.addChild(pepleUI);
			LayerManager.UILayer.addChild(smallPicUI);
			LayerManager.UILayer.addChild(bottomUI);
			/// 技能框显示与隐藏
//			bottomUI.UI_shortCut.__shortCutNumber2.visible=false
//			bottomUI.UI_shortCut.__shortCut2.visible=false;
			
			bottomUI.UI_shortCut.skillbar3.visible=false
			bottomUI.UI_shortCut.quickKeyTxt.visible=false;
			bottomUI.UI_shortCut.skillbar2.visible=false;

			///技能区域面板
			///技能的 数字 1 2 3 4 6  设置不响应鼠标
			bottomUI.UI_shortCut.quickKeyTxt.mouseChildren=bottomUI.UI_shortCut.quickKeyTxt.mouseEnabled=false;
			ResizeManager.Instance.regFunc(resize);
			resize();
//			SWFProfiler.init(StageProxy.Instance.stage,LayerManager.RootView);
			LayerManager.PopLayer.addChild(Stats.Instance);
			Stats.Instance.y=400
			var label:YFLabel=new YFLabel();
			label.text=YF2d.Instance.getDriverInfo();
			label.width=200;
			LayerManager.DebugLayer.addChild(label);
			label.x=5;
			label.y=250
			
				
		}
		
		/**创建游戏主界面
		 */
		private function initGameUI():void
		{
			var mainUI:MovieClip=ClassInstance.getInstance("mainUI") as MovieClip;
			pepleUI=mainUI.UI_people;
			smallPicUI=mainUI.UI_smallPic;
			bottomUI=mainUI.UI_buttom;
			smallMap=smallPicUI.smallMap;
			SkillPaneUI=bottomUI.UI_shortCut;
			
			gameViewHandle=new GameViewHandle(mainUI);
			
		}
		
		
		
		
		/**初始化外部加载进来的 ui  swf 
		 */		
		private function initLoadingUI():void
		{
			CommonFla.initUI();
		}
		
		
		
		/**定位各个ui
		 */
		private function  resize():void
		{
			bottomUI.x=StageProxy.Instance.stage.stageWidth-bottomUI.width;
			bottomUI.y=StageProxy.Instance.stage.stageHeight-174;
			pepleUI.x=0;
			pepleUI.y=0;
			smallPicUI.x=StageProxy.Instance.stage.stageWidth-250;
			smallPicUI.y=0;
		}
		
		protected function addEvents():void
		{
			
			
//			pepleUI.__AddMoneyBt.addEventListener(MouseEvent.CLICK,onClick);
			bottomUI.extend_btn.addEventListener(MouseEvent.CLICK,onClick);///关闭和伸展隐藏的技能格子

			///场景单击 ， 统一的场景单击事件派发
			LayerManager.RootView.addEventListener(MouseEvent.MOUSE_DOWN,onRootClick);
			///// ui 面包点击打开-------------------------------------------------------------------------------UI---------------
			//背包
			bottomUI.bts.__btn_2_bag.addEventListener(MouseEvent.CLICK,onClick);
			///好友面板 
			bottomUI.bts.__btn_11_friend.addEventListener(MouseEvent.CLICK,onClick);
			///宠物面板
			bottomUI.bts.btPet.addEventListener(MouseEvent.CLICK,onClick);
			///技能面板 
			bottomUI.bts.__btn_3_skill.addEventListener(MouseEvent.CLICK,onClick);
			///人物面板 
			bottomUI.bts.__btn_1_figure.addEventListener(MouseEvent.CLICK,onClick);
			///装备打造面板
			bottomUI.bts.__btn_goodsBuild.addEventListener(MouseEvent.CLICK,onClick);	
			///组队单击
			bottomUI.bts.btTeam.addEventListener(MouseEvent.CLICK,onClick);	
			///右上角圆形区域  弹出小地图窗口
			smallPicUI.__btn_13_bigMap.addEventListener(MouseEvent.CLICK,onClick);
			///收起小地图 和 放下小地图切换
			smallPicUI.bt11.addEventListener(MouseEvent.CLICK,onClick);
			
			////技能图标面板
			bottomUI.UI_shortCut.addEventListener(MouseEvent.MOUSE_UP,onSkillPaneMouseUP);
			
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveForSmallMap,onHeroMove);
		}
		private function onHeroMove(e:YFEvent):void
		{
			smallPicUI.pos.text=HeroPositionProxy.mapX+"/"+HeroPositionProxy.mapY;
		}
		
		/**进入游戏主场景
		 */		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			initViewMain();
			ShareObjectManager.Instance.flushSize();
		}
		protected function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
//				case pepleUI.__AddMoneyBt:
//					///充值 按钮
//					YFEventCenter.Instance.dispatchEventWith(ChatEvent.Charge); ////------------------------------发送事件
//					break;
				case bottomUI.extend_btn://关闭和开启隐藏的技能格子按钮 
//					bottomUI.UI_shortCut.__shortCutNumber2.visible=bottomUI.UI_shortCut.__shortCut2.visible=!bottomUI.UI_shortCut.__shortCutNumber2.visible
					bottomUI.UI_shortCut.skillbar3.visible=bottomUI.UI_shortCut.quickKeyTxt.visible=bottomUI.UI_shortCut.skillbar2.visible=!bottomUI.UI_shortCut.skillbar2.visible;
//					bottomUI.UI_shortCut.quickKeyTxt.visible=false;
//					bottomUI.UI_shortCut.skillbar2.visible=false;
					break;
				case bottomUI.bts.__btn_2_bag://背包 按钮
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagUIClick);
					break;
				case bottomUI.bts.__btn_11_friend: ///好友面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FriendUIClick);
					break;
				case bottomUI.bts.____horseItemIcon:   ///坐骑面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HorseUIClick);
					break;
				case bottomUI.bts.__btn_3_skill:///技能面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillUIClick);
					break;
				case bottomUI.bts.__btn_1_figure: ///人物面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CharacterUIClick);
					break;
				case bottomUI.bts.__btn_goodsBuild: /// 装备打造面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ForgeUIClick);
					break;
				case bottomUI.bts.btPet:///宠物面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetUIClick);
					break;
				case bottomUI.bts.btTeam: //组队单击
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamUIClick);
					break;
				case smallPicUI.__btn_13_bigMap: //弹出小地图
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapUIClick);
					break;
				case smallPicUI.bt11: //收起小地图 和 放下小地图切换
					
					break;
			}		
		}
		
		private function onSkillPaneMouseUP(e:MouseEvent):void
		{
			var display:DisplayObject=e.currentTarget as DisplayObject;
			var x:Number=display.mouseX;
			var y:Number=display.mouseY;
			
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillPaneMouseUp,{x:x,y:y,container:display});
		}
		
		
		private function onRootClick(e:MouseEvent):void
		{
			//判断ui层是否透明  透明则人物能进行行走检测 
			var myTaret:DisplayObject=e.target as DisplayObject;
			var isNotAlpha:Boolean=false;//
			if(LayerManager.UIViewRoot.contains(myTaret))
				isNotAlpha=BitmapDataUtil.getInsect(LayerManager.UIViewRoot,LayerManager.UIViewRoot.mouseX,LayerManager.UIViewRoot.mouseY);
			if(!isNotAlpha)  ///当uiView层该点 无对象时
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ScenceClick,myTaret);
			}
		}
	}
}
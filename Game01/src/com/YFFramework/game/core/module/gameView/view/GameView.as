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
	import com.YFFramework.core.ui.layer.PopUpManager;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.chat.events.ChatEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class GameView
	{
		
		
		//左上角 人物图像ui
		private var pepleUI:MovieClip;
		
		private var smallPicUI:MovieClip;
		private var  bottomUI:MovieClip;
		/**小地圖容器
		 */ 
		public static var smallMap:MovieClip;
		public function GameView(root:DisplayObjectContainer)
		{
			LayerManager.initLayer(root);
			PopUpManager.initPopUpManager();
			initLoadingUI();
			initGameUI();
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
		}
		private  function initViewMain():void
		{
			var keyboardInit:KeyboardInit=new KeyboardInit();
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
			bottomUI.UI_shortCut.__shortCutNumber2.visible=false
			bottomUI.UI_shortCut.__shortCut2.visible=false;
			///技能区域面板
			///技能的 数字 1 2 3 4 6  设置不响应鼠标
			bottomUI.UI_shortCut.__shortCutNumber.mouseChildren=bottomUI.UI_shortCut.__shortCutNumber.mouseEnabled=false;
			
			ResizeManager.Instance.regFunc(resize);
			resize();
			LayerManager.PopLayer.addChild(Stats.Instance);
			Stats.Instance.y=200
//			SWFProfiler.init(StageProxy.Instance.stage,LayerManager.RootView);
//			var label:YFLabel=new YFLabel("5K前后端全部出售，包含所有数据以及游戏制作工具(地编动编)，所有游戏版权均为个人所有！购买联系q:623307507");
//			label.width=1000;
//			label.exactWidth();
//			LayerManager.DebugLayer.addChild(label);
//			label.x=5;
//			label.y=100;
				
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
			bottomUI.y=StageProxy.Instance.stage.stageHeight-88;
			pepleUI.x=0;
			pepleUI.y=0;
			smallPicUI.x=StageProxy.Instance.stage.stageWidth-172;
			smallPicUI.y=0;
		}
		
		
		
		protected function addEvents():void
		{
			
			
			pepleUI.__AddMoneyBt.addEventListener(MouseEvent.CLICK,onClick);
			bottomUI.UI_shortCut.__btnOther.addEventListener(MouseEvent.CLICK,onClick);///关闭和伸展隐藏的技能格子

			///场景单击 ， 统一的场景单击事件派发
			LayerManager.RootView.addEventListener(MouseEvent.MOUSE_DOWN,onRootClick);
			///// ui 面包点击打开-------------------------------------------------------------------------------UI---------------
			//背包
			bottomUI.__btn_2_bag.addEventListener(MouseEvent.CLICK,onClick);
			///好友面板 
			bottomUI.__btn_11_friend.addEventListener(MouseEvent.CLICK,onClick);
			///宠物面板
			bottomUI.____horseItemIcon.addEventListener(MouseEvent.CLICK,onClick);
			///技能面板 
			bottomUI.__btn_3_skill.addEventListener(MouseEvent.CLICK,onClick);
			///人物面板 
			bottomUI.__btn_1_figure.addEventListener(MouseEvent.CLICK,onClick);
			///装备打造面板
			bottomUI.__btn_goodsBuild.addEventListener(MouseEvent.CLICK,onClick);	
			
			///右上角圆形区域
			smallPicUI.__btn_13_bigMap.addEventListener(MouseEvent.CLICK,onClick);

			////技能图标面板
			bottomUI.UI_shortCut.__shortCut.addEventListener(MouseEvent.MOUSE_UP,onSkillPaneMouseUP);
			
			
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
				case pepleUI.__AddMoneyBt:
					///充值 按钮
					YFEventCenter.Instance.dispatchEventWith(ChatEvent.Charge); ////------------------------------发送事件
					break;
				case bottomUI.UI_shortCut.__btnOther://关闭和开启隐藏的技能格子按钮 
					bottomUI.UI_shortCut.__shortCutNumber2.visible=bottomUI.UI_shortCut.__shortCut2.visible=!bottomUI.UI_shortCut.__shortCutNumber2.visible
					break;
				case bottomUI.__btn_2_bag://背包 按钮
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BackPackUIClick);
					break;
				case bottomUI.__btn_11_friend: ///好友面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FriendUIClick);
					break;
				case bottomUI.____horseItemIcon: ///宠物面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetUIClick);
					break;
				case bottomUI.__btn_3_skill:///技能面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillUIClick);
					break;
				case bottomUI.__btn_1_figure: ///人物面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CharacterUIClick);
					break;
				case bottomUI.__btn_goodsBuild: /// 装备打造面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ForgeUIClick);
					break;
				case smallPicUI.__btn_13_bigMap: //弹出小地图
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapUIClick);
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
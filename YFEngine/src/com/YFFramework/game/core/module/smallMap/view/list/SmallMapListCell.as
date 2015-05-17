package com.YFFramework.game.core.module.smallMap.view.list
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.YFSmallMapIcon;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFSimpleButton;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**2012-11-14 下午4:49:10
	 *@author yefeng
	 */
	public class SmallMapListCell extends AbsUIView
	{
		/**带的数据对象 有可能是Point类型 也有可能是 字符串String类型指的是 npc id
		 */		
		public var data:Object;
		
		/**背景地图
		 */		
		private var _bgButton:YFButton;
		/**是否处于选中状态
		 */		
		private var _select:Boolean;
		/**  消费写
		 */		
		private var _flyBootIcon:YFSmallMapIcon;
		public function SmallMapListCell()
		{
			super(false);
			height=20;
			width=135;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_bgButton=new YFButton("测试",5,-1,"left");
			addChild(_bgButton);
			///创建小飞鞋
			_flyBootIcon=new YFSmallMapIcon(6);
			addChild(_flyBootIcon);
			_flyBootIcon.buttonMode=true;
			_select=false;
			locateFlyBootIcon();
		}
		
		private function locateFlyBootIcon():void
		{
			_flyBootIcon.x=_bgButton.width-_flyBootIcon.width*0.5;
			_flyBootIcon.y=_bgButton.height*0.5;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_flyBootIcon.addEventListener(MouseEvent.CLICK,onMouseEvent);
		}

		override protected function removeEvents():void
		{
			super.removeEvents();
			_flyBootIcon.removeEventListener(MouseEvent.CLICK,onMouseEvent);
		}
		private function onMouseEvent(e:Event):void
		{
			if(data is Point) ///坐标点
			{
				noticeSkipToPoint(Point(data));
			}
			else ///字符串  npc {dyId:}  
			{
				noticeSkipToPlayer(String(data.dyId));
			}
		}
		/**瞬间跳到 pt 同场景的跳转
		 */		
		private function noticeSkipToPoint(pt:Point):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPoint,pt);
		}
		/**瞬间跳到 玩家附近
		 */		
		private function noticeSkipToPlayer(dyId:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,dyId);
		}
		
				
		
		public function set text(value:String):void
		{
			_bgButton.text=value;
			_flyBootIcon.toolTip=Lang.SmallMap_ChuanSongZhi+_bgButton.text;
		}
		
		public function get text():String
		{
			return _bgButton.text;
		}
		public function set select(value:Boolean):void
		{
			_select=value;
			_bgButton.select=_select;
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		
		override public function set  width(value:Number):void
		{
			_bgButton.width=value;
			locateFlyBootIcon();
		}
		
		override public function set  height(value:Number):void
		{
			_bgButton.height=value;
			locateFlyBootIcon();
		}

		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			data=null;
			_bgButton=null;
			_select=false;
			_flyBootIcon=null;
		}
		
	}
}
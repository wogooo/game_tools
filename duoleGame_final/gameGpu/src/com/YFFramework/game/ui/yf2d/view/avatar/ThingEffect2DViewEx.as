package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.yf2d.display.sprite2D.YF2dText;
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.view.player.CameraProxy;

	/** 场景传送点特效
	 * 2012-11-21 上午10:59:42
	 *@author yefeng
	 */
	public class ThingEffect2DViewEx extends Abs2dView
	{
		protected var _label:YF2dText;
		protected var _movie:ATFMovieClip;
		protected var _mapX:Number;
		
		protected var _mapY:Number;
		
		protected var mapX_int:int;
		protected var mapY_int:int;
		
		/**改变左边后的回调 
		 */		
		public var callBack:Function;
		
		public function ThingEffect2DViewEx()
		{
			super();
			mouseChildren=mouseEnabled=false;
		}
		public function initData(actionData:ATFActionData):void
		{
			_movie.initActionDataStandWalk(actionData);
		}
		public function get actionData():ATFActionData
		{
			return _movie.actionDataStandWalk;
		}
		
		public function start():void
		{
			_movie.start();
		}
		
		public function stop():void
		{
			_movie.stop();
		}
		public function playDefault():void
		{
			_movie.playDefault();
		}
		override protected function initUI():void
		{
			super.initUI();
			_movie=new ATFMovieClip();
			addChild(_movie);
			_label=new YF2dText();
			addChild(_label);
		}
		
		/**调整坐标 相对主角
		 */		
		override protected function addEvents():void
		{
			super.addEvents();
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMove,updatePostion);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			YFEventCenter.Instance.removeEventListener(MapScenceEvent.HeroMove,updatePostion);	
		}
		
		protected function updatePostion(e:YFEvent=null):void
		{
			mapX_int=int(_mapX);
			mapY_int=int(_mapY);
//			x =CameraProxy.Instance.x+mapX_int-CameraProxy.Instance.mapX;
//			y=CameraProxy.Instance.y+mapY_int-CameraProxy.Instance.mapY;
			setXY(CameraProxy.Instance.x+mapX_int-CameraProxy.Instance.mapX,CameraProxy.Instance.y+mapY_int-CameraProxy.Instance.mapY);
			callBack(this);
		}
		
		public function setMapXY(mapX:int,mapY:int):void
		{
			_mapX=mapX;
			_mapY=mapY;
			updatePostion();
		}

		
		public function set text(value:String):void
		{
			_label.setText(value);
//			_label.x=-_label.getTextWidth()*0.5;
//			_label.y=-_label.getTextHeight()*0.5;
			_label.setXY(-_label.getTextWidth()*0.5,-_label.getTextHeight()*0.5-130);
		}
		
		public function get text():String
		{
			return _label.getText();
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			stop();
			super.dispose(childrenDispose);
			removeEvents();  
			_label=null;
			_movie=null;
		}

		
		/** 释放到对象池
		 */		
//		public function disposeToPool():void 
//		{
//			removeEvents();
//			stop();
//			initData(null);
//			_movie.resetData();
//			callBack=null;
//		}
//		/**对象池中获取数据重新初始化
//		 */		
//		public function initFromPool():void
//		{
//			addEvents();
//		}


	}
}
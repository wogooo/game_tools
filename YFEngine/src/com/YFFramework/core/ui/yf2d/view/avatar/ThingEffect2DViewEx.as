package com.YFFramework.core.ui.yf2d.view.avatar
{
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dViewPool;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	
	import yf2d.display.sprite2D.YF2dText;

	/**2012-11-21 上午10:59:42
	 *@author yefeng
	 */
	public class ThingEffect2DViewEx extends Abs2dViewPool
	{
		protected var _label:YF2dText;
		protected var _movie:YF2dMovieClip;
		
		
		protected var _mapX:Number;
		
		protected var _mapY:Number;
		
		protected var mapX_int:int;
		protected var mapY_int:int;
		public function ThingEffect2DViewEx()
		{
			super();
			mouseChildren=mouseEnabled=false;
		}
		/**注册对象池 
		 *  子类根据需要重写该类 
		 */		
		override protected function setPoolNum():void
		{
			regPool(2);
		}
		
		public function initData(actionData:YF2dActionData):void
		{
			_movie.initData(actionData);
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
			_movie=new YF2dMovieClip();
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
			x =HeroProxy.x+mapX_int-HeroProxy.mapX;
			y=HeroProxy.y+mapY_int-HeroProxy.mapY;
		}
		
		public function setMapXY(mapX:int,mapY:int):void
		{
			_mapX=mapX;
			_mapY=mapY;
			updatePostion();
		}

		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_label=null;
			_movie=null;
		}
		public function set text(value:String):void
		{
			_label.setText(value);
			_label.x=-_label.getTextWidth()*0.5;
			_label.y=-_label.getTextHeight()*0.5;
		}
		
		public function get text():String
		{
			return _label.getText();
		}
		
		
		override public function reset():void
		{
			removeEvents();
			stop();
		}
		
		
		/**子类重写   创建对象
		 * 池对象的 构造函数
		 ** @param obj
		 */		
		override public function constructor(obj:Object):IPool
		{
			_isPool=false;
			addEvents();
			start();
			return this;
		}

	}
}
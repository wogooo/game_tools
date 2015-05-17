package com.YFFramework.core.world.movie.thing
{
	import com.YFFramework.core.center.pool.AbsUIPool;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	
	import flash.events.Event;
	
	/**2012-11-14 下午1:09:35
	 *@author yefeng
	 */
	public class ThingEffectViewEx extends AbsUIPool
	{
		
		protected var _label:YFLabel;
		protected var _bitmapMovieClip:BitmapMovieClip;
		
		protected var _mapX:Number;
		
		protected var _mapY:Number;
		
		protected var mapX_int:int;
		protected var mapY_int:int;
		public function ThingEffectViewEx()
		{
			super();
			mouseChildren=mouseEnabled=false;
		}
		public function initData(actionData:ActionData):void
		{
			_bitmapMovieClip.initData(actionData);
		}
		
		public function start():void
		{
			_bitmapMovieClip.start();
		}
		
		public function stop():void
		{
			_bitmapMovieClip.stop();
		}
		public function playDefault():void
		{
			_bitmapMovieClip.playDefault();
		}
		override protected function initUI():void
		{
			super.initUI();
			_bitmapMovieClip=new BitmapMovieClip();
			addChild(_bitmapMovieClip);
			_label=new YFLabel();
			addChild(_label);
		}
		
		override public function reset():void
		{
			stop();
			removeEvents();
			_label.text="";
		}
		override public function constructor(obj:Object):IPool
		{
			addEvents();
			return super.constructor(obj);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_label=null;
			_bitmapMovieClip=null;
		}
		public function set text(value:String):void
		{
			_label.text=value;	
			_label.width=200;
			_label.exactWidth();
			_label.x=-_label.width*0.5;
			_label.y=-_label.height
		}
		
		public function get text():String
		{
			return _label.text;
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

		
	}
}
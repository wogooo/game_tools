package com.YFFramework.game.ui.yf2d.view.avatar
{
	/**@author yefeng
	 * 2013 2013-11-29 下午5:02:43 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.EffectMovieVo;
	import com.YFFramework.game.core.module.mapScence.world.view.player.CameraProxy;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MovieClipBuilding extends MovieClipPlayer
	{
		private static var _pool:Vector.<MovieClipBuilding>=new Vector.<MovieClipBuilding>();
		private static const MaxSize:int=10;
		private static var _currentSize:int=0; 

		
		
		public var updateFunc:Function;
		
		/**移动变量  rodyVo 的 mapX  Y 为整形 也是 游戏需要的数值
		 */ 
		public var _mapX:Number;
		public var _mapY:Number;

		public var dataInit:Boolean;
		public var buldingUrl:String;
		public function MovieClipBuilding(mc:MovieClip, frameRate:int)
		{
			super(mc, frameRate);
		}
		
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

		
		
		
		/**对象池获取
		 */
		public static function getMovieClipBuilding(mc:MovieClip,frameRate:int):MovieClipBuilding
		{
			if(_currentSize>0)
			{
				var building:MovieClipBuilding=_pool.pop();
				building.addEvents();
				return building;
			}
			else return new MovieClipBuilding(mc,frameRate);
		}
		
		/**丢尽对象池
		 */
		public static function toMovieClipPlayerPool(movieClipPlayer:MovieClipBuilding):void
		{
			if(_currentSize<MaxSize)
			{
				movieClipPlayer.dispose();
				_pool.push(movieClipPlayer);
			}
			else 
			{
				movieClipPlayer.dispose();
			}
		}
		public function setMapXY(mapX:int,mapY:int):void
		{
			_mapX=int(mapX);
			_mapY=int(mapY);
			updatePostion();
		}
		
		protected function updatePostion(e:YFEvent=null):void
		{
			x =CameraProxy.Instance.x+_mapX-CameraProxy.Instance.mapX;
			y=CameraProxy.Instance.y+_mapY-CameraProxy.Instance.mapY;
//			setXY(CameraProxy.Instance.x+roleDyVo.mapX-CameraProxy.Instance.mapX,CameraProxy.Instance.y+roleDyVo.mapY-CameraProxy.Instance.mapY);
			if(updateFunc!=null)updateFunc(this);
		} 
		
		override public function dispose(e:Event=null):void
		{
			if(!_isDispose)
			{
				super.dispose(e);
				updateFunc=null;
				dataInit=false;
			}
		}
	}
}
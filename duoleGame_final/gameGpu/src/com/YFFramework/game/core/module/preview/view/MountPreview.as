package com.YFFramework.game.core.module.preview.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.view.player.MountPlayer;
	import com.YFFramework.game.core.module.preview.event.PreviewEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/***
	 *坐骑预览
	 *@author ludingchang 时间：2014-1-11 下午3:54:24
	 */
	public class MountPreview extends PreviewBase
	{
		private static var _inst:MountPreview;
		
		public static function get Instence():MountPreview
		{//单例
			return _inst||=new MountPreview;
		}
		
		private var _player:MountPlayer;
		public function MountPreview(backgroundBgId:int=0)
		{
			super(backgroundBgId);
			_player=new MountPlayer;
			ui.addChild(_player);
			_player.mouseEnabled=false;
			_player.mouseChildren=false;
			_player.x=175;
			_player.y=200;
		}
		protected override function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _left:
					_player.turnRight();
					break;
				case _right:
					_player.turnLeft();
					break;
			}
		}
		
		/**
		 *预览坐骑 
		 * @param mountId 要预览的坐骑的坐骑ID
		 * 
		 */		
		public function previewMount(mountId:int,p:Point=null):void
		{
			_player.updateMount(mountId);
			_player.playDefault();
			_player.start();
			open();
			if(p)
			{
				this.x=p.x;
				this.y=p.y;
			}
		}
		
		public override function close(event:Event=null):void
		{
			_player.stop();
			super.close();
			YFEventCenter.Instance.dispatchEventWith(PreviewEvent.CloseMount);
		}
	}
}
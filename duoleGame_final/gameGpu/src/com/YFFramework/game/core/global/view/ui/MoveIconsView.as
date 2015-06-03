package com.YFFramework.game.core.global.view.ui
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.gameView.view.GameViewPositonProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.IconImage;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	/***
	 *一组图标控制类
	 *@author ludingchang 时间：2013-11-22 下午5:05:34
	 */
	public class MoveIconsView extends AbsView
	{
		private var _icons:Array;
		public function MoveIconsView()
		{
			super(true);
			_icons=new Array;
		}
		public function add(url:String):void
		{
			var icon:IconImage=new IconImage;
			icon.url=url;
			addChild(icon);
			_icons.push(icon);
		}
		/**
		 *移动到背包 
		 * @param start:起点
		 * 
		 */		
		public function moveToBag(start:Point):void
		{
			LayerManager.DisableLayer.addChild(this);
			var i:int,len:int=_icons.length;
			var bagX:int=GameViewPositonProxy.BagX;
			var bagY:int=GameViewPositonProxy.BagY;
			for(i=0;i<len;i++)
			{
				var icon:IconImage=_icons[i];
				icon.x=start.x;
				icon.y=start.y;
				TweenLite.to(icon,1.5,{delay:i*0.3,x:bagX,y:bagY,onComplete:comp,onCompleteParams:[icon]});
			}
		}
		
		private function comp(icon:IconImage):void
		{
			TweenLite.killTweensOf(icon);
			this.removeChild(icon);
			_icons.shift();
			if(_icons.length==0)
				this.parent.removeChild(this);
		}
	}
}
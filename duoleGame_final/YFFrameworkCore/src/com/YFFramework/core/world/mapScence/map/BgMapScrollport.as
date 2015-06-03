package com.YFFramework.core.world.mapScence.map
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.geom.Rectangle;

	/** 在这个范围内   背景地图 并不进行滚屏   抖屏优化处理
	 * 
	 * @author yefeng
	 *2012-5-2下午9:46:11
	 */
	public class BgMapScrollport
	{
		/**  人物在此区域内部进行滚屏     背景地图不进行移动
		 */		
		public static var scrollPort:Rectangle;
		private static const HalfWidth:int=40;
		private static const HalfHeight:int=30;
	//	private static var _instance:BgMapScrollport;
		/**角色高度
		 */
		public static const HeroHeight:int=120; 
		/**角色宽度
		 */
		public static const HeroWidth:int=25;
		public function BgMapScrollport()
		{
			initPort();
		}
//		public static function get Instance():BgMapScrollport
//		{
//			if(!_instance) _instance=new BgMapScrollport();
//			return _instance;
//		}
		public static  function initPort():void
		{
			ResizeManager.Instance.regFunc(updateScrollPort);
			updateScrollPort();
		}
		private static function updateScrollPort():void
		{
			var tx:int=StageProxy.Instance.stage.stageWidth*0.5-HalfWidth;
			var ty:int=(StageProxy.Instance.stage.stageHeight+HeroHeight)*0.5-HalfHeight
			scrollPort=new Rectangle(tx,ty,HalfWidth*2,HalfHeight*2);
		}
	}
}
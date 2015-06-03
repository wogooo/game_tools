package com.YFFramework.game.core.global.util
{
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	/** UI 坐标计算工具类
	 * @author yefeng
	 * 2013 2013-10-14 下午4:30:03 
	 */
	public class UIPositionUtil
	{
		public function UIPositionUtil()
		{
		}
		
		/** 获取obj的时世界坐标
		 * @param obj
		 */
		public static  function getRootPosition(obj:DisplayObject):Point
		{
			var current:DisplayObject=obj;
			var pt:Point=new Point();
			while(current)
			{
				pt.x +=current.x;
				pt.y +=current.y;
				current=current.parent;
			}
			return pt;
		}
		
		/**获取 对象   obj 在 root 的位置
		 * @param obj
		 * @param root
		 */
		public static  function getPosition(obj:DisplayObject,root:DisplayObjectContainer):Point
		{
			var current:DisplayObject=obj;
			var pt:Point=new Point();
			while(current!=root&&current!=null)
			{
				pt.x +=current.x;
				pt.y +=current.y;
				current=current.parent;
			}
			return pt;
		}
		public static  function getUIRootPosition(obj:DisplayObject):Point
		{
			return getPosition(obj,LayerManager.UIViewRoot);
		}

		
		
		

	}
}
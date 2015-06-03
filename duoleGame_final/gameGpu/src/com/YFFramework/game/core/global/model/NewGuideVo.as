package com.YFFramework.game.core.global.model
{
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**新手引导数据模型
	 * @author yefeng
	 * 2013 2013-6-29 下午3:50:48 
	 */
	public class NewGuideVo
	{
		public var type:int; //引导类型
		/**区域
		 */		
		public var rect:Rectangle;
		/**容器  要引导的 对象的容器， 作用是   程序将引导动画添加进该容器中去
		 */		
		public var container:AbsView;
		public function NewGuideVo()
		{
		}
	}
}
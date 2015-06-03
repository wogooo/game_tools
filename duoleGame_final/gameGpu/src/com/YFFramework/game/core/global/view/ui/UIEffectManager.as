package com.YFFramework.game.core.global.view.ui
{
	import flash.display.Sprite;

	/**给 UI添加光效
	 * @author yefeng
	 * 2013 2013-11-7 下午5:14:35 
	 */
	public class UIEffectManager
	{
		private static var _instance:UIEffectManager;
		public function UIEffectManager()
		{
		}
		public static function get Instance():UIEffectManager
		{
			if(!_instance)_instance=new UIEffectManager();
			return _instance;
		}
		/**给图标添加光效 
		 * 将光效添加到 container容器中  光效坐标是   (x,y)
		 * showHeight showHeight光效显示宽高 如果 为小于0 的数 则采用光效默认的大小 否则进行缩放至showWidth  showHeight
		 */
		public function addIconLightTo(container:Sprite,x:Number=0,y:Number=0,showWidth:Number=-1,showHeight:Number=-1):IconEffectView
		{
			var sp:IconEffectView=new IconEffectView();
			sp.showWidth=showWidth;
			sp.showHeight=showHeight;
			sp.x=x;
			sp.y=y;
			container.addChild(sp);
//			if(showWidth>0)
//			{
//				sp.scaleX=showWidth/IconEffectView.Width;
//			}
//			if(showHeight>0)
//			{
//				sp.scaleY=showHeight/IconEffectView.Height;
//			}
			return sp;
		}
	}
}
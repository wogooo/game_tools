package com.YFFramework.game.ui.layer
{
	/**@author yefeng
	 * 2013 2013-7-8 下午5:58:11 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.text.TextField;
	
	public class YFDebugLayer extends AbsView
	{
		private var _tf:TextField
		public function YFDebugLayer()
		{
			super(false);
			_tf=new TextField();
			_tf.autoSize="left";
			_tf.x=300
			_tf.y=50
			_tf.textColor=0xFFFFFF;
			addChild(_tf);
		}
		
		/**显示文字
		 */		
		public function print(txt:String):void
		{
			_tf.text=txt;
		}
	}
}
package com.YFFramework.core.ui.layer
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**  管理窗口弹出
	 * @author yefeng
	 *2012-4-20下午9:49:04
	 */
	public class PopUpManager
	{
		/**模态的 宽高
		 */		
		private static const ModalWidth:int=2000;
		private static const ModalHeight:int=1500;
		private static var dict:Dictionary;
		public function PopUpManager() 
		{
		}
		
		public static function initPopUpManager():void
		{
			dict=new Dictionary();
		}
		
		/** 设置为模态窗口 则给 modalColor传上颜色值即可， 不设置为模态窗口 则将模态值设为负数即可
		 */
		public static function addPopUp(display:AbsUIView,parent:Sprite=null,x:Number=0,y:Number=0,modalColor:int=-1):void 
		{
			if(!parent) parent=LayerManager.PopLayer;
			addObj(display,parent,modalColor);
			display.x=x;
			display.y=y;
		}
		public static function centerPopUp(display:AbsUIView):void
		{
			display.x = (StageProxy.Instance.stage.stageWidth - display.visualWidth) * 0.5;
			display.y = (StageProxy.Instance.stage.stageHeight-display.visualHeight) * 0.5;
		}
		
		public static function removePopUp(obj:AbsUIView):void
		{
			var sp:Sprite=dict[obj];
			sp.parent.removeChild(sp);
			sp.removeChild(obj);
			sp.graphics.clear();
			sp=null;
			delete dict[obj];
		}
		private static function addObj(obj:AbsUIView,parent:Sprite,modalColor:int):void
		{
			var sp:Sprite=new Sprite();
			if(modalColor>0)
				Draw.DrawRect(sp.graphics, ModalWidth, ModalHeight,modalColor,0.3,-200,-200);
			sp.addChild(obj);
			parent.addChild(sp);
			dict[obj]=sp;
		}
	}
}
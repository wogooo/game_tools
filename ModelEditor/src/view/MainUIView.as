package view
{
	/**@author yefeng
	 *2013-3-28下午10:47:03
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	
	import fl.controls.Button;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class MainUIView extends AbsView
	{
		/**  Y轴旋转改变
		 */		
		public static const RotationYChange:String="RotationYChange";
		public static const XChange:String="XChange";
		public static const YChange:String="YChange";
		public static const ScaleChange:String="ScaleChange";

		
		private var _mc:mainUI;
		public function MainUIView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_mc=new mainUI();
			addChild(_mc);
			_mc.boneShowMC.textField.background=true;
			_mc.boneShowMC.textField.backgroundColor=0x33FFFFFF;
		}
		override protected function addEvents():void
		{
			super.addEvents();
			_mc.rotationYMC.addEventListener(Event.CHANGE,onTextChange);
			_mc.XMC.addEventListener(Event.CHANGE,onTextChange);
			_mc.YMC.addEventListener(Event.CHANGE,onTextChange);
			_mc.scaleMC.addEventListener(Event.CHANGE,onTextChange);

			
		}
		/**   绕Y轴旋转
		 */		
		private function onTextChange(e:Event):void
		{
			switch(e.currentTarget)
			{
				case _mc.rotationYMC:
					YFEventCenter.Instance.dispatchEventWith(RotationYChange,_mc.rotationYMC.value)
					break;
				case _mc.XMC:
					YFEventCenter.Instance.dispatchEventWith(XChange,_mc.XMC.value)
					break;
				case _mc.YMC:
					YFEventCenter.Instance.dispatchEventWith(YChange,_mc.YMC.value)
					break;
				case _mc.scaleMC:
					YFEventCenter.Instance.dispatchEventWith(ScaleChange,_mc.scaleMC.value)
					break;
			}
		}
		/**充值Y轴旋转
		 */		
		public function resetRotationY():void
		{
			_mc.rotationYMC.value=0;
		}
			
		
		
		/**是否在模型按钮内
		 */		
		public function isInModel():Boolean
		{
			return isInMC(_mc.modelBtn);
		}
		public function get modelBtn():Button
		{
			return _mc.modelBtn;
		}

		public function isInMaterial():Boolean
		{
			return isInMC(_mc.materialBtn);
		}
		public function get materialBtn():Button
		{
			return _mc.materialBtn;
		}
		/**是否在参照模型内
		 */ 
		public function isInRefModel():Boolean
		{
			return isInMC(_mc.refModelBtn);
		}
		
		public function get refModelBtn():Button
		{
			return _mc.refModelBtn;
		}

			
		private function isInMC(mc:DisplayObject):Boolean
		{
			print(this,"mc.mouseX,mc.mouseY：",mc.mouseX,mc.mouseY);
			if(mc.getBounds(mc).contains(mc.mouseX,mc.mouseY))
			{
				return true;
			}
			return false;
		}
		
		
		
		
		
		
	}
}
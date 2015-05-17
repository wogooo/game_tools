package com.YFFramework.core.ui.yfComponent
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.ui.yfComponent.controls.YFTooltips;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * author :夜枫 * 时间 ：Sep 17, 2011 4:00:08 PM
	 */
	public class YFComponent extends AbsUIView
	{
		private var _toolTip:String="";
		protected var _stage:Stage;
		protected var _skinId:int;
		protected var _style:YFStyle;
		public function YFComponent(autoRemove:Boolean=false)
		{
			_stage=StageProxy.Instance.stage;
			super(autoRemove);
		}
		override protected function initUI():void
		{
			// TODO Auto Generated method stub
			super.initUI();
		}

		
		override protected function addEvents():void
		{
			super.addEvents();
		}
		

		override protected function removeEvents():void
		{
			// TODO Auto Generated method stub
			super.removeEvents();
		}
		
		override public function dispose(e:Event=null):void
		{
			// TODO Auto Generated method stub
			super.dispose(e);
			if(_toolTip!=""&&_toolTip!=null)YFTooltips.Instance.removeTips(this);
		}

		/** toolTips信息
		 */
		public function get toolTip():String
		{
			return _toolTip;
		}

		/**
		 * @private
		 */
		public function set toolTip(value:String):void
		{
			_toolTip = value;
			if(_toolTip)
			{
				_toolTip=StringUtil.trim(_toolTip);
				if(_toolTip!="")YFTooltips.Instance.setTips(this);
			}
		}

		
	}
}
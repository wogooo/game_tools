package com.YFFramework.game.core.global.view.progressbar
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-7-30 上午9:49:12
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class LogoView extends AbsView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _ui:Sprite;
		
		private var _percent:TextField;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function LogoView()
		{
			_ui=ClassInstance.getInstance("common_gameLogo");
			addChild(_ui);
			
			_percent=Xdis.getChild(_ui,"percent");
			_percent.text='0';
		}
		
		
		public function hideText():void
		{
			_percent.visible=false;
		}
			
		
		//======================================================================
		//        public function
		//======================================================================
		public function updatePercent(per:int):void
		{
			_percent.text=per.toString();
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_ui=null;
			_percent=null;
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 
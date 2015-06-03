package com.YFFramework.game.core.module.notMetion.view
{
	/**
	 * 本次登录不再提示
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-5 下午1:38:47
	 */
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class NotMetionWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _txt:TextField;
		private var _notMetion:CheckBox;
		private var _okBtn:Button;
		private var _cancelBtn:Button;
		
		private var _okFunc:Function;
		
		private static var _instance:NotMetionWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function NotMetionWindow()
		{
			var mc:MovieClip=initByArgument(313,220,"notMetionWindow",WindowTittleName.titleMetion) as MovieClip;
			setContentXY(30,40);
			closeButton.visible=false;		
			
			AutoBuild.replaceAll(mc);
			_txt=Xdis.getChild(mc,"txt");
			_notMetion=Xdis.getChild(mc,"notMetion_checkBox");
			_notMetion.textField.width=105;
			_okBtn=Xdis.getChild(mc,"ok_button");
			_cancelBtn=Xdis.getChild(mc,"cancel_button");

		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function get instance():NotMetionWindow
		{
			if(_instance == null) _instance=new NotMetionWindow();
			return _instance;
		}
		/**
		 * 
		 * @param title
		 * @param txt 正文字符串
		 * @param okFunc 这个回调函数仅是确定按钮的回调函数！
		 * @return 
		 * 
		 */		
		public static function show(txt:String='',okFunc:Function=null):void
		{
			NotMetionWindow.instance.initWin(txt,okFunc);
			NotMetionWindow.instance.open();
		}
		
		public function initWin(txt:String,okFunc:Function):void
		{
			_notMetion.selected=false;
			_txt.text=txt;
			_okFunc=okFunc;
			_okBtn.addEventListener(MouseEvent.CLICK,onOkClick);
			_cancelBtn.addEventListener(MouseEvent.CLICK,onCancelClick);
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		override public function dispose():void
		{
			UIManager.removeWindow(this);
			UI.removeAllChilds(this);
			_okBtn.removeEventListener(MouseEvent.CLICK,onOkClick);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,onCancelClick);
			_txt=null;
			_cancelBtn=null;
			_okBtn=null;
			_notMetion=null;
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			if(_notMetion.selected == true)//选中就是以后不打开提示面板 
				_okFunc(false);
			else
				_okFunc(true);
			close();
		}
		
		private function onCancelClick(e:MouseEvent):void
		{
			close();
		}




		//======================================================================
		//        getter&setter
		//======================================================================


	}
} 
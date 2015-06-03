package com.YFFramework.game.core.module.bag.source
{
	/**
	 * @version 1.0.0
	 * creation time：2012-12-11 下午04:49:30
	 * 
	 */
	
	
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class JInputWindow extends PopMiniWindow{
		
		private var _mc:MovieClip;
		private var okBtn:Button;
		private var cancelBtn:Button;
		private var _max:int;
		private var _min:int;
		private var _ok:Function;
//		private var _error:Boolean;
		
		private static var _instance:JInputWindow;
		
		public function JInputWindow()
		{		
			_mc=ClassInstance.getInstance("bagUI_inputPanel") as MovieClip;
			content=_mc;
			
			setSize(311,175);
			setContentXY((this.width-content.width)/2,(this.height-content.height)/2);
			
			AutoBuild.replaceAll(_mc);
			okBtn=Xdis.getChild(_mc,"ok_button");
			cancelBtn=Xdis.getChild(_mc,"cancel_button");
			
			okBtn.addEventListener(MouseEvent.CLICK,onOK);
			cancelBtn.addEventListener(MouseEvent.CLICK,onReturn);

			addChild(_mc);
		}
		
		public static function Instance():JInputWindow
		{		
			
			if(_instance == null)
				_instance=new JInputWindow();
			return _instance;
		}
		
		/**
		 * 
		 * @param title 这个在新皮肤下没用了
		 * @param txt
		 * @param ok
		 * @param input
		 * @param maxChar
		 * 
		 */		
		public function initPanel(title:String,txt:String,ok:Function=null,input:String='1', maxChar:int=5):void
		{
			//this.title="";
			_mc.txt.text="";
			_mc.input.text="";
			
			_ok=ok;
			
			//this.title=title;
			_mc.txt.text=txt;
			
			_mc.input.text=input;
			_mc.input.maxChars=maxChar; 
			(_mc.input as TextField).setSelection(0,input.length);//默认选中默认值
			
			UI.stage.focus = _mc.input;
			_mc.input.restrict = null;
			
			this.open();

		}

		/**
		 * 返回当前输入文本框的内容字符串 
		 * @return 
		 * 
		 */		
		public function getInputText():String
		{
			return _mc.input.text;
		}
		
		/**
		 * 取得文本框的引用 
		 * @return 
		 * 
		 */		
		public function getInputTextField():TextField
		{
			return _mc.input;
		}
		
		/**
		 * 限制文本框输入的规则 
		 * @param regEx
		 * 
		 */		
		public function setRestrict(regEx:String):void
		{
			_mc.input.restrict = regEx;
		}
		
		/**设置tittle
		 */		
		override protected  function resetTitleBgLinkage():void
		{
			_titleBgLink=null;
		}
		
		/*******************************  private  *********************************/
		private function onOK(e:MouseEvent):void
		{
			_ok();
		}
		
		private function onReturn(e:MouseEvent):void
		{
			this.close();		
		}
	}
} 
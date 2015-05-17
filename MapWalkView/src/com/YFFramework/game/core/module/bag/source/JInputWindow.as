package com.YFFramework.game.core.module.bag.source
{
	/**
	 * @version 1.0.0
	 * creation time：2012-12-11 下午04:49:30
	 * 
	 */
	
	
	import com.YFFramework.core.ui.layer.PopUpManager;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class JInputWindow extends Window{
		
		private var _mc:MovieClip;
		private var okBtn:Button;
		private var cancelBtn:Button;
		private var _max:int;
		private var _min:int;
		private var _ok:Function;
		private var _error:Boolean;
		
		private static var _instance:JInputWindow;
		
		public function JInputWindow()
		{	
			_mc=ClassInstance.getInstance("bagUI_inputPanel") as MovieClip;
			content=_mc;
			
			setSize(311,175);
			content.x=(this.width-content.width)/2;
			content.y=(this.height-content.height)/2+20;
			
			AutoBuild.replaceAll(_mc);
			okBtn=Xdis.getChild(_mc,"ok_button");
			cancelBtn=Xdis.getChild(_mc,"cancel_button");

			addChild(_mc);
		}
		
		public static function Instance():JInputWindow
		{		
			
			if(_instance == null)
				_instance=new JInputWindow();
			return _instance;
		}
		public function initPanel(title:String,txt:String,ok:Function=null,input:String='1', maxChar:int=10):void
		{
			
			this.title="";
			_mc.txt.text="";
			_mc.input.text="";
			
			_max=-1;
			_min=-1;
			_error=false;
			
			_ok=ok;
			okBtn.addEventListener(MouseEvent.CLICK,onOK);
			cancelBtn.addEventListener(MouseEvent.CLICK,onReturn);
			
			this.title=title;
			_mc.txt.text=txt;
			_mc.input.text=input;
			_mc.input.maxChars=maxChar;
			
			PopUpManager.addPopUp(this);
			PopUpManager.centerPopUp(this);
		}

		public function getInputText():String
		{
			return _mc.input.text;
		}
		
		public function setRestrict(regEx:String):void{
			_mc.input.restrict = regEx;
		}
		
		public function setMaxMin(max:int=-1,min:int=-1):void{
			_max = max;
			_min = min;
			_mc.input.addEventListener(FocusEvent.FOCUS_OUT,checkNum);
		}
		
		private function checkNum(e:FocusEvent):void{
			if(_max!=-1){
				if(int(_mc.input.text)>_max){
					_mc.input.text = _max;
					_error=true;
				}
			}else if(_min!=-1){
				if(int(_mc.input.text)<_min){
					_mc.input.text = _min;
					_error=true;
				}
			}
		}
		
		override public function dispose():void
		{
			okBtn.removeEventListener(MouseEvent.CLICK,_ok);
			cancelBtn.removeEventListener(MouseEvent.CLICK,onReturn);
			_mc.input.removeEventListener(FocusEvent.FOCUS_OUT,checkNum);
		}
		
		private function onOK(e:MouseEvent):void{
			if(!_error)
				_ok();
			else
				_error=false;
		}
		
		private function onReturn(e:MouseEvent):void
		{
			this.close();		
		}
		
	}
} 
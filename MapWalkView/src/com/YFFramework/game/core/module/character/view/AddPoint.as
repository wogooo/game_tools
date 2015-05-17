package com.YFFramework.game.core.module.character.view
{
	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-11-27 下午01:40:26
	 * 
	 */
	
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.MouseDownKeepCall;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;


	public class AddPoint extends EventDispatcher
	{
		//======================================================================
		//        property
		//======================================================================
		private var _mc:MovieClip;
		private var _holder:CharacterWindow;
		private var _add:int = 0;
		private var _label:String;
		
		private var _curPoint:int;
		
		private var add_button:SimpleButton;
		private var sub_button:SimpleButton;
		private var top_button:SimpleButton;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function AddPoint(mc:MovieClip,holder:CharacterWindow,label:String)
		{
			super();
			_mc = mc;
			_label = label;
			_holder = holder;
			
			add_button = _mc.btAdd;
			sub_button = _mc.btSub;
			top_button = _mc.btTop;
			
			_curPoint=0;
			
			new MouseDownKeepCall(add_button,changePoint);
			new MouseDownKeepCall(sub_button,onSub);
			top_button.addEventListener(MouseEvent.CLICK,onTop);
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function get curPoint():int
		{
			return _curPoint;
		}
		
		/**
		 * 更新体质力量等标签 
		 * @param value
		 * 
		 */		
		public function setLabelNum(value:int):void
		{
			_mc.num.text = _label+value;
			
		}
		
		public function changePoint(point:int=1):void{
			if(_holder.getPotential()>0)
			{
				_curPoint += point;
				if(point == 0)
					clearNumTxt();
				else
					updateNumTxt(_curPoint);
				_holder.changePotential(-point);
			}
		}
		
		public function clearContent():void{
			_curPoint = 0;
			clearNumTxt();
		}
		//======================================================================
		//        private function
		//======================================================================	
		private function onSub():void{
			if(_curPoint>0){
				_curPoint--;
				if(_curPoint==0)
					clearNumTxt();
				else
					updateNumTxt(_curPoint);
				_holder.changePotential(1);
			}
		}
		
		private function onTop(e:MouseEvent):void{
			_curPoint += _holder.getPotential();
			if(_curPoint==0)
				clearNumTxt();
			else
				updateNumTxt(_curPoint);
			_holder.changePotential(-_holder.getPotential());
		}
		
		private function updateNumTxt(num:int):void
		{
			_mc.numAdd.text = "+"+num.toString();
		}
		
		private function clearNumTxt():void
		{
			_mc.numAdd.text = "";
		}
		//======================================================================
		//        event handler
		//======================================================================

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 
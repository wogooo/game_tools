package com.YFFramework.game.core.module.character.view.simpleView
{
	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-11-27 下午01:40:26
	 * 
	 */
	
	import com.YFFramework.game.core.module.character.view.CharacterPanel;
	import com.dolo.ui.tools.MouseDownKeepCall;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;


	public class AddPoint extends EventDispatcher
	{
		//======================================================================
		//        property
		//======================================================================
		private var _mc:MovieClip;
		private var _holder:CharacterPanel;
		private var _add:int = 0;
		private var _label:String;
		
		private var _curPoint:int;
		
		private var _addButton:SimpleButton;
		private var _subButton:SimpleButton;
		private var _topButton:SimpleButton;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function AddPoint(mc:MovieClip,holder:CharacterPanel,label:String)
		{
			super();
			_mc = mc;
			_label = label;
			_holder = holder;
			
			_addButton = _mc.btAdd;
			_subButton = _mc.btSub;
			_topButton = _mc.btTop;
			
			TextField(_mc.num).cacheAsBitmap=true;
			TextField(_mc.numAdd).cacheAsBitmap=true;
			
			_curPoint=0;
			
			new MouseDownKeepCall(_addButton,changePoint);
			new MouseDownKeepCall(_subButton,onSub);
			_topButton.addEventListener(MouseEvent.CLICK,onTop);
			
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
		
		public function visibleBtn(canSee:Boolean=true):void
		{
			_addButton.visible=canSee;
			_subButton.visible=canSee;
			_topButton.visible=canSee;
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
package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.game.core.module.pet.view.PetInfoPanel;
	import com.dolo.ui.tools.MouseDownKeepCall;
	import com.dolo.ui.managers.UI;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-23 上午10:55:14
	 * 
	 */
	public class AddGrid{
		
		private var _mc:MovieClip;
		private var _point:int;
		private var _infoPanel:PetInfoPanel;
		private var add_button:SimpleButton;
		private var sub_button:SimpleButton;
		private var top_button:SimpleButton;
		
		public function AddGrid(mc:MovieClip,holder:PetInfoPanel){
			_mc = mc;
			_infoPanel = holder;
			_point = 0;
			
			add_button = _mc.btAdd;
			sub_button = _mc.btSub;
			top_button = _mc.btTop;
			
			new MouseDownKeepCall(add_button,onAdd);
			new MouseDownKeepCall(sub_button,onSub);
			top_button.addEventListener(MouseEvent.CLICK,onTop);
		}
		
		public function getPoints():int{
			return _point;
		}
		
		public function disableBtns():void{
			UI.setEnable(add_button,false);
			UI.setEnable(sub_button,false);
			UI.setEnable(top_button,false);
		}
		
		public function enableBtns():void{
			UI.setEnable(add_button,true);
			UI.setEnable(sub_button,true);
			UI.setEnable(top_button,true);
		}
		
		public function clearContent():void{
			_point = 0;
			_mc.numAdd.text = "";
		}
		
		public function onAdd(addPoint:int=1):void{
			if(_infoPanel.getPotential()>0){
				_point+=addPoint;
				_mc.numAdd.text = "+"+_point;
				_infoPanel.addPotential(-addPoint);
				_infoPanel.updatePotential();
			}
		}
		
		private function onSub():void{
			if(_point>0){
				_point--;
				if(_point==0)
					_mc.numAdd.text = "";
				else
					_mc.numAdd.text = _point;
				_infoPanel.addPotential(1);
				_infoPanel.updatePotential();
			}
		}
		
		private function onTop(e:MouseEvent):void{
			_point += _infoPanel.getPotential();
			if(_point==0)
				_mc.numAdd.text = "";
			else
				_mc.numAdd.text = _point;
			_infoPanel.addPotential(-_infoPanel.getPotential());
			_infoPanel.updatePotential();
		}
		
	}
} 
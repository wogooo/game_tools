package com.YFFramework.game.core.module.autoSetting.view
{
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-19 上午10:52:44
	 */
	public class MonsterRender extends ListRenderBase{
		
		private var _checkBox:CheckBox;
		
		
		public function MonsterRender(){
			_renderHeight = 30;
		}
		
		override protected function resetLinkage():void{
			_linkage = "MonsterRender";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			_checkBox = Xdis.getChild(_ui,"c_checkBox");
		}
		
		/**更新render 
		 * @param item
		 */		
		override protected function updateView(item:Object):void{
			_checkBox.textField.width=200;
			_checkBox.textField.text = item.name;
			_checkBox.textField.width = _checkBox.textField.textWidth+50;
			if(item.isSelect)	_checkBox.selected = true;
			else	_checkBox.selected = false;
		}
		
		public function setCheckBox(value:Boolean):void{
			_checkBox.selected = value;
		}
		
		public function getCheckBox():CheckBox{
			return _checkBox;
		}
				
		/**清除对象 
		 */
		override public function dispose():void{
			super.dispose();
			_checkBox.dispose();
			_checkBox = null;
		}
	}
} 
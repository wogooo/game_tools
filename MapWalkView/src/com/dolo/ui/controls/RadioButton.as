package com.dolo.ui.controls
{
	import com.dolo.ui.managers.RadioButtonGroup;
	import flash.events.Event;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.dolo.ui.tools.Xdis;

	/**
	 * 使用 RadioButton 组件可以强制用户只能从一组选项中选择一项。 
	 * 该组件必须用于至少有两个 RadioButton 实例的组。在任何给定的时刻，都只有一个组成员被选中。
	 * 选择组中的一个单选按钮将取消选择组内当前选定的单选按钮。
	 * 您可以设置 groupName 参数，以指示单选按钮属于哪个组。  
	 * 
	 * @author flashk
	 * 
	 */
	public class RadioButton extends UIComponent
	{
		protected var _group:RadioButtonGroup;
		protected var _ui:MovieClip;
		protected var _value:*;
		protected var _selected:Boolean = false;
		protected var _groupName:String;
		protected var _label:String;
		protected var _txt:TextField;
		
		public function RadioButton()
		{
			
		}
		
		public function get label():String
		{
			return _label;
		}

		/**
		 * 设置标签文本 
		 * @param value
		 * 
		 */
		public function set label(value:String):void
		{
			_label = value;
			if(_txt){
				_txt.htmlText = value;
				_txt.width = _txt.textWidth+20;
			}
		}

		public function get groupName():String
		{
			return _groupName;
		}

		/**
		 * 设置单选组的名字，同个名字的单选按钮互斥 
		 * @param value
		 * 
		 */
		public function set groupName(value:String):void
		{
			_groupName = value;
			if(_group == null){
				_group = RadioButtonGroup.getGroup(_groupName);
				_group.addRadioButton(this);
			}
		}
		
		/**
		 * 返回对标签文本实例的引用 
		 * @return 
		 * 
		 */
		public function get textField():TextField
		{
			return _txt;
		}
		
		public function get textColor():uint
		{
			return _txt.textColor;
		}
		
		/**
		 * 设置标签文本颜色 
		 * @param value
		 * 
		 */
		public function set textColor(value:uint):void
		{
			_txt.textColor = value;
		}

		public function get value():*
		{
			return _value;
		}

		/**
		 * 设置此单选按钮对应的数据项，此数据和文本互相独立 
		 * @param value
		 * 
		 */
		public function set value(value:*):void
		{
			_value = value;
		}

		/**
		 * 获得 RadioButtonGroup 的引用，通过对RadioButtonGroup的属性和方法来访问更多的功能
		 * @return 
		 * 
		 */
		public function get group():RadioButtonGroup
		{
			return _group;
		}

		public function set group(value:RadioButtonGroup):void
		{
			_group = value;
		}
		
		/**
		 * 设置/获取选中状态，同样可以通过此单选按钮的RadioButtonGroup来设置/访问
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			this.mouseChildren = !_selected;
			this.mouseEnabled = !_selected;
			updateView();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as MovieClip;
			_ui.stop();
			_ui.mouseEnabled = false;
			_ui.addEventListener(MouseEvent.CLICK,onMouseClick);
			_txt = Xdis.getChild(_ui,"label_txt");
			resetXY(_ui);
			this.addChild(_ui);
			initMouseSet();
			label = _label;
		}
		
		protected function onMouseClick(event:MouseEvent=null):void
		{
			selected = !selected;
		}
		
		protected function updateView():void
		{
			if(_selected == true){
				_ui.gotoAndStop(2);
			}else{
				_ui.gotoAndStop(1);
			}
			initMouseSet();
		}
		
		protected function initMouseSet():void
		{
			var simBtn:SimpleButton;
			for(var i:int=0;i<_ui.numChildren;i++){
				simBtn = _ui.getChildAt(i) as SimpleButton;
				if(simBtn){
					simBtn.useHandCursor = false;
				}
			}
		}

	}
}
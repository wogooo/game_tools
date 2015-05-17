package com.dolo.ui.controls
{
	import com.dolo.ui.tools.Xtip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import com.dolo.ui.managers.UI;

	/**
	 * UI控件基类 
	 * @author flashk
	 * 
	 */
	public class UIComponent extends Sprite
	{
		protected var _compoWidth:Number = 10;
		protected var _compoHeight:Number = 10;
		protected var _enabled:Boolean;
		protected var _tooltip:String;
		
		public function UIComponent()
		{
			
		}
		
		public function get tooltip():String
		{
			return _tooltip;
		}
		
		/**
		 * 设置组件的tooltip 
		 * @param value
		 * 
		 */
		public function set tooltip(value:String):void
		{
			_tooltip = value;
			Xtip.registerTip(this,_tooltip);
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * 禁用(false)启用(true)组件 
		 * @param value
		 * 
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(value == true){
				this.filters = [];
			}else{
				this.filters = UI.disableFilter;
			}
			this.mouseChildren = value;
			this.mouseEnabled = value;
		}
		
		/**
		 * 释放内存资源，释放后此组件可能不可再使用 
		 * 
		 */
		public function dispose():void
		{
			
		}
		
		/**
		 * 重设组件大小 
		 * @param newWidht
		 * @param newHeight
		 * 
		 */
		public function setSize(newWidht:Number,newHeight:Number):void
		{
			_compoWidth = newWidht;
			_compoHeight = newHeight;
		}
		
		/**
		 * 获得组件的宽度，此宽度并不一定等同于DisplayObject的width。是setSize的宽度
		 * 
		 * @see #setSize()
		 * @see flash.display.DisplayObject
		 */ 
		public function get compoWidth():Number 
		{
			return _compoWidth;
		}
		
		/**
		 * 获得组件的高度，此宽度并不一定等同于DisplayObject的height。是setSize的高度度
		 * 
		 * @see #setSize()
		 * @see flash.display.DisplayObject
		 */ 
		public function get compoHeight():Number 
		{
			return _compoHeight;
		}
		
		public function resetXY(targetDis:DisplayObject,isTargetZreo:Boolean=true):void
		{
			this.x = int(targetDis.x);
			this.y = int(targetDis.y);
			if(isTargetZreo == true){
				targetDis.x = 0;
				targetDis.y = 0;
			}
		}
		
		/**
		 * 将组件绑定到指定的皮肤 ，子类需覆盖此方法
		 * @param skin
		 * 
		 */
		public function targetSkin(skin:DisplayObject):void
		{
			
		}
		
	}
}
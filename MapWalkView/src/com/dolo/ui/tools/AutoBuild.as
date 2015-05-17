package com.dolo.ui.tools
{
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.ComboBox;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.RadioButton;
	import com.dolo.ui.controls.Slider;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.controls.UIComponent;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.controls.Window;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * UI界面自动构建 
	 * @author Administrator
	 * 
	 */
	public class AutoBuild
	{
		//最大嵌套循环次数
		private static var _maxStep:uint = 3000;
		private static var _stepCount:uint;
		private static var _addI:int;	
		
		public static function get maxStep():uint
		{
			return _maxStep;
		}
		
		public static function set maxStep(value:uint):void
		{
			_maxStep = value;
		}
		
		/**
		 * 自动构建整个UI界面为组件，将循环检查此对象的所有子级，所有组件按照同样位置，同样大小，同样层级构建，替换规则参考buildOneDis函数
		 * @param target
		 * 
		 */
		public static function replaceAll(target:Sprite):void
		{
			_stepCount = 0;
			buildOneSprite(target);
		}
		
		private static function buildOneSprite(sp:Sprite):void
		{
			_stepCount++;
			if(_stepCount>_maxStep){
				return;
			}
			var i:int=0;
			var len:int = sp.numChildren;
			for(i=0;i<len;i++){
				buildOneDis(sp,i);
				i+=_addI;
			}
		}
		
		private static function buildOneDis(sp:Sprite,index:int):void
		{
			var name:String;
			var i:int;
			var controls:UIComponent;
			var needSetSize:Boolean = true;
			var isNeedBuildIn:Boolean = true;
			if(index > sp.numChildren - 1 ) return;
			var dis:DisplayObject = sp.getChildAt(index);
			if(dis is UIComponent && (dis is Window) == false) return;
			if(dis is Sprite ){
				//嵌套循环查找
				buildOneSprite(dis as Sprite);
			}
			name = dis.name;
			_addI = 0;
			var endName:String = name.slice(name.lastIndexOf("_")+1);
			if(name.lastIndexOf("_") == -1) {
				endName = "";
			}
			endName = "_"+endName;
			var needRemove:Boolean = true;
			var disWidth:int = Math.round(dis.width);
			var disHeight:int = Math.round(dis.height);
			switch(endName){
				case "_button":
					controls = new Button;
					var btn:Button = controls as Button;
					btn.label = findLabelText(dis,index);
					btn.targetSkin(dis);
					needRemove = false;
					break;
				case "_toggleButton":
					controls = new ToggleButton;
					var tbtn:ToggleButton = controls as ToggleButton;
					tbtn.label = findLabelText(dis,index);
					tbtn.targetSkin(dis);
					needRemove = false;
					break;
				case "_vScrollBar":
					controls = new VScrollBar;
					VScrollBar(controls).targetSkin(dis);
					needRemove = false;
					break;
				case "_progressBar":
					controls = new ProgressBar;
					ProgressBar(controls).targetSkin(dis);
					needRemove = false;
					break;
				case "_numericStepper":
					controls = new NumericStepper;
					NumericStepper(controls).targetSkin(dis);
					needRemove = false;
					break;
				case "_checkBox":
					controls = new CheckBox;
					controls.targetSkin(dis);
					needRemove = false;
					break;
				case "_radioButton":
					controls = new RadioButton;
					RadioButton(controls).label = findLabelText(dis,index);
					controls.targetSkin(dis);
					RadioButton(controls).groupName = dis.name.slice(dis.name.indexOf("_"));
					needRemove = false;
					break;
				case "_list":
					controls = new List;
					controls.targetSkin(dis);
					needRemove = false;
					break;
				case "_tileList":
					controls = new TileList;
					controls.targetSkin(dis);
					needRemove = false;
					break;
				case "_comboBox":
					controls = new ComboBox;
					controls.targetSkin(dis);
					needRemove = false;
					break;
				case "_slider":
					controls = new Slider;
					controls.targetSkin(dis);
					needRemove = false;
					break;
				case "_iconImage":
					controls = new IconImage;
					break;
			}
			if(controls == null) return;
			controls.name = name;
			if(needRemove){
				sp.removeChildAt(index);
				controls.x = int(dis.x);
				controls.y = int(dis.y);
			}
			sp.addChildAt(controls,index);
			if(needSetSize){
				controls.setSize(disWidth,disHeight);
			}
		}
		
		private static function findLabelText(labelDisplayObj:DisplayObject,index:uint):String
		{
			var par:DisplayObjectContainer = labelDisplayObj.parent;
			var len:uint = par.numChildren;
			var dis:DisplayObject;
			var j:int;
			for( j=index+1;j<len;j++){
				dis = par.getChildAt(j);
				if(dis is TextField){
					if(dis.x>labelDisplayObj.x && dis.x < labelDisplayObj.x+labelDisplayObj.width/2 
						&& dis.y > labelDisplayObj.y && dis.y < labelDisplayObj.y+labelDisplayObj.height/2){
						dis.parent.removeChild(dis);
						return TextField(dis).text.split("\r").join("");
					}
				}
			}
			return "";
		}
		
		/**
		 * 替换单个UI控件
		 * 
		 * @param targetName 参照的对象名字
		 * @param parentSprite 父层
		 * @param uiComponent UI控件
		 * @param isReSize
		 * @param isUseSameName
		 * @param isUseSameXY
		 * @param isAutoRemove
		 * 
		 */
		public static function buildOne(targetName:String,parentSprite:Sprite,uiComponent:UIComponent,
										isReSize:Boolean=true,
										isUseSameName:Boolean=true,
										isUseSameXY:Boolean=true,
										isAutoRemove:Boolean=true):void
		{
			var dis:DisplayObject = parentSprite.getChildByName(targetName);
			var index:uint = parentSprite.getChildIndex(dis);
			if(isReSize){
				uiComponent.setSize(Math.round(dis.width),Math.round(dis.height));
			}
			if(isUseSameName){
				uiComponent.name = dis.name;
			}
			if(isUseSameXY){
				uiComponent.x = int(dis.x);
				uiComponent.y = int(dis.y);
			}
			if(isAutoRemove){
				parentSprite.removeChildAt(index);
				parentSprite.addChildAt(uiComponent,index);
			}
		}
		
	}
}
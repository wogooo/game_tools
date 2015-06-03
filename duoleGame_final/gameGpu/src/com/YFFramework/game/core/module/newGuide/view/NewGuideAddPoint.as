package com.YFFramework.game.core.module.newGuide.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	/***
	 *人物属性加点提示(可以用于其他纯文字提示)
	 *@author ludingchang 时间：2013-12-20 下午4:32:22
	 */
	public class NewGuideAddPoint extends Window
	{
		private var _ui:Sprite;
		private var _des:TextField;
		private var _name_txt:TextField;
		private var _icon:IconImage;
		private var _okBtn:Button;
		
		private var _callbackEvent:String;
		private var _callbackParams:YFEvent;
		/**窗口类型*/
		private var _myType:int;
		/**构造函数，请不要直接调用，请用 <code>getInstence(type:int)</code> 来获取窗口实例*/
		public function NewGuideAddPoint(type:int=0)
		{
			_myType=type;
			super(MinWindowBg);
			_ui = initByArgument(205,208,"bagUI_putOnEquip");
			setContentXY(15,15);
			tittleBgUI.visible=false;
			_des=Xdis.getChild(_ui,"txt1");
			_des.wordWrap=true;
			_des.autoSize=TextFieldAutoSize.LEFT;
			_des.mouseEnabled=false;
			_des.selectable=false;
			_name_txt=Xdis.getTextChild(_ui,"txt2");
			_name_txt.mouseEnabled=false;
			_name_txt.selectable=false;
			_icon=Xdis.getChild(_ui,"icon_iconImage");
			_okBtn=Xdis.getChild(_ui,"use_button");
			_okBtn.addEventListener(MouseEvent.CLICK,callbackFun);
		}
		
		protected function callbackFun(event:MouseEvent):void
		{
			close();
			if(_callbackEvent)
				YFEventCenter.Instance.dispatchEventWith(_callbackEvent,_callbackParams);
		}
		
		/**
		 *显示此组件 
		 * @param info：要显示的文字信息
		 * @param btnLabel：按钮名字
		 * @param callbackEvent：点击按钮后回调的事件
		 * @param callbackParams：回调事件的参数
		 * 
		 */		
		public function show(info:String,btnLabel:String,callbackEvent:String,callbackParams:YFEvent=null):void
		{
			_des.text=info;
			_callbackEvent=callbackEvent;
			_callbackParams=callbackParams;
			_okBtn.label=btnLabel;
			
			_des.y=_ui.height/2-_des.height/2;
			
			LayerManager.WindowLayer.addChild(this);
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,resize);
			resize();
		}
		
		private function resize(e:Event=null):void
		{
			x=StageProxy.Instance.getWidth()-width;
			y=StageProxy.Instance.getHeight()-height-60;
		}
		
		public override function dispose():void
		{
			_ui=null;
			_des=null;
			_name_txt=null;
			_icon=null;
			_okBtn.removeEventListener(MouseEvent.CLICK,callbackFun);
			_okBtn=null;
			_inst[_myType]=null;//从数组中移除
			super.dispose();
		}
		
		public override function close(event:Event=null):void
		{
			if(this.parent)
				this.parent.removeChild(this);
			dispose();
		}
		
		
		private static var _inst:Array=new Array;//实例数组
		/**
		 *根据类型取实例 
		 * @param type ：类型
		 * @return 窗口实例
		 */		
		public static function getInstence(type:int):NewGuideAddPoint
		{
			return _inst[type] ||= new NewGuideAddPoint(type);
		}
		
		/**
		 *根据类型关闭窗口 
		 * @param type ：类型
		 */		
		public static function closeByType(type:int):void
		{
			var newGuide:NewGuideAddPoint=_inst[type];
			if(newGuide)
				newGuide.close();
		}
		
		/**窗口类型定义*/
		/**加点提示窗口*/
		public static const AddPoint:int=0;
		/**天书（成长任务）*/
		public static const GrowTask:int=1;
		/**背包里的新手礼包*/
		public static const Gift:int=2;
	}
}
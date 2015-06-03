package com.YFFramework.game.core.module.login.view
{
	/**选取socket频道
	 * @author yefeng
	 * 2013 2013-4-1 下午3:44:33 
	 */
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.ui.controls.GameWindow;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class SocketSelectView extends GameWindow
	{
		private var _vContainer:VContainer;
		private var _dict:Dictionary;
		
		public var callBack:Function;
		
		
		public function SocketSelectView()
		{
			super(400,300);
		}
		
		
		override protected function initUI():void
		{
			super.initUI();
			_dict=new Dictionary();
			_vContainer=new VContainer(20);
			addChild(_vContainer);
			_vContainer.y=_bgBody.y
			_vContainer.x=10;
			Draw.DrawRect(this.graphics,300,300,0xFF0000);
		}
		public function initData(arr:Array):void
		{
			var _mc:MovieClip;
			for each(var obj:Object in arr)
			{
				_mc=ClassInstance.getInstance("SocketListItem");
				_mc.mouseChildren=false;
				_mc.buttonMode=true;
				_vContainer.addChild(_mc);
				_mc.txt.text=String(obj.tittle);
				_dict[_mc]=obj;
			}
			_vContainer.updateView();
			if(arr.length==1)_mc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));

		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_vContainer.addEventListener(MouseEvent.CLICK,onClick);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_vContainer.removeEventListener(MouseEvent.CLICK,onClick);
		}

		
		private function onClick(e:MouseEvent):void
		{
			var mc:MovieClip=e.target as MovieClip;
			if(mc)
			{
//				callBack(_dict[mc].ip,_dict[mc].port,_dict[mc].checkPort)
				callBack(_dict[mc].ip,_dict[mc].port,_dict[mc].checkPort)
				dispose();
			}
			
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			if(parent) parent.removeChild(this);
			_dict=null;
			_vContainer=null;
		}
		
		
		
		
	}
}
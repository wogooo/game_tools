package com.YFFramework.game.debug
{
	/**@author yefeng
	 *2012-8-25下午3:28:38
	 */
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.layer.PopUpManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFPane;
	import com.YFFramework.core.ui.yfComponent.controls.YFTextArea;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	import com.YFFramework.game.core.global.DataCenter;
	
	import flash.ui.Keyboard;
	
	public class DebugPane extends YFPane
	{
		private static var _instance:DebugPane;
		
		
		private var _nameLabel:YFLabel;
		
		/**坐标信息
		 */ 
		private var _ptLabel:YFLabel
		
		private var _socketLabel:YFTextArea;
		
		private var _container:VContainer;
		
		private var _width:Number;
		private var _height:Number;
		public function DebugPane()
		{
			_width=300;
			_height=400;
			super(_width, _height, false);
		}
		public static function   get Instance():DebugPane
		{
			if(!_instance) _instance=new DebugPane();
			return _instance;
				
		}
		override protected function addEvents():void
		{
			super.addEvents();
//			YFEventCenter.Instance.addEventListener("getCMD",onYFEvent);
//			YFEventCenter.Instance.addEventListener("sendCMD",onYFEvent);
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMove,onYFEvent);
//			
			var keyboardItem:KeyBoardItem=new KeyBoardItem(Keyboard.F8,onKeyborad);
			var keyboardItem2:KeyBoardItem=new KeyBoardItem(Keyboard.F7,onKeyborad2); 
		}
		private function onKeyborad2(code:int):void
		{
			_socketLabel.text="";
		}
			
		private function onKeyborad(code:int):void
		{
			
			if(!LayerManager.DebugLayer.contains(this))
			{
				LayerManager.DebugLayer.addChild(this);
				PopUpManager.centerPopUp(this);
			}
			else LayerManager.DebugLayer.removeChild(this);

		}
//		
//		private function onYFEvent(e:YFEvent):void
//		{
//			var cmd:int=int(e.param);
//			switch(e.type)
//			{
//				case "getCMD":
//					_socketLabel.text +="S="+cmd+"\n";
//					break;
//				case "sendCMD":
//					_socketLabel.text +="C="+cmd+"\n";
//					break
//				case MapScenceEvent.HeroMove :
//					//,{bgMapX:_bgMapX,bgMapY:_bgMapY}
//					var obj:Object=e.param;
//			//		_ptLabel.text="x= "+HeroProxy.x+"\ny="+HeroProxy.y+"\nmapX"+HeroProxy.mapX+"\nmapY"+HeroProxy.mapY+"\nbgMapX="+obj.bgMapX+"\nbgMapY"+obj.bgMapY;				
//					break;
//			}
//		}
//		
		override protected function initUI():void
		{
			super.initUI();
			_container=new VContainer(5);
			addChild(_container);
			_container.y=_bgBody.y+40;
			_container.x=20;
//			_nameLabel=new YFLabel();
//			_nameLabel.text="id="+DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
//			_container.addChild(_nameLabel);
//			
//			_ptLabel=new YFLabel(); 
//			_ptLabel.width=400;
//			_container.addChild(_ptLabel);
//			_ptLabel.text="x= "+HeroProxy.x+"\ny="+HeroProxy.y+"\nmapX"+HeroProxy.mapX+"\nmapY"+HeroProxy.mapY+"\nbgMapX="+0+"\nbgMapY="+0;
			_socketLabel=new YFTextArea(250,200);
			_container.addChild(_socketLabel)
			_container.updateView()
			_socketLabel.text="";
			
		}
		
		public function log(txt:String):void
		{
		//	_socketLabel.text +=txt+"\n";  ////过多的字符串不要使用+符号 否则严重影响效率
		//	_socketLabel.apppendtext(txt+"\n");
			_socketLabel.apppendtext(txt);
		}
		
		override public function get visualWidth():Number
		{
			return _width;
		}
		override public function get visualHeight():Number
		{
			return _height;
		}
	}
}
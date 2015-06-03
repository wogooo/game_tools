package com.YFFramework.game.core.module.pk.view
{
	/**@author yefeng
	 * 2013 2013-5-6 下午3:59:55 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.YFFramework.game.core.module.pk.manager.CompeteDyManager;
	import com.YFFramework.game.core.module.pk.view.render.CompeteRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CompeteWindow extends PopMiniWindow{
		
		private var _mc:Sprite;
		private var _list:List;
		
		public function CompeteWindow(){
			_mc = initByArgument(369,345,"invitePanel");
			_list = Xdis.getChild(_mc,"invite_list");
			_list.itemRender = CompeteRender;
			
			YFEventCenter.Instance.addEventListener(PKEvent.CloseInviteWindow,onClose);
		}
		
		public function updateView():void{
			_list.removeAll();
			
			var item:ListItem;
			var arr:Array=CompeteDyManager.Instance.getPkArray();
			var len:int=arr.length;
			for(var i:int=0;i<len;i++){
				item = new ListItem();
				item.name=arr[i].name;
				item.lv=arr[i].level;
				item.dyId=arr[i].dyId;
				_list.addItem(item);
			}
			CompeteDyManager.Instance.clear();
		}

		override public function close(event:Event=null):void{
			super.close(event);
			this.dispose();
		}
		
		override public function dispose():void{
			_list.removeAll();
		}

		private function onClose(e:YFEvent):void{
			if(_list.length==0)	this.close();
		}
		
		public function popBack():void{
			if(this.isOpen)		this.close();
		}
	}
}
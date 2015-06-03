package com.YFFramework.game.core.module.im.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.im.model.TypeIM;
	import com.YFFramework.game.core.module.im.view.render.IMNodeRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/** 面板列表  对应   好友面板   IMUI   元件中的 view1  view2  view3  view4  面板 
	 * @author yefeng
	 * 2013 2013-6-21 下午5:05:18 
	 */
	public class AbsUserListView
	{
		/**单击后 等这么长时间才会显示
		 */		
		protected var _menuShowTime:TimeOut;

		protected var _list:List;
		/**下拉菜单
		 */		
		protected var _menu:Menu;
		/**类型文本框*/
		private var _type_txt:TextField;
		private var _type_name:String;
		private var _all:int,_online:int;
		public function AbsUserListView(ui:Sprite,listName:String)
		{
			_list = Xdis.getChild(ui,"all_list");
			_list.itemRender=IMNodeRender;
			_list.addEventListener(Event.CHANGE,onListChange);
			_type_txt=Xdis.getTextChild(ui,"type_txt");
			_type_name=listName;
			initListDB();
			initMenu();
			updateView([]);
		}
		
		/**
		 * 设置类型文本及在线人数
		 * @param online 在线人数
		 * @param all 总人数
		 */		
		protected function setTypeTxt():void
		{
			_type_txt.htmlText=HTMLFormat.color(_type_name+":",0xfff0b6)+HTMLFormat.color(_online+"/"+_all,0x8cf213);
		}
		/**设置 list双击
		 */		
		protected function initListDB():void
		{
			//设置双击
			_list.dbClickCall=listDBClick;
			_list.canDBClick=true;
		}
		/**初始化菜单
		 */		
		protected function initMenu():void
		{
			_menu=new Menu();
		}
		
		private function onListChange(e:Event):void
		{
			//	_menu.show();
			if(_menuShowTime)_menuShowTime.dispose();
			var obj:Object={x:StageProxy.Instance.stage.mouseX,y:StageProxy.Instance.stage.mouseY}
			_menuShowTime=new TimeOut(200,showMenu,obj);
			_menuShowTime.start();
		}
		private function showMenu(obj:Object):void
		{
			_menu.show(null,obj.x,obj.y);
		}
		/** list Item 双击回调
		 */		
		private function listDBClick(imDyVo:IMDyVo):void
		{
			_menuShowTime.dispose();
			var privateTalkPlayerVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
			privateTalkPlayerVo.dyId=imDyVo.dyId;
			privateTalkPlayerVo.name=imDyVo.name;
			privateTalkPlayerVo.sex=imDyVo.sex;
//			privateTalkPlayerVo.vipLevel=imDyVo.vipLevel;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,privateTalkPlayerVo);  //进行私聊
		}
		/**添加玩家
		 */		
		private function addRole(data:IMDyVo):void
		{
			_list.addItem(data);
			_all++;
			if(data.online==TypeIM.Online)
				_online++;
		}
		/**
		 * 删除玩家 
		 */		
		private function removeRole(data:IMDyVo):void
		{
			_list.removeItem(data);
			_all--;
			if(data.online==TypeIM.Online)
				_online--;
		}
		/**清空所有的数据
		 */		
		public function clearAll():void
		{
			_list.removeAll();
			_all=0;
			_online=0;
		}
		/** 根据数据刷新 所有的UI 
		 * arr 保存的是 IMDyVo 数据
		 */		
		public function updateView(arr:Array):void
		{
			clearAll();
			var len:int=arr.length;
			var imDyVo:IMDyVo;
			for(var i:int=0;i!=len;++i)
			{
				imDyVo=arr[i];
				addRole(imDyVo);
			}
			setTypeTxt();
		}
		
	}
}
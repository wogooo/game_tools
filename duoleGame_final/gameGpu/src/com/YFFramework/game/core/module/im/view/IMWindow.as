package com.YFFramework.game.core.module.im.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.im.manager.IMManager;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.Linkage;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class IMWindow extends Window
	{
		private var _ui:Sprite;
		private var _nameTxt:TextField;
//		private var _offLineCheckBox:CheckBox;
		private var _tabsManager:TabsManager;
//		private var _setButton:Button;
		private var _findButton:Button;
		/**好友列表
		 */		
		private var _friendList:FriendListView;
		/**最近联系人列表
		 */		
		private var _latelyList:AbsUserListView;
		/**仇人列表
		 */		
		private var _enemyList:AbsUserListView;
		/**黑名单列表
		 */		
		private var _blacklist:BlackListView;
		/**当前玩家头像     用的组队小图像
		 */		
		private var _headIcon:IconImage;
		
		/**存储私聊窗口
		 */		 
		private var _privateTalkWindowDict:HashMap;
		/**查找好友
		 */		
		private var _seachFriendView:SeachFriendWindow;
		/**Vip*/
		private var _vipSP:Sprite;
		public function IMWindow()
		{
			//_ui = ClassInstance.getInstance("IMUI");
			_ui = initByArgument(360,580,"IMUI",WindowTittleName.friendTitle) as Sprite;
//			setContentXY(20,40);
			AutoBuild.replaceAll(_ui);
			//content = _ui;
			//title=WindowTittleName.friendTitle;
			//setSize(325,550);
			_dragArea.graphics.beginFill(0x0,0);
			_dragArea.graphics.drawRect(0,0,265,37);
			_nameTxt = Xdis.getChild(_ui,"name_txt");
//			_nameTxt.text = DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
//			_offLineCheckBox = Xdis.getChild(_ui,"offLine_checkBox");
//			_offLineCheckBox.label = "显示离线";
			_headIcon=Xdis.getChild(_ui,"icon_iconImage");
			_tabsManager = new TabsManager();
			_tabsManager.initTabs(_ui,"tabs_sp",4,"view");
//			_setButton = Xdis.getChild(_ui,"set_button");
//			_setButton.changeTextColor(IMStyle.getIMButtonStyle());
//			_setButton.addEventListener(MouseEvent.CLICK,onSetButtonClick);
			_findButton = Xdis.getChild(_ui,"find_button");
//			_findButton.changeTextColor(IMStyle.getIMButtonStyle());
			_findButton.addEventListener(MouseEvent.CLICK,onFindButtonClick);
			_friendList = new FriendListView(_tabsManager.getViewAt(1) as Sprite,"我的好友");
			_latelyList = new AbsUserListView(_tabsManager.getViewAt(2) as Sprite,"最近联系人");
			_enemyList = new AbsUserListView(_tabsManager.getViewAt(3) as Sprite,"我的仇人");
			_blacklist =  new BlackListView(_tabsManager.getViewAt(4) as Sprite,"黑名单");
			_privateTalkWindowDict=new HashMap(); //私聊窗口
			_vipSP=Xdis.getSpriteChild(_ui,"vipSP");
			_vipSP.buttonMode=true;
			_vipSP.addEventListener(MouseEvent.CLICK,onVipClick);
			addEvents();
		}
		
		protected function onVipClick(event:MouseEvent):void
		{
			// 发送黄钻点击事件
			YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,1);
		}
		
		protected function onFindButtonClick(event:MouseEvent):void
		{
//			IMTalkWindowManager.getInstance().getWindow("aa").open();
			if(!_seachFriendView)_seachFriendView=new SeachFriendWindow();	
			_seachFriendView.open();
		}
		
//		protected function onSetButtonClick(event:MouseEvent):void
//		{
//		}
		/**侦听事件
		 */		
		private function addEvents():void
		{
			//私聊
			YFEventCenter.Instance.addEventListener(GlobalEvent.PrivateTalkToOpenWindow,onPrivateTalk);
		}
		/**私聊
		 */		
		private function onPrivateTalk(e:YFEvent):void
		{
			var privateTalkPlayer:PrivateTalkPlayerVo=e.param as PrivateTalkPlayerVo;
			var talkWindow:IMTalkWindow=getTalkWindow2(privateTalkPlayer);
			talkWindow.open();
		}
		
		public function getTalkWindow(imDyVo:IMDyVo):IMTalkWindow
		{
			var talkWindow:IMTalkWindow;
			var privateTalkVo:PrivateTalkPlayerVo=getPrivateTalkRequestVo(imDyVo);
			if(!_privateTalkWindowDict.hasKey(privateTalkVo.dyId))
			{
				talkWindow=new IMTalkWindow(privateTalkVo);
				_privateTalkWindowDict.put(imDyVo.dyId,talkWindow)//存储窗口
			}
			else talkWindow=_privateTalkWindowDict.get(imDyVo.dyId);
			return talkWindow;
		}
		
		public function getTalkWindow2(privateTalkVo:PrivateTalkPlayerVo):IMTalkWindow
		{
			var talkWindow:IMTalkWindow;
			if(!_privateTalkWindowDict.hasKey(privateTalkVo.dyId))
			{
				talkWindow=new IMTalkWindow(privateTalkVo);
				_privateTalkWindowDict.put(privateTalkVo.dyId,talkWindow);//存储窗口
			}
			else talkWindow=_privateTalkWindowDict.get(privateTalkVo.dyId);
			return talkWindow;
		}

		private function getPrivateTalkRequestVo(imDyVo:IMDyVo):PrivateTalkPlayerVo
		{
			var privateChatVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
			privateChatVo.dyId=imDyVo.dyId;
			privateChatVo.name=imDyVo.name;
			privateChatVo.career=imDyVo.career;
			privateChatVo.sex=imDyVo.sex;
			return privateChatVo;
		}
		
		
		
		
		override protected function resetCloseLinkage():void
		{
			_closeButtonLinkage = Linkage.windowCloseButton;
			_closeButtonX = 265-50;
			_closeButtonY = 7;
		}
		
		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-50,UI.stage.stageHeight-45,0.02,0.04);
		}
		
		/**刷新所有的列表
		 */		
		public function updateView():void
		{
			updateFriendList();
			updateEnemyList();
			updateBlackList();
		}
		/**更新好友面板人物图像  和名称
		 */		
		public function updateHeroIM():void
		{
			var vo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			_nameTxt.text = vo.roleName;
			var url:String=CharacterPointBasicManager.Instance.getFriendIconURL(vo.career,vo.sex);
			if(url!=_headIcon.url)
				_headIcon.url=url;
			var vipRes:String=TypeRole.getVipResName(vo.vipType,vo.vipLevel);
			_vipSP.removeChildren();
			if(vipRes!="")
			{
				var vipBtn:Sprite=ClassInstance.getInstance(vipRes);
				_vipSP.addChild(vipBtn);
				_vipSP.x=_nameTxt.x+_nameTxt.textWidth+4;
			}
		}
		/**刷新 好友列表
		 */		
		public function updateFriendList():void
		{
			_friendList.updateView(IMManager.Instance.friendList.getArray());
		}
		/**刷新黑名单列表
		 */		
		public function updateBlackList():void
		{
			_blacklist.updateView(IMManager.Instance.blackList.getArray());
		}
		/**刷新敌人列表
		 */		
		public function updateEnemyList():void
		{
			_enemyList.updateView(IMManager.Instance.EnemyList.getArray());
		}
		override public function open():void
		{
			super.open();
		}
	}
}
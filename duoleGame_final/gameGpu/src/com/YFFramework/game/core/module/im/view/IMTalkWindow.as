package com.YFFramework.game.core.module.im.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.chat.manager.ChatFilterManager;
	import com.YFFramework.game.core.module.chat.view.ChatView;
	import com.YFFramework.game.core.module.chat.view.FacesView;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.manager.IMManager;
	import com.YFFramework.game.core.module.im.model.PrivateTalkContentVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.controls.WindowEx;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	/**
	 * 私聊面板
	 * */
	public class IMTalkWindow extends WindowEx
	{
		/**聊天玩家数据vo 
		 */		
		private var _privateTalkRequestVo:PrivateTalkPlayerVo;
		private var _ui:Sprite;
		/**所有的聊天内容 
		 */		
		private var allTalkContainer:VContainer;
		private var _scrollBar:VScrollBar;
		private static const _scrollRenderW:int=362;
		private static const _scrollRenderH:int=167;
		/**自己输入的内容
		 */		
		private var inputTxt:TextField;
		/**发送 按钮 
		 */		
		private var _sendButton:Button;
		/** 关闭按钮
		 */		
		private var _myCloseButton:Button;
		/**好友按钮 请求好友
		 */		
		private var _friendButton:Button;
		/**组队按钮
		 */		
		private var _teamButton:Button;
		/**黑名单按钮
		 */		
		private var _blackListButton:Button;
		/**观察
		 */
		private var _watchButton:Button;
		/**人物图像图标
		 */		
		private var _headIcon:IconImage;
		/**旗子，用来显示自己位置 的 按钮
		 */		
		private var _locationBtn:SimpleButton;
		
		/**  表情图标按钮
		 */		
		private var _faceBtn:SimpleButton;
		private var _faceView:FacesView;
		/**人物姓名
		 */		
		private var _nameTxt:TextField;
		private var _myMiniButton:Button;
		public function IMTalkWindow(privateTalkRequestVo:PrivateTalkPlayerVo)
		{
			_privateTalkRequestVo=privateTalkRequestVo;
			allTalkContainer=new VContainer(2);
			_ui = initByArgument(400,480,"IMTalkUI",WindowTittleName.imBoxTitle);
			_sendButton=Xdis.getChild(_ui,"send_button");
			_myCloseButton=Xdis.getChild(_ui,"close_button");
			_friendButton=Xdis.getChild(_ui,"friend_button");
			_teamButton=Xdis.getChild(_ui,"team_button");
			_blackListButton=Xdis.getChild(_ui,"black_button");
			_watchButton=Xdis.getChild(_ui,"watch_button");
			_scrollBar=Xdis.getChild(_ui,"list_vScrollBar");
			inputTxt=Xdis.getChild(_ui,"input_txt");
			_nameTxt=Xdis.getChild(_ui,"nameTxt");
			inputTxt.maxChars=50;
			_headIcon=Xdis.getChild(_ui,"icon_iconImage");
			_faceBtn=Xdis.getChild(_ui,"face_btn");
			_locationBtn=Xdis.getChild(_ui,"locationBtn");
			_myMiniButton=Xdis.getChild(_ui,"mini_button");
			clearText();
			var allTextContainer:Sprite=Xdis.getChild(_ui,"allTextContainer");
			allTextContainer.addChild(allTalkContainer);
			_scrollBar.setTarget(allTalkContainer,false,_scrollRenderW,_scrollRenderH);
//			_scrollBar.setSize( _scrollBar.compoWidth, _compoHeight );
			showMinButton();
			//显示人物图像
			_headIcon.url=CharacterPointBasicManager.Instance.getFriendIconURL(privateTalkRequestVo.career,privateTalkRequestVo.sex);
			//显示名字
			_nameTxt.text=privateTalkRequestVo.name;
			_faceView=new FacesView();
			_faceView.closeWithOut = [_faceBtn,inputTxt];
			_faceView.target = this;
			initButtons();
			addEvents();
		}
		/**创建button信息
		 */		
		private function initButtons():void
		{
			//是否具有该好友
			if(!IMManager.Instance.friendList.hasRole(_privateTalkRequestVo.dyId)) 
			{
				_friendButton.enabled=true;
			}
			else _friendButton.enabled=false;
			if(!TeamDyManager.Instance.containsMember(_privateTalkRequestVo.dyId))
			{
				_teamButton.enabled=true;
			}
			else _teamButton.enabled=false;
			hideMinButton();
		}
		public function get privateTalkRequestVo():PrivateTalkPlayerVo
		{
			return _privateTalkRequestVo;
		}	
		private function clearText():void
		{
			inputTxt.text="";
		}
		
		private function addEvents():void
		{
			//发送消息
			_sendButton.addEventListener(MouseEvent.CLICK,onClick);
			//关闭窗口
			_myCloseButton.addEventListener(MouseEvent.CLICK,onClick);
			//最小化窗口
			_myMiniButton.addEventListener(MouseEvent.CLICK,onClick);
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_faceBtn.addEventListener(MouseEvent.CLICK,onClick);
			_friendButton.addEventListener(MouseEvent.CLICK,onClick);
			_teamButton.addEventListener(MouseEvent.CLICK,onClick);
			_blackListButton.addEventListener(MouseEvent.CLICK,onClick);
			_watchButton.addEventListener(MouseEvent.CLICK,onClick);
			//发送自己的坐标位置
			_locationBtn.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function removeEvents():void
		{
			_sendButton.removeEventListener(MouseEvent.CLICK,onClick);
			_myCloseButton.removeEventListener(MouseEvent.CLICK,onClick);
			_myMiniButton.removeEventListener(MouseEvent.CLICK,onClick);
			StageProxy.Instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_faceBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_friendButton.removeEventListener(MouseEvent.CLICK,onClick);
			_teamButton.removeEventListener(MouseEvent.CLICK,onClick);
			_blackListButton.removeEventListener(MouseEvent.CLICK,onClick);
			_watchButton.removeEventListener(MouseEvent.CLICK,onClick);
			_locationBtn.removeEventListener(MouseEvent.CLICK,onClick);

		}
		private function onKeyDown(e:KeyboardEvent):void
		{
		 	if(e.keyCode==Keyboard.ENTER)
			{
				if(e.ctrlKey)
				{
					sendContent();
				}
			}
		}

		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				 case _sendButton:
					 sendContent();
					 break;
				 case _myCloseButton: //关闭按钮
					 close();
					 break;
				 case _myMiniButton: // 最小化窗口
					 minWindow();
					 break;
				 case _faceBtn: //脸部
					 _faceView.switchShowClose();
					 updateFaceViewPosition();
					 break;
				 case _friendButton:
					 YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AddFriend,_privateTalkRequestVo);
					 break;
				 case _teamButton:
					 var roleDyVo:RoleDyVo=new RoleDyVo();
					 roleDyVo.dyId=_privateTalkRequestVo.dyId;
					 roleDyVo.roleName=_privateTalkRequestVo.name;
					 YFEventCenter.Instance.dispatchEventWith(TeamEvent.InviteReq,roleDyVo);	
					 break;
				 case _blackListButton:
					 YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AddToBlackList,_privateTalkRequestVo.dyId);
					 break;
				 case _watchButton: //观察 待做
					 ModuleManager.rankModule.otherPlayerReq(_privateTalkRequestVo.dyId);
					 break;
				 case _locationBtn: //发送自己的位置
					 var locationStr:String=ChatView.Instance.getLocationStr();
					 sendMsg(locationStr);
					 break;
			}
		}
		private function updateFaceViewPosition():void
		{
			_faceView.x = this.x-75;
			_faceView.y = this.y+_faceBtn.y -_faceBtn.height-82;
		}
		/**
		 * 插入表情 
		 * @param str
		 */
		public function insertString(str:String):void
		{
			UI.insertStringInText(inputTxt,str,true,true);
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveFriendIcon,privateTalkRequestVo);
		}
		/**显示场景上的好友聊天图标
		 */		
		public function showSceneIcon():void
		{
			//显示场景上的好友聊天图标
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayFriendIcon,privateTalkRequestVo);
		}
		
		override public function open():void
		{
			if(!isOpen)
			{
				//显示场景上的好友聊天图标
				showSceneIcon();
			}
			super.open();
		}
		
		/**最小化窗口
		 */		
		private function minWindow():void
		{
			super.close();
		}
		

		
		
		
		
		/**发送 聊天信息
		 */		
		private function sendContent():void
		{
			var textInfo:String=StringUtil.trim(inputTxt.text);
			textInfo=ChatFilterManager.filter(textInfo);
			sendMsg(textInfo);
		}
		
		private function sendMsg(textInfo:String):void
		{
			var privateTalkVo:PrivateTalkContentVo=new PrivateTalkContentVo();
			privateTalkVo.toId=_privateTalkRequestVo.dyId;
			privateTalkVo.content=textInfo;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_PrivateTalk,privateTalkVo);
			appendText(textInfo,DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
			clearText();
		}
		
		/** 追加文本
		 */		
		public function appendText(content:String,roleName:String):void
		{
			var obj:Object=ChatView.Instance.getReadableData(content);
			content=obj.content;
			var sp:RichText=new RichText();
			sp.width=320;
			var firstLine:String=roleName+"  "+TimeManager.getClientTimeStr();
			sp.setText(firstLine);
			allTalkContainer.addChild(sp);
			sp=new RichText();
			sp.width=320;
			sp.setText(content,ChatView.Instance.exeFunction,null,obj);
			sp.x=10;
			allTalkContainer.addChild(sp);
			allTalkContainer.updateView();
			_scrollBar.updateSize(allTalkContainer.contentHeight+2);
			_scrollBar.scrollToPosition(_scrollBar.size);//滚动到此高处
		//	clearText();
		}
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			_privateTalkRequestVo=null;
			_ui=null;
			allTalkContainer=null;
			_scrollBar=null;
			inputTxt=null;
			_sendButton=null;
			_myCloseButton=null;
			_headIcon=null;
			inputTxt=null;
			_sendButton=null;
			_myCloseButton=null;
			_friendButton=null;
			_teamButton=null;
			_blackListButton=null;
			_watchButton=null;
			_headIcon=null;
			_faceBtn=null;
			_faceView=null;
		}
		
	}
}
package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.chat.controller.ModuleChat;
	import com.YFFramework.game.core.module.chat.manager.ChatDataManager;
	import com.YFFramework.game.core.module.chat.manager.ChatFilterManager;
	import com.YFFramework.game.core.module.chat.manager.ChatTextUtil;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.chat.model.ChatViewData;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.TypeChannels;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapWorldVo;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.ComboBox;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.UIStyles;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.PopupTarget;
	import com.dolo.ui.tools.TextInputUtil;
	import com.dolo.ui.tools.Xdis;
	import com.msg.chat.SForwardChatMsg;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**聊天系统主界面 
	 * @author flashk
	 */
	public class ChatView extends Sprite{
		
		public static var upStageWidth:int = 1333;
		public static var inputMax:int = 60;
		public static var channels:Array = ["/D 大喇叭","/X 世 界","/G 公 会","/P 队 伍","/A 附 近"];
		public static var shortChannels:Array = ["大喇叭","世界","公会","队伍","附近"];
		public static var channelColos:Array = [0x3EBEEF,0xFB70FF,0x2AFF2B,0x0189FF,0xFFB84A];
		public static var speakYLess:int = -245;
		public static var speakYHide:int = -115;
		public static var tabIDs:Array = [-1,5,4,3,2,2];
		public static var channelColorsIndex:Array = [-1,4,3,2,1,0];
	
		private static var _upLessY:int = 88;
		private static var _ins:ChatView;
		
		private var _ui:Sprite;
		private var _faceBtn:SimpleButton;
		private var _locationBtn:SimpleButton;
		//按钮点击需要停留的时间
		private var _localtionBtnCDTime:Number=0;
		private var _facesView:FacesView;
		private var _inputTxt:TextField;
		private var _channelComboBox:ComboBox;
		private var _scrollCTRLs:Vector.<ChatScrollCTRL> = new Vector.<ChatScrollCTRL>();
		private var _speakBtn:SimpleButton;
		private var _enterBtn:SimpleButton;
		private var _filterBtn:SimpleButton;
		private var _filterSp:Sprite;
		private var _filterPop:PopupTarget;
		private var _filterCTRL:ChatFilterCTRL;
		private var _bgMC:MovieClip;
		private var _sizeMode:int = 1;
		private var _sizeBtn:SimpleButton;
		private var _tabsManager:TabsManager;
		private var _textsSp:Sprite;
		private var _speakSp:Sprite;
		private var _textTipStr:String = "请在这里输入聊天内容";
		private var _textTipColor:uint = 0x999999;
		private var _worldChannelLastTime:int = -100000;
		private var _worldChannelCD:int = 3000;
		private var _histroy:TextInputKeyHistroy;
		private var _spearkerCTRL:ChatSpeakerChatViewCTRL;
		private var _dict:Dictionary = new Dictionary();
		private var _hideMC:MovieClip;
		private var _isHiding:Boolean=false;
		
		public function ChatView(){
			_ins = this;
			_ui = ClassInstance.getInstance("ChatUI");
			AutoBuild.replaceAll(_ui);
			this.addChild(_ui);
			_faceBtn = Xdis.getChildAndAddClickEvent(onFaceBtnClick,_ui,"face_btn");
			_locationBtn = Xdis.getChildAndAddClickEvent(onLocation,_ui,"location_btn");
			_speakBtn = Xdis.getChildAndAddClickEvent(onSpeakBtnClick,_ui,"speak_btn");
			_inputTxt = Xdis.getChild(_ui,"input_txt");
			_inputTxt.maxChars = inputMax;
			new KeyBoardItem(Keyboard.ENTER,null,onEnter);
			_inputTxt.addEventListener(MouseEvent.CLICK,onMouseClick);
			TextInputUtil.initDefautText(_inputTxt,_textTipStr,true,0xFFFFFF,_textTipColor);
			_histroy = new TextInputKeyHistroy(_inputTxt);
			_enterBtn = Xdis.getChildAndAddClickEvent(sendMsg,_ui,"enter_btn");
			_filterBtn = Xdis.getChild(_ui,"filter_btn");	//过滤按钮
			_filterSp = ClassInstance.getInstance("ChatUIFilterAll");
			_filterPop = new PopupTarget(_filterBtn,_filterSp,2);
			_filterCTRL = new ChatFilterCTRL(_filterSp);
			_speakSp = Xdis.getChild(_ui,"speak_sp");
			_spearkerCTRL = new ChatSpeakerChatViewCTRL(_speakSp);
			_textsSp = Xdis.getChild(_ui,"texts_sp");
			_hideMC = Xdis.getChild(_ui,"hideMC");
			_hideMC.gotoAndStop(0);
			_hideMC.addEventListener(MouseEvent.CLICK,onHide);
			var scrollCTRL:ChatScrollCTRL;
			for(var i:int=1;i<=5;i++){
				scrollCTRL = new ChatScrollCTRL(Xdis.getChild(_ui,"texts_sp","allText"+i+"_sp"));
				_scrollCTRLs.push(scrollCTRL);
			}
			_tabsManager = new TabsManager();
			_tabsManager.isRemoveChild = false;
			_tabsManager.textUpColor = 0x505050;
			_tabsManager.textOverColor = 0xA66400;
			_tabsManager.textDownCloor = 0xFFB749;
			for(i=1;i<=5;i++){
				_tabsManager.add(Xdis.getChild(_ui,"tabs_sp","tab"+i),_scrollCTRLs[i-1].ui,Xdis.getChild(_ui,"tabs_sp","txt"+i));
			}
			_tabsManager.switchToTab(1);
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onTabIndexChange);
			_channelComboBox = Xdis.getChild(_ui,"channel_comboBox");
			_channelComboBox.dropdown.textFilters = UIStyles.textGlowFilters;
			_channelComboBox.rowCount = 6;
			_channelComboBox.dropdownWidth = 62;
			_channelComboBox.rightSpace = 0;
			_channelComboBox.selectedIndex = ChatViewData.COMBO_BOX_NEAR;
			_channelComboBox.textField.filters = UIStyles.textGlowFilters;
			_channelComboBox.isAlwaysPopAtTop = true;
			_channelComboBox.addEventListener(Event.CHANGE,onChannelComboBoxChange);
			_bgMC = Xdis.getChild(_ui,"bg_mc");
			_bgMC.stop();
			_sizeBtn = Xdis.getChildAndAddClickEvent(changeSize,_ui,"size_btn");
			var len:int=channels.length;
			for(i=1;i<len;i++){
				_channelComboBox.addItem(new ListItem(HTMLFormat.color(channels[i],channelColos[i]),channels[i],null,i));
			}
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
			UI.stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			onMouseRollOut();
			_scrollCTRLs[0].addNewMsg("　　~~欢迎登陆勇者之光~~");
			_scrollCTRLs[0].addNewMsg("　　　　健康游戏忠告",null,-7);
			_scrollCTRLs[0].addNewMsg("抵制不良游戏，拒绝盗版游戏。",null,-7);
			_scrollCTRLs[0].addNewMsg("注意自我保护，谨防受骗上当。",null,-7);
			_scrollCTRLs[0].addNewMsg("适度游戏益脑，沉迷游戏伤身。",null,-7);
			_scrollCTRLs[0].addNewMsg("合理安排时间，享受健康生活。",null,-7);
		}
		
		/**输入按钮点击
		 * @param e
		 */		
		private function onEnter(e:KeyboardEvent):void{
			if(UI.stage.focus==_inputTxt){
				if(_inputTxt.text=="")	StageProxy.Instance.setNoneFocus();
				else	sendMsg();
			}else if(UI.stage.focus is TextField)	return;
			else	UI.stage.focus = _inputTxt;
		}
		
		/**focus到聊天框
		 * @param e
		 */		
		private function onMouseClick(e:MouseEvent):void{
			UI.stage.focus = _inputTxt;
		}
		
		private function onLocation(e:MouseEvent):void{
			if(getTimer()-_localtionBtnCDTime>=5000)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatAutoSend,getLocationStr());
				_localtionBtnCDTime=getTimer(); 
			} 
//			else 
//			{   
//				NoticeUtil.setOperatorNotice("点击频率过高.");
//			}
		}
		
		public function getLocationStr():String{
			var chatData:ChatData = new ChatData();
			var vo:SmallMapWorldVo = new SmallMapWorldVo();
			var tilePt:Point=HeroPositionProxy.getTilePositon(); //转化为格子坐标
			vo.pos_x = tilePt.x;//HeroPositionProxy.mapX;
			vo.pos_y = tilePt.y;//HeroPositionProxy.mapY;
			vo.sceneId = DataCenter.Instance.mapSceneBasicVo.mapId;
			chatData.data = vo;
			chatData.displayName = tilePt.x+"，"+tilePt.y;
			chatData.myId = tilePt.x+tilePt.y;
			chatData.myQuality = 2;
			chatData.myType = ChatType.Chat_Type_Auto_Move;
			
			var txt:String = "我在"+DataCenter.Instance.mapSceneBasicVo.mapDes+"["+chatData.displayName+","+chatData.myType+","+chatData.myId+"]";
			var dict:Dictionary = new Dictionary();
			dict["【"+chatData.displayName+"】"+"_"+chatData.myType+"_"+chatData.myId] = chatData;
			var sendStr:String = ChatTextUtil.convertSendDataToString(txt,dict);
			return sendStr;
		}
		
		protected function onStageMouseDown(event:MouseEvent):void{
			if(this.hitTestPoint(UI.stage.mouseX,UI.stage.mouseY,true)== false)	setScrollBarVisibles(false);
		}
		
		protected function onMouseRollOver(event:MouseEvent):void{
			setScrollBarVisibles(true);
		}
		
		protected function onMouseRollOut(event:MouseEvent=null):void{
			if(UI.stage.mouseChildren == false) return;
			setScrollBarVisibles(false);
		}
		
		public function setScrollBarVisibles(value:Boolean):void{
			var len:int = _scrollCTRLs.length;
			for(var i:int=0;i<len;i++){
				_scrollCTRLs[i].setScrollBarVisible(value);
			}
		}
		
		public static function get Instance():ChatView{
			return _ins;
		}
		
		protected function onTabIndexChange(event:Event):void{
			switch(_tabsManager.nowIndex){
				case 2:
					_channelComboBox.selectedIndex = ChatViewData.COMBO_BOX_WORLD;
					break;
				case 3:
					_channelComboBox.selectedIndex = ChatViewData.COMBO_BOX_GUILD;
					break;
				case 4:
					_channelComboBox.selectedIndex = ChatViewData.COMBO_BOX_TEAM;
					break;
				case 5:
					_channelComboBox.selectedIndex = ChatViewData.COMBO_BOX_NEAR;
					break;
			}
		}
		
		protected function onSpeakBtnClick(event:MouseEvent):void{
			ChatSpeakerWindow.getInstance().openMe();
		}
		
		public function addNewForwardMessage(data:SForwardChatMsg):void{
			var channel:int = data.channel;
			//查看频道是否被刷屏
			if(channel < ChatFilterCTRL.stateIndex.length){
				var stateIndex:int = ChatFilterCTRL.stateIndex[channel-1];
				if(stateIndex != -1){
					if(ChatFilterCTRL.states[stateIndex-1] == true){
						return;
					}
				}
			}
			if(data.channel == TypeChannels.CHAT_CHANNEL_SPEAKER){
				_spearkerCTRL.showMessage(data);
				//var msg:String = ChatSpeakerChatViewCTRL.getSpeakerString(data);
				//_scrollCTRLs[1].addNewMsg(msg);
//				return;
			}
			var isMySelf:Boolean;
			if(data.fromId == DataCenter.Instance.roleSelfVo.roleDyVo.dyId)	isMySelf=true;
			else	isMySelf = false;
			if(channel < ChatFilterCTRL.stateIndex.length){
				stateIndex = ChatFilterCTRL.stateIndex[channel-1];
				if(stateIndex!=1){
					if(ChatFilterCTRL.states[stateIndex-1]==true)	isMySelf=false;
				}
			}
			
			addOneServerMsg(data.fromName,data.fromId,data.fromGender,data.msg,data.channel,data.fromVipLv,data.fromCareer,isMySelf);
		}
		
		/**发送消息，可以通过keyboard enter和鼠标点击发送进入该函数
		 * @param event 
		 */
		public function sendMsg(event:MouseEvent=null):void{
			if(ModuleChat.ins.isServerConnected==false){
				NoticeUtil.setOperatorNotice(LangBasic.chatNotConnnect);
				return;
			}
			
			if(_inputTxt.text.length<1 || (_inputTxt.text == _textTipStr && _inputTxt.textColor == _textTipColor)){
				NoticeManager.setNotice(NoticeType.Notice_id_100);
				UI.stage.focus = _inputTxt;
				return;
			}

			//队伍聊天需要加入隊伍
			if(_channelComboBox.selectedIndex==ChatViewData.COMBO_BOX_TEAM && TeamDyManager.LeaderId==0){
				NoticeUtil.setOperatorNotice("必须先加入队伍!");
				return;
			}
			
			//世界頻道需要3秒cd
			if(_channelComboBox.selectedIndex == ChatViewData.COMBO_BOX_WORLD){
				if(getTimer()-_worldChannelLastTime<_worldChannelCD){
					NoticeUtil.setOperatorNotice("世界频道发言间隔需大于3S");
					return;
				}
				_worldChannelLastTime = getTimer();
			}
			
			if(_channelComboBox.selectedIndex == ChatViewData.COMBO_BOX_GUILD){
				if(!GuildInfoManager.Instence.hasGuild){
					NoticeUtil.setOperatorNotice("先加入公会");
					return;
				}
			}
			
			var roVO:RoleDyVo = DataCenter.Instance.roleSelfVo.roleDyVo;
			var msg:String = ChatFilterManager.filter(_inputTxt.text);
			var channel:int = ChatSetUtil.getChannelType(_channelComboBox.selectedIndex+1);
			var sendName:String=roVO.roleName;
			var sendID:int=roVO.dyId;
			_histroy.putInHistroy();
			//associate msg with data
			var chatDataArr:Array = ChatDataManager.getChatDataArr();
			var len:int = chatDataArr.length;
			for(var i:int=0;i<len;i++){
				var regEx:String = "["+ChatData(chatDataArr[i]).displayName+"]";
				msg=msg.replace(regEx,"["+ChatData(chatDataArr[i]).displayName+","+ChatData(chatDataArr[i]).myType+","+ChatData(chatDataArr[i]).myId+"]");
				
				_dict["【"+ChatData(chatDataArr[i]).displayName+"】"+"_"+ChatData(chatDataArr[i]).myType+"_"+ChatData(chatDataArr[i]).myId] = ChatData(chatDataArr[i]);
			}
			msg = ChatTextUtil.convertSendDataToString(msg,_dict);
			ChatDataManager.getChatDataArr().splice(0);
			ModuleChat.ins.sendMessage(channel,msg,-1);
			_inputTxt.text = "";
			UI.setTextEndInput(_inputTxt,true);
		}
		
		private function addOneServerMsg(roleName:String,roleID:int,male:int,msg:String,channel:int,vipLevel:int,career:int,isMySelf:Boolean):void{
			var endStr:String = "";
			var beginStr:String = "";
			var maleStr:String;
			if(male == 0)	maleStr = "♀";
			else	maleStr = "♂";
			
			var fontIndex:int;
			var fontColor:String;
			if(channel<6){
				fontIndex = channelColorsIndex[channel];
				fontColor = "{#"+int(channelColos[fontIndex]).toString(16)+"|";
			}else{
				fontColor = "{#FF0000|";
			}
			var vipStr:String = ChatSetUtil.getVipText(vipLevel);
			var msgData:Object=ChatTextUtil.getReadableData(msg);
			msgData.data.sex = male;
			msgData.data.career=career;
			msgData.data.vip = vipLevel;
			msg = msgData.content;
			var addMsg:String = ChatSetUtil.getTextByChannel(channel)+maleStr+vipStr+beginStr+fontColor+roleName+"|"+ChatType.Chat_Type_Person+"|"+roleID+"}"+fontColor+endStr+"："+"}"+msg;
			_scrollCTRLs[0].addNewMsg(addMsg,msgData.data);
			if(channel < tabIDs.length){
				if(tabIDs[channel] != -1){
					_scrollCTRLs[tabIDs[channel]-1].addNewMsg(addMsg,msgData.data);
				}
			}
		}
		
		/**添加公会频道消息
		 * @param msg
		 */		
		public function addGuildMsg(msg:String):void{
			_scrollCTRLs[2].addNewMsg(msg);
		}
		
		/**获取数据Object, 内容为obj.content(String)
		 * @param msg
		 * @return 
		 */		
		public function getReadableData(msg:String):Object{
			var msgData:Object=ChatTextUtil.getReadableData(msg);
			return msgData;
		}
		
		/**运行可点击文本
		 * @param obj
		 */		
		public function exeFunction(obj:Object):void{
			if(obj.type==ChatType.Chat_Type_Auto_Move){
				var _data:*;
				_data = ChatDataManager.castData(obj.type,(obj.data.data)[obj.type+"_"+obj.id].data);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToWorldPt,_data);
			}
		}
		
		public function whenServerConnectOK():void{
			UI.setEnable(_enterBtn,true);
		}
		
		protected function changeSize(event:MouseEvent=null):void{
			_sizeMode++;
			if(_sizeMode>3)	_sizeMode = 1;
			if(_sizeMode<4)	_bgMC.gotoAndStop(_sizeMode);
			var len:int = _scrollCTRLs.length;
			for(var i:int=0;i<len;i++){
				_scrollCTRLs[i].changeSize(_sizeMode);
			}
			if(_sizeMode<4){
				_textsSp.visible = true;
				_speakSp.y = ChatScrollCTRL.posYs[_sizeMode-1]+speakYLess;
			}else{
				_textsSp.visible = false;
				_speakSp.y = speakYHide;
			}
		}
		
		private function onHide(e:MouseEvent):void{
			if(_isHiding==false){
				_isHiding=true;
				_hideMC.gotoAndStop(2);
				_bgMC.gotoAndStop(4);
				_textsSp.visible = false;
				_speakSp.y = speakYHide;
			}else{
				_isHiding=false;
				_hideMC.gotoAndStop(1);
				_bgMC.gotoAndStop(_sizeMode);
				var len:int = _scrollCTRLs.length;
				for(var i:int=0;i<len;i++){
					_scrollCTRLs[i].changeSize(_sizeMode);
				}
				_textsSp.visible = true;
				_speakSp.y = ChatScrollCTRL.posYs[_sizeMode-1]+speakYLess;
			}
		}
		
		public function addNewMessageInAll(msg:String):void{
			var len:int = _scrollCTRLs.length;
			for(var i:int=0;i<len;i++){
				_scrollCTRLs[i].addNewMsg(msg);
			}
		}
		
		protected function onChannelComboBoxChange(event:Event):void{
			var i:int = _channelComboBox.selectedIndex;
			_channelComboBox.text = HTMLFormat.color(shortChannels[i+1],channelColos[i+1]);
			_channelComboBox.textField.width = _channelComboBox.textField.textWidth+6;
		}
		
		public function insertString(str:String):void{
			UI.insertStringInText(_inputTxt,str,true,true);
		}
		
		protected function onFaceBtnClick(event:MouseEvent=null):void{
			if(_facesView == null){
				_facesView = new FacesView();
				_facesView.closeWithOut = [_faceBtn,_inputTxt];
				_facesView.target = this;
			}
			_facesView.switchShowClose();
			UI.stage.focus = _inputTxt;
			updateFaceXY();
		}
		
		public function updateFaceXY():void{
			if(_facesView){
				_facesView.x = this.x + 230;
				_facesView.y = this.y - 150-30;
			}
		}
		
		public function changeLessY(value:int):void{
			if(value == -1)	_upLessY = 88;
			else	_upLessY = value;
			onStageResize();
		}
		
		public function init():void{
			LayerManager.UILayer.addChild(this);
			UI.stage.addEventListener(Event.RESIZE,onStageResize);
			onStageResize();
		}

		protected function onStageResize(event:Event=null):void{
			var lessY:int = 0;
			if(UI.stage.stageWidth<upStageWidth)	lessY = _upLessY;
			this.y = UI.stage.stageHeight-lessY;
			updateFaceXY();
		}
		
		public function chatDisplay(chatData:ChatData):void{
			if(_inputTxt.text == _textTipStr)	_inputTxt.text = "["+chatData.displayName+"]";
			else	_inputTxt.appendText("["+chatData.displayName+"]");
			ChatDataManager.storeData(chatData);
		}
	}
}
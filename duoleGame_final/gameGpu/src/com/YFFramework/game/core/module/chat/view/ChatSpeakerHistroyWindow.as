package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	import com.msg.chat.SForwardChatMsg;
	
	import flash.display.Sprite;

	/**
	 * 大喇叭（千里传音）历史记录窗口 
	 * @author flashk
	 * 
	 */
	public class ChatSpeakerHistroyWindow extends PopMiniWindow
	{
		private static var _ins:ChatSpeakerHistroyWindow;
		
		/**
		 * UI界面Sprite 
		 */
		private var _ui:Sprite;
		/**
		 * 滚动条 
		 */
		private var _scrollBar:VScrollBar;
		/**
		 * RichText容器，包装器 
		 */
		private var _richTextSp:ChatHistroyTextSprite;
		private var _textWidth:int = 202;
		
		public function ChatSpeakerHistroyWindow()
		{
			_ui = initByArgument(285,258,"ChatSpeakerHistroyUI",WindowTittleName.speakerTitle);
			content.x = 20;
			_scrollBar = Xdis.getChild(_ui,"view_vScrollBar");
			_scrollBar.miniScrollerHeight = 23;
			_richTextSp = new ChatHistroyTextSprite();
			_richTextSp.max = 200000;
			_richTextSp.textWidth = _textWidth;
			_richTextSp.x = 5;
			_ui.addChild(_richTextSp);
			_scrollBar.setTarget(_richTextSp,false,_textWidth+10,_scrollBar.compoHeight-2);
			_scrollBar.arrowClickMove = 21;
			_ui.addChild(_scrollBar);
		}
		
		public static function getInstance():ChatSpeakerHistroyWindow
		{
			if(_ins == null){
				_ins = new ChatSpeakerHistroyWindow();
			}
			return _ins;
		}
		
		/**
		 * 添加一条历史纪录 
		 * @param data 服务器返回的数据
		 * 
		 */
		public function addtoHistroy(data:SForwardChatMsg):void
		{
			var msg:String = data.msg;
			var male:int = data.fromGender;
			var maleStr:String;
			if(male == 0){
				maleStr = "♀";
			}else{
				maleStr = "♂";
			}
			var vipLevel:int = data.fromVipLv;
			var roleName:String = data.fromName;
			var roleID:int = data.fromId;
			var vipStr:String = ChatSetUtil.getVipText(vipLevel);
			var fontColor:String;
			fontColor = "{#FFFF00|"
			msg = fontColor+maleStr+vipStr+"}"+fontColor+roleName+"|"+roleID+"}"+fontColor+"："+msg+"}";
			_richTextSp.addNewLine(msg,exeFunc,flyExeFunc,null);
			_scrollBar.updateSize(_richTextSp.viewHeight+5);
			_scrollBar.scrollToEnd();
		}
		
		/**
		 * 历史纪录中点击文本要触发的函数 
		 * @param obj
		 * 
		 */
		private function exeFunc(obj:Object):void{
			
		}
		
		/**
		 * 历史纪录中点击小图标要触发的函数 
		 * @param obj
		 * 
		 */
		private function flyExeFunc(obj:Object):void{
			
		}
		
	}
}
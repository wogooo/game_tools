package com.YFFramework.game.core.module.npc.view
{
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFScroller;
	import com.YFFramework.game.core.module.npc.manager.NPCBasicManager;
	import com.YFFramework.game.core.module.npc.model.NPCBasicVo;
	
	import flash.events.MouseEvent;
	
	/**npc聊天对话框  点击npc 弹出一个窗口表示npc 
	 * 2012-10-24 下午2:53:42
	 *@author yefeng
	 */
	public class NPCChatWindow extends GameWindow
	{
		private var _label:RichText;
		private var _scroller:YFScroller;
		
		protected var _btn:YFButton; 
		public function NPCChatWindow()
		{
			super(270, 350);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_label=new RichText();
			_scroller=new YFScroller(_label,_mHeight-_bgTop.height);
			addContent(_scroller,5,_bgBody.y+5);
			_label.width=_mWidth-5;
			///创建按钮
			_btn=new YFButton("完成");
			addContent(_btn,_mWidth-_btn.width-10,_mHeight-_btn.height-10);
			_closeBtn.visible=false;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_btn.addEventListener(MouseEvent.CLICK,onCloseBtn);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_btn.removeEventListener(MouseEvent.CLICK,onCloseBtn);
		}
		
		public function set text(value:String):void
		{
		//	_label.text=value;
			_label.setSimpleText(value);
			if(_label.height>_bgBody.height-10) _label.width=_mWidth-5-10;
			_scroller.updateView();
		}
		
		public function get text():String
		{
			return _label.text;
		}
		/**
		 * @param npcBasicId   设置npc默认对话
		 */		
		public function setText(npcBasicId:int):void
		{
			var npcBasicVo:NPCBasicVo=NPCBasicManager.Instance.getNPCBasicVo(npcBasicId);
			text=npcBasicVo.defaultWord;
		}
		
	}
}
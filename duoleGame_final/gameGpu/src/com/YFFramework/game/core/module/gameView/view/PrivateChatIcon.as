package com.YFFramework.game.core.module.gameView.view
{
	/**@author yefeng
	 * 2013 2013-6-27 上午11:20:35 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**场景显示的  好友 小图标      与 组队  图标 排成一行的图标
	 */	
	public class PrivateChatIcon extends AbsView
	{
		/**  私聊图标管理
		 */		
		private var _privateTalkRequestVo:PrivateTalkPlayerVo;
		private var _iconImage:IconImage;
		public function PrivateChatIcon(privateTalkVo:PrivateTalkPlayerVo)
		{
			_privateTalkRequestVo=privateTalkVo;
			super(false);
			
		}
		override protected function initUI():void
		{
			super.initUI();
			var bg:Sprite=ClassInstance.getInstance("friendPrivateTalkIconBg"); //场景好友小图标背景
			addChild(bg);
			_iconImage=new IconImage();
			addChild(_iconImage);
			
			var toolTip:String="与"+_privateTalkRequestVo.name+"聊天中";
			Xtip.registerTip(this,toolTip);
			var url:String=CharacterPointBasicManager.Instance.getFriendSceneIconURL(_privateTalkRequestVo.career,_privateTalkRequestVo.sex);
			_iconImage.url=url;
			
		}
		/** 数据
		 */		
		public function get privateTalkRequestVo():PrivateTalkPlayerVo
		{
			return _privateTalkRequestVo;
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_privateTalkRequestVo=null
			_iconImage=null;

		}
	}
}
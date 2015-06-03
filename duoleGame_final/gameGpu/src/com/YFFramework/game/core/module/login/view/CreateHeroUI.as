package com.YFFramework.game.core.module.login.view
{
	
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.RandomName;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.login.events.LoginEvent;
	import com.dolo.ui.controls.Alert;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	/** 创建新角色 UI
	 */	
	public class CreateHeroUI extends AbsView
	{
		private var _mc:MovieClip;
		/**名称是否可用
		 */		
		private var _canUse:Boolean;
		/**选中的性别
		 */		
		private var _sex:int;
		/**选中的 职业
		 */ 
//		private var _career:int;
		private var _name:String="";
		private var _selectUI:DisplayObject;
		private static const Glow:GlowFilter=new GlowFilter(0xFF0000,1,10,10,10);
		public function CreateHeroUI()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			///创建
			_mc=ClassInstance.getInstance("login_createMc");
			addChild(_mc);
			_canUse=false;
			TextField(_mc.nameInput).maxChars=7;
		}
		private function set select(value:DisplayObject):void
		{
			if(_selectUI)_selectUI.filters=[]
			_selectUI=value;
			_selectUI.filters=[Glow];
			
		}
		private function get select():DisplayObject
		{
			return _selectUI;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_mc.sex_0.addEventListener(MouseEvent.CLICK,onClick);
			_mc.sex_1.addEventListener(MouseEvent.CLICK,onClick);
			_mc.intobtn.addEventListener(MouseEvent.CLICK,onLogin);
			TextField(_mc.nameInput).addEventListener(Event.CHANGE,onTextChange);
			_mc.randomBtn.addEventListener(MouseEvent.CLICK,onRadomName);  ///随机名称
			onTextChange();
			
//			_career=TypeRole.CAREER_NEWHAND;
			_sex=TypeRole.Sex_Man;
			onRadomName();
			select=_mc.sex_0;
		}
		private function onRadomName(e:MouseEvent=null):void
		{
			_mc.nameInput.text=RandomName.getName(_sex);
			onTextChange();
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_mc.intobtn.removeEventListener(MouseEvent.CLICK,onLogin);
			TextField(_mc.nameInput).removeEventListener(Event.CHANGE,onTextChange);
			_mc.randomBtn.removeEventListener(MouseEvent.CLICK,onRadomName);  ///随机名称
			
			_mc.sex_0.removeEventListener(MouseEvent.CLICK,onClick);
			_mc.sex_1.removeEventListener(MouseEvent.CLICK,onClick);

		}
		private function onTextChange(e:Event=null):void
		{
			_name=StringUtil.trim(_mc.nameInput.text);
			noticeCheckName(_name);
		}
		private function noticeCheckName(name:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(LoginEvent.C_CheckName,name);
		}
		/**选取性别
		 */		
		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _mc.sex_0:  ///男
					_sex=TypeRole.Sex_Man;
					break;
				case _mc.sex_1: ///女
					_sex=TypeRole.Sex_Woman;
					break;
			}
			select=e.currentTarget as DisplayObject;
		}
		
		private function sendLogin():void
		{
			YFEventCenter.Instance.dispatchEventWith(LoginEvent.C_CreateHero,{sex:_sex,name:_name});		
		}
		private function onLogin(e:MouseEvent):void
		{
			if(_canUse)
			{
				sendLogin();
			}
			else Alert.show("名称已经存在");
		}
		
		/**检测名字是否可用
		 */		
		public function updateNameCanUse(canUse:Boolean):void
		{
			_canUse=canUse;
			_mc.errorMc.visible=!_canUse;
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
//			_mc=null;
			_name=null;
		}
		

	}
}
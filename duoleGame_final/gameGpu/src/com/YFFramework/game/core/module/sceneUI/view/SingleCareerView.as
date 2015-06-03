package com.YFFramework.game.core.module.sceneUI.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.npc.events.NPCEvent;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 转职界面里单个选择按钮
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-29 下午3:46:43
	 */
	public class SingleCareerView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		private var _woman:Sprite;
		private var _man:Sprite;
		private var _btn:ToggleButton;
		
		private var _career:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function SingleCareerView(mc:MovieClip,career:int)
		{
			_mc=mc;
			_career=career;
			_woman=Xdis.getChild(mc,"woman");
			_man=Xdis.getChild(mc,"man");
			_btn=Xdis.getChild(mc,"c_toggleButton");
			_btn.alwaysSelectedEffect=true;
			_btn.addEventListener(Event.CHANGE,onSelectCareer);
			
			if(DataCenter.Instance.roleSelfVo.roleDyVo.sex == TypeProps.GENDER_FEMALE)
				_man.visible=false;
			else
				_woman.visible=false;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function dispose():void
		{
			UI.removeAllChilds(_mc);
			_woman=null;
			_man=null;
			_btn.removeEventListener(Event.CHANGE,onSelectCareer);
			_btn=null;
		}
		
		public function get btn():ToggleButton
		{
			return _btn;
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function onSelectCareer(e:Event):void
		{
			if(_btn.selected)
			{
				YFEventCenter.Instance.dispatchEventWith(NPCEvent.selectCareer,_career);
			}
		}		

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 
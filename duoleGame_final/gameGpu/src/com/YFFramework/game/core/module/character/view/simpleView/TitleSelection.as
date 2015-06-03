package com.YFFramework.game.core.module.character.view.simpleView
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.dolo.ui.controls.ToggleButton;
	
	import flash.events.Event;

	/**
	 * 点击某个称号类别，右边显示该类别下的所有称号
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-21 上午11:16:55
	 */
	public class TitleSelection
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _btn:ToggleButton;
		private var _titleType:int;
		private var _pageControl:TitlePageControl;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TitleSelection(type:int,btn:ToggleButton,page:TitlePageControl)
		{
			_titleType=type;
			_btn=btn;
			_pageControl=page;
			_btn.addEventListener(Event.CHANGE,updateTitleType);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		private function updateTitleType(e:Event=null):void
		{
			if(_btn.select)
			{
				_pageControl.updateList(_titleType);
				YFEventCenter.Instance.dispatchEventWith(CharacterEvent.title_type_change,_titleType-1);
			}		
		}

		public function get btn():ToggleButton
		{
			return _btn;
		}

		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 
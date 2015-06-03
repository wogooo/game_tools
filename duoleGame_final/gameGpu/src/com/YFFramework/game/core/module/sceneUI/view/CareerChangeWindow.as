package com.YFFramework.game.core.module.sceneUI.view
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-29 下午4:55:47
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.npc.events.NPCEvent;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CareerChangeWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;		
		private var _careers:Vector.<SingleCareerView>;
		private var _randomCareer:SimpleButton;
		private var _confirmBtn:SimpleButton;
		
		private var _career:int;
		private static var _instance:CareerChangeWindow;
		private var _taskHandleVo:TaskNPCHandleVo;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function CareerChangeWindow(backgroundBgId:int=0)
		{
			closeButton.visible=false;
			_mc = initByArgument(1140,550,"changeCareerWindow",WindowTittleName.titleChangeCareer) as MovieClip;
			setContentXY(35,45);
			
			_careers=new Vector.<SingleCareerView>();
			var career:SingleCareerView;
			for(var i:int=1;i<=5;i++)
			{
				career=new SingleCareerView(Xdis.getChild(_mc,"career"+i),i);
				_careers.push(career);
			}
			
			_randomCareer=Xdis.getChild(_mc,"randomCareer");
			_randomCareer.addEventListener(MouseEvent.CLICK,onRandomCareer);
			
			_confirmBtn=Xdis.getChild(_mc,"confirmBtn");
			_confirmBtn.addEventListener(MouseEvent.CLICK,onConfirmCareer);
			
			YFEventCenter.Instance.addEventListener(NPCEvent.selectCareer,onSelectCareer);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function open():void
		{
			PopUpManager.addPopUp(this,null,0,0,0x000000,0.01);
			initPos();
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,initPos);
			onRandomCareer();
		}
		
		override public function dispose():void
		{
			PopUpManager.removePopUp(this);
			StageProxy.Instance.setNoneFocus();
			super.dispose();
			for(var i:int=0;i<5;i++)
			{
				_careers[i].dispose();
			}
			_randomCareer.removeEventListener(MouseEvent.CLICK,onRandomCareer);
			_confirmBtn.removeEventListener(MouseEvent.CLICK,onConfirmCareer);
			YFEventCenter.Instance.removeEventListener(NPCEvent.selectCareer,onSelectCareer);
			StageProxy.Instance.stage.removeEventListener(Event.RESIZE,initPos);
		}
		
		public static function get instance():CareerChangeWindow
		{
			if(_instance ==null) _instance=new CareerChangeWindow();
			return _instance;
		}
		
		/**调用传入的数据  用于完成任务 */
		public function get taskHandleVo():TaskNPCHandleVo
		{
			return _taskHandleVo;
		}
		
		/**传入的数据  用于完成任务 */
		public function set taskHandleVo(value:TaskNPCHandleVo):void
		{
			_taskHandleVo = value;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function initPos(e:Event=null):void
		{
			PopUpManager.centerPopUp(this);
		}
		
		private function onSelectCareer(e:YFEvent):void
		{
			_career=e.param as int;
			disabledBtn(_career-1);
		}
		
		private function onRandomCareer(e:MouseEvent=null):void
		{
			if(_career == 0)
				_career=Math.round(Math.random()*(5-1)) +1;
			else
			{
				var career:int=Math.round(Math.random()*(5-1)) +1;
				if(_career == career)//用于每次随机出来的数字都不一样
				{
					_career = career +1;
					if(_career > 5)
						_career = 1;
				}
				_career=career;
			}
			_careers[_career-1].btn.selected=true;
		}
		
		private function onConfirmCareer(e:MouseEvent):void
		{
			ModuleManager.moduleNPC.selectCareer(_career);
		}

		/**index选中，其他按钮都不选中*/
		private function disabledBtn(index:int):void
		{
			for(var i:int=0;i<5;i++)
			{
				if(i != index)
				{
					_careers[i].btn.selected=false;
				}
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 
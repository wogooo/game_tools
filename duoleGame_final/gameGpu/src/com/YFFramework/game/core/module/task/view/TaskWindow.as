package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.MovieClipTabs;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**任务面板 
	 * @author flashk
	 */
	public class TaskWindow extends Window{
		
		private static var _ins:TaskWindow;
		
		private var _ui:Sprite;
		private var _tabs:MovieClipTabs;
		private var _nowCOL:NowTaskCOL;
		private var _ableCOL:AbleTaskCOL;
		
		public function TaskWindow(){
			_ins = this;
			_ui = initByArgument(450,500,"TaskWindowUI",WindowTittleName.taskTitle);
			_tabs = new MovieClipTabs();
			_tabs.isRemoveChild = false;
			_tabs.initTabs(_ui,"tabs_mc",2);
			_nowCOL = new NowTaskCOL(_tabs.getViewAt(0) as Sprite);
			_ableCOL = new AbleTaskCOL(_tabs.getViewAt(1) as Sprite);
		}
		
		public function get tabs():MovieClipTabs{
			return _tabs;
		}

		public function get ableCOL():AbleTaskCOL{
			return _ableCOL;
		}

		public function get nowCOL():NowTaskCOL{
			return _nowCOL;
		}

		public static function getInstance():TaskWindow{
			return _ins ||= new TaskWindow();
		}
		
		override public function close(event:Event=null):void{
			closeTo(TaskMiniPanel.getInstance().x + 210,TaskMiniPanel.getInstance().y+10,0.04,0.02);
		}
	}
}
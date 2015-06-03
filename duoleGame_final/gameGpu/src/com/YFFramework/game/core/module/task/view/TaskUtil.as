package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.game.core.module.task.model.TypeTask;
	import com.dolo.ui.tools.HTMLFormat;

	public class TaskUtil
	{
		public function TaskUtil()
		{
		}
		public static function getTypeString(type:int):String
		{
			var str:String = "";
			//TASK_TYPE_TRUNK       = 1;     // 主线
			//TASK_TYPE_BRANCH      = 2;     // 支线
			//TASK_TYPE_LOOP        = 3;     // 循环
			switch(type)
			{
				case TypeTask.TASK_TYPE_TRUNK:
					str = "{#55FC68|[主]}";
					break;
				case TypeTask.TASK_TYPE_BRANCH:
					str =  "{#55FC68|[支]}";
					break;
				case TypeTask.TASK_TYPE_LOOP:
					str = "{#55FC68|[循]}";
					break;
				case TypeTask.TASK_TYPE_RUN:
					str = "{#55FC68|[环]}";
					break;
				default:
					break;
			}
			return str;
		}
	}
}
package com.YFFramework.core.text
{
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**获取表情信息  将表情转化为actionData
	 * @author yefeng
	 * 2013 2013-5-31 下午6:11:42 
	 */
	public class FaceDataManager
	{
		
		private var _cache:Dictionary;
		private static var _instance:FaceDataManager;
		public function FaceDataManager()
		{
			_cache=new Dictionary();
		}
		public static function get Instance():FaceDataManager
		{
			if(_instance==null)_instance=new FaceDataManager();
			return _instance;
		}
		/** 获取表情数据   
		 * @param className	  表情名称  a0  ----a71
		 */		
		private function getActionData(className:String):ActionData
		{
			var actionData:ActionData=_cache[className];
			if(!actionData)
			{
				var mc:MovieClip=ClassInstance.getInstance(className);
				actionData=Cast.FaceMCToActionData(mc,28);
				_cache[className]=actionData;
			}
			return actionData;
		}
		public function getMovieClipPlayer(className:String,frameRate:int):MovieClipPlayer
		{
			var mc:MovieClip=ClassInstance.getInstance(className);
			var movie:MovieClipPlayer=new MovieClipPlayer(mc,frameRate);
			return movie;
		}
	}
}
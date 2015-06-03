package com.YFFramework.game.core.module.story.manager
{
	import com.YFFramework.game.core.module.story.model.StoryBasicVo;
	
	import flash.utils.Dictionary;

	public class StoryBasicManager
	{
		private static var _instance:StoryBasicManager;
		private var _dict:Dictionary;
		public function StoryBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():StoryBasicManager
		{
			if(_instance==null)_instance=new StoryBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var storyBasicVo:StoryBasicVo;
			for (var id:String in jsonData)
			{
				storyBasicVo=new StoryBasicVo();
				storyBasicVo.movie_id=jsonData[id].movie_id;
				storyBasicVo.operaID=jsonData[id].operaID;
				storyBasicVo.text=jsonData[id].text;
				storyBasicVo.type=jsonData[id].type;
				storyBasicVo.movie_time=jsonData[id].movie_time;
				storyBasicVo.NPC_id=jsonData[id].NPC_id;
				storyBasicVo.next_id=jsonData[id].next_id;
				storyBasicVo.storyID=jsonData[id].storyID;
				storyBasicVo.player_type=jsonData[id].player_type;
				if(!_dict[storyBasicVo.storyID])
				{
					_dict[storyBasicVo.storyID]=new Vector.<StoryBasicVo>;
				}
				(_dict[storyBasicVo.storyID] as Vector.<StoryBasicVo>).push(storyBasicVo);
			}
		}
		public function getStoryBasicVo(storyID:int):Vector.<StoryBasicVo>
		{
			return _dict[storyID];
		}
	}
}
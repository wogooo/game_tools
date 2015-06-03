package com.YFFramework.game.core.module.story.model
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;

	public class StoryBasicVo
	{

		public var movie_id:int;
		public var operaID:int;
		private var _text:String;
		public var type:int;
		public var movie_time:int;
		public var NPC_id:int;
		public var next_id:int;
		public var storyID:int;
		
		/**类型   0 代表自己  1 代表npc 2  代表 怪物值 在typeStory里面
		 */
		public var player_type:int;

		public function StoryBasicVo()
		{
		}
		
		public function get text():String
		{
			var roleName:String=DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
			var petName:String="  ";
			if(PetDyManager.fightPetId!=0)
				petName=PetDyManager.Instance.getFightPetDyVo().roleName;
			var txt:String=_text.replace(Name,roleName);
			return txt.replace(Pet,petName);
		}

		public function set text(value:String):void
		{
			_text = value;
		}
		
		public static const Name:RegExp=/&name/g;
		public static const Pet:RegExp=/&pet/g;

	}
}
package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.core.global.model.CharacterPointBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	
	import flash.utils.Dictionary;

	/** 缓存CharacterConfig.json
	 */
	public class CharacterPointBasicManager
	{
		private static var _instance:CharacterPointBasicManager;
		private var _dict:Dictionary;
		public function CharacterPointBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():CharacterPointBasicManager
		{
			if(_instance==null)_instance=new CharacterPointBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var characterConfigBasicVo:CharacterPointBasicVo;
			for (var id:String in jsonData)
			{
				characterConfigBasicVo=new CharacterPointBasicVo();
				characterConfigBasicVo.profession=jsonData[id].profession;
				characterConfigBasicVo.int_add=jsonData[id].int_add;
				characterConfigBasicVo.spi_add=jsonData[id].spi_add;
				characterConfigBasicVo.agi_add=jsonData[id].agi_add;
				characterConfigBasicVo.phy_add=jsonData[id].phy_add;
				characterConfigBasicVo.str_add=jsonData[id].str_add;
//				characterConfigBasicVo.male_ShowId=jsonData[id].male_ShowId;
//				characterConfigBasicVo.female_ShowId=jsonData[id].female_ShowId;
				characterConfigBasicVo.maleIcon=jsonData[id].maleIcon;
				characterConfigBasicVo.femaleIcon=jsonData[id].femaleIcon;
//				characterConfigBasicVo.maleTeamIcon=jsonData[id].male_TeamId;
//				characterConfigBasicVo.femaleTeamIcon=jsonData[id].female_TeamId;
				_dict[characterConfigBasicVo.profession]=characterConfigBasicVo;
			}
			
		}
		public function getCharacterConfigBasicVo(profession:int):CharacterPointBasicVo
		{
			return _dict[profession];
		}
		/**人物图像 大图标   左上角的图标 
		 * career  职业 profession
		 *  sex 性别
		 */		
		public function getShowURL(career:int,sex:int):String
		{
			var characterPointBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarShowIcon(characterPointBasicVo.maleIcon);
			else str=URLTool.getAvatarShowIcon(characterPointBasicVo.femaleIcon);
			return str;
		}
		/**人物图像 小图标    队友列表中的小图标  
		 * career  职业 profession
		 *  sex 性别
		 */		
		public function getTeamSmallIconURL(career:int,sex:int):String
		{
			var characterPointBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarTeamSmallIcon(characterPointBasicVo.maleIcon);
			else str=URLTool.getAvatarTeamSmallIcon(characterPointBasicVo.femaleIcon);
			return str;
		}
		
		/**人物中图像，组队场景组件需要    队友图标 场景 中左边 ，队友列表  从上到下排列的图标
		 * @param career	职业
		 * @param sex		性别
		 * @return String	图标地址
		 */		
		public function getTeamSceneIconURL(career:int,sex:int):String{
			var charBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarTeamSceneIcon(charBasicVo.maleIcon);
			else str=URLTool.getAvatarTeamSceneIcon(charBasicVo.femaleIcon);
			return str;
		}
		/** 获取 好友面板的图标
		 */		
		public function getFriendIconURL(career:int,sex:int):String
		{
			var charBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarFriendIcon(charBasicVo.maleIcon);
			else str=URLTool.getAvatarFriendIcon(charBasicVo.femaleIcon);
			return str;
		}
		/** 获取 好友面板的左上角大图标
		 */		
		public function getFriendBigIconURL(career:int,sex:int):String
		{
			var charBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarFriendBigIcon(charBasicVo.maleIcon);
			else str=URLTool.getAvatarFriendBigIcon(charBasicVo.femaleIcon);
			return str;
		}
		/** 获取 场景 好友聊天图标
		 */		
		public function getFriendSceneIconURL(career:int,sex:int):String
		{
			var charBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarFriendSceneIcon(charBasicVo.maleIcon);
			else str=URLTool.getAvatarFriendSceneIcon(charBasicVo.femaleIcon);
			return str;
		}

		/**获取主角的半身像
		 */
		public function getCharactorHalfIcon(career:int,sex:int):String
		{
			var charBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarHalfIcon(charBasicVo.maleIcon);
			else str=URLTool.getAvatarHalfIcon(charBasicVo.femaleIcon);
			return str;
		}

		
		
	}
}
package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.model.CharacterPointBasicVo;
	
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
				characterConfigBasicVo.male_ShowId=jsonData[id].male_ShowId;
				characterConfigBasicVo.female_ShowId=jsonData[id].female_ShowId;
				characterConfigBasicVo.maleIcon=jsonData[id].maleIcon;
				characterConfigBasicVo.femaleIcon=jsonData[id].femaleIcon;
				characterConfigBasicVo.maleTeamIcon=jsonData[id].male_TeamId;
				characterConfigBasicVo.femaleTeamIcon=jsonData[id].female_TeamId;
				_dict[characterConfigBasicVo.profession]=characterConfigBasicVo;
			}
			
		}
		public function getCharacterConfigBasicVo(profession:int):CharacterPointBasicVo
		{
			return _dict[profession];
		}
		/**人物图像 大图标
		 * career  职业 profession
		 *  sex 性别
		 */		
		public function getShowURL(career:int,sex:int):String
		{
			var characterPointBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarIcon(characterPointBasicVo.male_ShowId);
			else str=URLTool.getAvatarIcon(characterPointBasicVo.female_ShowId);
			return str;
		}
		/**人物图像 小图标
		 * career  职业 profession
		 *  sex 性别
		 */		
		public function getIconURL(career:int,sex:int):String
		{
			var characterPointBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarIcon(characterPointBasicVo.maleIcon);
			else str=URLTool.getAvatarIcon(characterPointBasicVo.femaleIcon);
			return str;
		}
		
		/**人物中图像，组队场景组件需要 
		 * @param career	职业
		 * @param sex		性别
		 * @return String	图标地址
		 */		
		public function getTeamIconURL(career:int,sex:int):String{
			var charBasicVo:CharacterPointBasicVo=getCharacterConfigBasicVo(career);
			var str:String="";
			if(sex==TypeRole.Sex_Man)str=URLTool.getAvatarIcon(charBasicVo.maleTeamIcon);
			else str=URLTool.getAvatarIcon(charBasicVo.femaleTeamIcon);
			return str;
		}
		
	}
}
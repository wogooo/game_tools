package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.ConfigDataVo;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.pet.model.PetConfig;
	
	import flash.utils.Dictionary;

	public class ConfigDataManager
	{
		private static var _instance:ConfigDataManager;
		private var _dict:Dictionary;
		public function ConfigDataManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():ConfigDataManager
		{
			if(_instance==null)_instance=new ConfigDataManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var config_DataBasicVo:ConfigDataVo;
			for (var id:String in jsonData)
			{
				config_DataBasicVo=new ConfigDataVo();
				config_DataBasicVo.config_value=jsonData[id].config_value;
				config_DataBasicVo.config_key=jsonData[id].config_key;
				_dict[config_DataBasicVo.config_key]=config_DataBasicVo;
				setConfig(config_DataBasicVo);
			}
		}
		/**
		 *去对应的配置数据 
		 * @param config_key 对应的字段
		 * @return 
		 * 
		 */		
		public function getConfigData(config_key:String):ConfigDataVo
		{
			return _dict[config_key];
		}
		private function setConfig(data:ConfigDataVo):void
		{
			switch(data.config_key)
			{
				case "pet_default_skill":
					PetConfig.pet_default_skill=data.config_value;
					break;
				case "pet_inherit_cost":
					PetConfig.pet_inherit_cost=data.config_value;
					break;
				case "pet_sophi_cost":
					PetConfig.pet_sophi_cost=data.config_value;
					break;
				case "pet_skill_slot_cost":
					PetConfig.pet_skill_slot_cost=data.config_value;
					break;
				case "guild_create_level":
					GuildConfig.GuildMinCreateLv=data.config_value;
					break;
				case "guild_enter_level":
					GuildConfig.GuildMinEnterLv=data.config_value;
					break;
				case "guild_create_cost":
					GuildConfig.GuildCreaeMoney=data.config_value;
					break;
				case "guild_accuse_cost":
					GuildConfig.ImpeachNeedContribution=data.config_value;
					break;
				case "guild_donate_contribution":
					GuildConfig.EachItemGetContribution=data.config_value;
					break;
				case "guild_donate_money":
					GuildConfig.EachItemGetMoney=data.config_value;
					break;
			}
		}
	}
}
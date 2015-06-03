package com.YFFramework.game.core.module.skill.mamanger
{
	import com.YFFramework.game.core.module.skill.model.QuickBoxDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	
	import flash.utils.Dictionary;

	/** 快捷栏管理器 
	 * @author yefeng
	 * 2013 2013-7-25 上午10:48:20 
	 */
	public class QuickBoxManager
	{
		/**以格子位置作为键值   key_id 从  1   到 20 
		 */		
		private var dict:Dictionary;
		
		private static var _instance:QuickBoxManager;
		public function QuickBoxManager()
		{
			dict=new Dictionary();
		}
	
		public static function get Instance():QuickBoxManager
		{
			if(!_instance)_instance=new QuickBoxManager();
			return _instance;
		}
		public function addQuickBoxDyVo(quickBoxDyVo:QuickBoxDyVo):void
		{
			dict[quickBoxDyVo.key_id]=quickBoxDyVo;
		}
		public function removeQuickBoxDyVo(key_id:int):void
		{
			var quickBoxDyVo:QuickBoxDyVo=getQuickBoxDyVoByKeyId(key_id);
			if(quickBoxDyVo)
			{
				delete 	dict[quickBoxDyVo.key_id];
			}
		}
		/**通过位置 获取 数据
		 */		
		public function getQuickBoxDyVoByKeyId(key_id:int):QuickBoxDyVo
		{
			return dict[key_id];
		}
		
		/**通过  静态id 获取数据
		 */		
		public function getQuickBoxDyVoId(type:int,id:int):QuickBoxDyVo
		{
			for each(var quickBoxDyVo:QuickBoxDyVo in dict)
			{
				if(quickBoxDyVo.type==type&&quickBoxDyVo.id==id)
				{
					return quickBoxDyVo;
				}
			}
			return null;
		}
		
		/**更新新的位置
		 * type  为 0 则进行删除
		 */		
		public function updateQuickBoxPosition(type:int,id:int,newKeyId:int):void
		{
			var quickBoxDyVo:QuickBoxDyVo;
			if(type!=SkillModuleType.QuickType_BT_NONE)  //存在数据
			{
				if(newKeyId!=-1)
				{
					removeQuickBoxDyVo(newKeyId);
					
					quickBoxDyVo=new QuickBoxDyVo(); 
					quickBoxDyVo.key_id=newKeyId;
					quickBoxDyVo.id=id;
					quickBoxDyVo.type=type;
					addQuickBoxDyVo(quickBoxDyVo);
				}
				else //如果为-1 则表示该格子已经清空
				{
					quickBoxDyVo=getQuickBoxDyVoId(type,id);
					if(quickBoxDyVo)
					{
						removeQuickBoxDyVo(quickBoxDyVo.key_id);
					}
				}
			}
			else  //不存在数据
			{
				if(newKeyId!=-1)
				{
					quickBoxDyVo=getQuickBoxDyVoByKeyId(newKeyId);
					if(quickBoxDyVo)//更新
					{
						removeQuickBoxDyVo(quickBoxDyVo.key_id);
					}
				}
			}
		}
		
		/**初始化所有的信息
		 */		
		public function initQuickBoxInfo(type:int,id:int,newKeyId:int):void
		{
			var quickBox:QuickBoxDyVo=new QuickBoxDyVo();
			quickBox.id=id;
			quickBox.type=type;
			quickBox.key_id=newKeyId;
			addQuickBoxDyVo(quickBox);
		}
		
		public function getDict():Dictionary
		{
			return dict;
		}
		/**技能洗点清除
		 */		
		public function clearSkill():void
		{
			for each(var quickBox:QuickBoxDyVo in dict)
			{
				if(quickBox.type==SkillModuleType.QuickType_BT_SKILL) //技能类型
				{
					delete 	dict[quickBox.key_id];
				}
			}
		}
		
		
	}
}
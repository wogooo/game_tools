package com.YFFramework.game.core.module.skill.mamanger
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	
	import flash.utils.Dictionary;

	/**@author yefeng
	 * 2013 2013-7-26 上午11:57:57 
	 */
	public class SKillCDViewManager
	{
		
		private var _cdList:Dictionary;
		private static var _instance:SKillCDViewManager;
		public function SKillCDViewManager()
		{
			_cdList=new Dictionary();
		}
		public static function get Instance():SKillCDViewManager
		{
			if(!_instance)_instance=new SKillCDViewManager();
			return _instance;
		}
		public function addCD(cdType:int,cd:YFCD):void
		{
			if(cd)
			{
				if(_cdList[cdType]==null)
				{
					_cdList[cdType]=cd.clone(completePlayCD,cdType);
					
//					trace("添加技能cd",cdType);        

				}
			} 
		} 
		
		public function playCD(skillBasicVo:SkillBasicVo):void 
		{
			if(_cdList[skillBasicVo.skill_id]==null)
			{
				var cd:YFCD=new YFCD(40,40);
				cd.start();
				cd.play(SkillBasicVo.CommonCDTime,0,false,completePlayCD,skillBasicVo.skill_id);
				_cdList[skillBasicVo.skill_id]=cd;
				
//				trace("播放技能cd",skillBasicVo.skill_id);        

			}
		}
		
		
		private function completePlayCD(cdType:int):void
		{
			var cd:YFCD=_cdList[cdType];
			if(cd)
			{
				if(cd.parent) cd.parent.removeChild(cd);
				cd.dispose();
			}
			_cdList[cdType]=null;	
			delete _cdList[cdType];
//			trace("删除技能cd",cdType);
		}
		public function getCd(cdType:int):YFCD
		{
			if(_cdList[cdType])
				return (_cdList[cdType] as YFCD).clone();
			
			return null;
		}

	}
}
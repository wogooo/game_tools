package com.YFFramework.game.core.global.view.tips
{
	import flash.display.DisplayObject;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-20 下午5:32:46
	 * 
	 */
	public class TipUtil
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TipUtil()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 
		 * @param tipToggle 要触发显示tip的类
		 * @param tip 
		 * @param propsId 没有就为0
		 * @param templateId
		 * 
		 */		
		public static function propsTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,propsId:int=0,templateId:int=0):void
		{
			PropsTip(tipToggle).setTip([propsId,templateId]);
		}
		
		/**
		 *  
		 * @param tipToggle 要触发显示tip的类
		 * @param tip
		 * @param equipId
		 * @param templateId
		 * @param inCharacter 要区分是否在人物面板
		 * 
		 */		
		public static function equipTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,equipId:int=0,templateId:int=0,inCharacter:Boolean=false):void
		{
			EquipTip(tipToggle).setTip([equipId,templateId,inCharacter])
		}
		
		/**
		 *  
		 * @param tipToggle 要触发显示tip的类
		 * @param tip
		 * @param templateId
		 * @param level
		 * @param isSimple 是否是简略技能信息显示（在快捷栏是显示简略信息的）
		 * 
		 */		
		public static function skillTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,templateId:int=0,level:int=0,isSimple:Boolean=false):void
		{
			SkillTip(tipToggle).setTip([templateId,level,isSimple]);
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 
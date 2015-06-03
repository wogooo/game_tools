package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.mapScence.model.BuffDyVo;
	import com.dolo.common.ObjectPool;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-20 下午5:32:46
	 * 
	 */
	public class TipUtil
	{
		
		private static var _backgroundPool:ObjectPool;

		public static function get tipBackgrounPool():ObjectPool
		{
			if(_backgroundPool == null){
				var classRef:Class = getDefinitionByName("skin_minWindow") as Class;
				_backgroundPool = new ObjectPool(classRef);
			}
			return _backgroundPool;
		}
		
		private static var _hasOnPool:ObjectPool;
		
		public static function get hasOnPool():ObjectPool
		{
			if(_hasOnPool == null){
				var classRef:Class = getDefinitionByName("bagUI_equiped") as Class;
				_hasOnPool = new ObjectPool(classRef);
			}
			return _hasOnPool;
		}
		
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
		 * @param otherProps 可指定显示道具内容（与propsId互斥条件）
		 * @param isClose 是否有关闭按钮，默认是没有（false）
		 * @param shopBind 是不是要读商店表里的绑定性数据
		 */		
		public static function propsTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,propsId:int=0,templateId:int=0,
												otherProps:PropsDyVo=null,isClose:Boolean=false,shopBind:int=0):void
		{
			PropsTip(tipToggle).setTip([propsId,templateId,otherProps,isClose,shopBind]);
		}
		
		/**
		 * 
		 * @param tipToggle 要触发显示tip的类
		 * @param tip
		 * @param equipId1 当前装备dyId
		 * @param templateId1 当前装备模板Id
		 * @param inCharacter 是否在角色面板里
		 * @param otherEquip 查询其他玩家（如果有这一项，equipId1要设置为0）
		 * @param isClose 是否有关闭按钮，默认是没有（false）
		 * @param shopBind 是不是要读商店表的数据
		 */	
		public static function equipTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,equipId1:int=0,templateId1:int=0,
												inCharacter:Boolean=false,otherEquip:EquipDyVo=null,isClose:Boolean=false,
												shopBind:int=0):void
		{
			EquipTipMix.initTip([equipId1,templateId1,inCharacter,tipToggle,otherEquip,isClose,shopBind])
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
		
		public static function raidTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,raidArr:Array):void{
			RaidTip(tipToggle).setTip(raidArr);
		}
		/**
		 *公会建筑Tip 
		 * @param tipToggle
		 * @param tip
		 * @param type(建筑类型)
		 * 
		 */		
		public static function buildingTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,type:int):void
		{
			GuildBuildingTip(tipToggle).setTip(type);
		}
		
		/**
		 *在线奖励Tip 
		 * @param tipToggle
		 * @param tip
		 * 
		 */		
		public static function onlineRewardTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject):void
		{
			OnlineRewardTip(tipToggle).setTip();
		}
		
		/**血量条挂机tip 
		 * @param tipToggle
		 * @param tip
		 * @param percent
		 * @param name
		 * @param drug
		 */		
		public static function autoHealInitFunc(tipToggle:DisplayObject,tip:DisplayObject,percent:int,name:String,drug:String):void{
			AutoHealTip(tipToggle).setTip(percent,name,drug);
		}
		
		/**血池篮池挂机tip
		 * @param tipToggle
		 * @param tip
		 * @param pool
		 */		
		public static function autoPoolInitFunc(tipToggle:DisplayObject,tip:DisplayObject,type:int):void{
			AutoHealTip(tipToggle).setPoolTip(type);
		}
		
		/**
		 * 人物buff的tip
		 * @param tipToggle
		 * @param tip
		 * @param buffBsVo
		 * @param buffDyVo
		 * @param skillBsVo
		 */		
		public static function buffTipInitFunc(tipToggle:DisplayObject,tip:DisplayObject,buffBsVo:BuffBasicVo,buffDyVo:BuffDyVo):void
		{
			BuffTip(tipToggle).setTip(buffBsVo,buffDyVo);
		}
		
		/**
		 * 时间开启格子时间tip
		 * @param tipToggle
		 * @param tip
		 * 
		 */		
		public static function openCellInitFunc(tipToggle:DisplayObject,tip:DisplayObject):void
		{
			OpenCellTip(tipToggle).setTip();
		}
	}
} 
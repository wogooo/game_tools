package com.YFFramework.game.core.module.autoSetting.manager
{
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.autoSetting.model.FlushUnitVo;
	import com.YFFramework.game.core.module.autoSetting.source.AutoSource;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-20 下午2:20:17
	 */
	public class FlushUnitManager{
		
		private static var instance:FlushUnitManager;
		private var _dict:Dictionary = new Dictionary();
		
		public function FlushUnitManager(){
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var vo:FlushUnitVo = new FlushUnitVo();
				vo.canView = jsonData[id].can_view;
				vo.flushId = jsonData[id].flush_id;
				vo.unitId1 = jsonData[id].unit_id1;
				vo.unitType1 = jsonData[id].unit_type1;
				
				_dict[vo.flushId] = vo;
			}
		}
		
		/**获得monster id（会做校验）
		 * @param flushId
		 * @return 
		 */		
		public function getMonsterId(flushId:int):int{
			if(_dict[flushId].unitType1==AutoSource.FLUSH_UNIT_TYPE_MONSTER && _dict[flushId].canView==AutoSource.CAN_VIEW){
				return _dict[flushId].unitId1;
			}
			return 0;
		}
		
		/**
		 *取对应的怪物ID，不做校验 
		 * @param flushId
		 * @return 
		 * 
		 */		
		public function getMonster(flushId:int):int
		{
			var vo:FlushUnitVo=_dict[flushId];
			if(vo)
				return vo.unitId1;
			return 0;
		}
		
		/**获取flush unit vo
		 * @param flushId
		 * @return 
		 */		
		public function getFlushUnitVo(flushId:int):FlushUnitVo{
			if(_dict[flushId].unitType1==AutoSource.FLUSH_UNIT_TYPE_MONSTER){
				return _dict[flushId];
			}
			return null;
		}
		
		public static function get Instance():FlushUnitManager{
			return instance ||= new FlushUnitManager();
		}
	}
} 
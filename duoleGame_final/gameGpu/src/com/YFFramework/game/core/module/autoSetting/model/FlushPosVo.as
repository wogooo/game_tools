package com.YFFramework.game.core.module.autoSetting.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-7-20 下午2:20:33
	 */
	public class FlushPosVo{
		
		public var id:int; 			//自增id
		public var flushId:int;
		public var flushX:int;
		public var flushY:int;
		public var sceneId:int;		//type为2的时候，sceneId代表副本id
		public var sceneType:int;	//1普通；2副本
		
		public function FlushPosVo(){
		}
	}
}
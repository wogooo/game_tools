package com.YFFramework.game.core.module.growTask.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-7-15 下午4:56:21
	 */
	public class GrowTaskDyVo{
		
		/** 索引id */
		public var taskId:int;
		public var targetType:int;
		/** 目标id */		
		public var targetId:int;
		public var targetLevel:int;
		public var targetQuality:int;
		public var targetNumber:int;
		public var rewardId:int;
		public var taskDesc:String;
		public var iconId:int;
		/** 称号表里对应的id */		
		public var titleId:int;
		public var status:int=1;
		
		public function GrowTaskDyVo(){
		}
	}
} 
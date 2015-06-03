package com.YFFramework.game.core.module.raid.manager
{
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	
	import flash.utils.getTimer;

	/***
	 *副本动态信息类，主要保留当前副本的信息
	 *@author ludingchang 时间：2014-1-14 上午10:55:48
	 */
	public class RaidDyManager
	{
		private static var _inst:RaidDyManager;
		public static function get Instence():RaidDyManager
		{
			return _inst||=new RaidDyManager;
		}
		public function RaidDyManager()
		{
		}
		/**当前副本的副本VO*/
		public var currentRaid:RaidVo;
		/**当前副本敌人总数*/
		public var current_total_enemy:int;
		/**当前副本已经杀掉的敌人数*/
		public var current_killed_enemy:int;
		/**当前副本的总波数*/
		public var current_total_wave:int;
		/**当前副本的当前波次*/
		public var current_current_wave:int;
		/**当前副本下一波刷新的时间*/
		public var current_next_wave_time:int;
		/**副本剩余时间*/
		public var raid_rest_time:int;
		
		
		/**副本开始时间*/
		public var raid_start_time:int;
		/**本波开始时间*/
		public var wave_start_time:int;
		
		public function setWaveInfo(currt:int,total:int,waveTime:int):void
		{
			current_current_wave=currt;
			current_total_wave=total;
			current_next_wave_time=waveTime;
			if(waveTime>0)
				wave_start_time=getTimer();
			else
				wave_start_time=0;
			trace("total wave :"+total);
			trace("next wave time:"+waveTime);
		}
		
		public function raidStart():void
		{
			raid_start_time=getTimer();
		}
		
		/**副本剩余时间*/
		public function getRestTime():int
		{
			return raid_start_time+raid_rest_time*1000-getTimer();
		}
		
		/**是否显示剩余怪物数量*/
		public function shouldShowEnemy():Boolean
		{//刷波的副本不显示，其他都显示
			return current_total_wave==1;
		}
		
		/**剩余怪物数量*/
		public function aliveEnemyNum():int
		{
			return current_total_enemy-current_killed_enemy;
		}
		
		/**是否显示波数信息*/
		public function shouldShowWave():Boolean
		{
			return current_total_wave>1;
		}
		
		/**是否显示波数倒计时*/
		public function shouldShowWaveTime():Boolean
		{
			return current_next_wave_time>0
		}
		
		/**下一波怪出生的时间*/
		public function getNextWaveTime():int
		{
			return wave_start_time+current_next_wave_time*1000-getTimer();
		}
		
		/**重置*/
		public function reset():void
		{
			currentRaid=null;
			current_total_enemy=0;
			current_killed_enemy=0;
			current_current_wave=0;
			current_total_wave=0;
			current_next_wave_time=0;
			raid_start_time=0;
			wave_start_time=0;
		}
	}
}
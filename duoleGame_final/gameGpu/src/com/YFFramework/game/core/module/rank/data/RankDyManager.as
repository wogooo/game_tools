package com.YFFramework.game.core.module.rank.data
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.msg.rank_pro.RankInfo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-18 下午3:02:29
	 * 
	 */
	public class RankDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:RankDyManager;

		private var _dict:Dictionary;
		private var _myDict:Dictionary;
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RankDyManager()
		{
			_dict=new Dictionary();
			_myDict=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setRankInfo(type:int,data:Array):void
		{
			var ary:Array=[];
			
			var newRank:RankDyVo;
			for each(var rank:RankInfo in data)
			{
				newRank=new RankDyVo();
				newRank.rankConfigType=type;
				newRank.rankOrder=rank.rankOrder;
				newRank.playerName=rank.playerName;
				newRank.rankValue=rank.rankValue;
				newRank.guildName=rank.guildName;
				if(rank.hasVipLevel)
					newRank.vipLevel=rank.vipLevel;
				if(rank.hasVipType)
					newRank.vipType=rank.vipType;
				if(rank.hasCharacterId)
				{
					newRank.characterId=rank.characterId;
					if(newRank.characterId == DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
					{
						_myDict[type]=newRank.rankOrder;
						newRank.vipLevel=DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel;
						newRank.vipType=DataCenter.Instance.roleSelfVo.roleDyVo.vipType;
						if(type==RankSource.TITLE_ACTIVITY41)
							print(this,"收到服务器发来大乱斗排名:"+newRank.rankOrder);
					}
				}
				if(rank.hasPetId)
					newRank.petId=rank.petId;
				if(rank.hasPetConfigId)
					newRank.petConfigId=rank.petConfigId;
				if(rank.hasPlayerLevel)
					newRank.level=rank.playerLevel;
				if(rank.hasPetLevel)
					newRank.petLevel=rank.petLevel;
				if(rank.hasPlayerCareer)
					newRank.playerCareer=rank.playerCareer;
//				if(rank.)
				ary.push(newRank);
			}
			
			_dict[type]=ary;
			
		}
		
		public function getRankInfo(type:int):Array
		{
			return _dict[type];
		}
		
		public function getMyRankIndex(type:int):int
		{
			return _myDict[type];
		}
		
		/** 为称号成长任务准备的，取得自己的竞技积分 */
		public function getMyArenaScore(type:int):int
		{
			var ary:Array=_dict[type];
			if(ary == null)
				return 0;
			var index:int=_myDict[type];		
			var vo:RankDyVo=ary[index-1];
			if(vo == null)
				return 0;
			return vo.rankValue;
		}
		
		/** 有没有存这个信息
		 * @param subType
		 * @return 
		 * 
		 */		
		public function checkRankInfo(subType:int):Boolean
		{
			if(_dict[subType])
				return true;
			else
				return false;
		}
		
		/** 查询排行榜某角色详细信息 */
		public function getHeroRankInfo(playerId:int):RankDyVo
		{
			var ary:Array=_dict[RankSource.TITLE_POWER11];
			var hero:RankDyVo;
			for each(var vo:RankDyVo in ary)
			{
				if(vo.characterId == playerId)
				{
					hero=vo;
					break;
				}				
			}
			return hero;
		}
		
		/** 查询排行榜某宠物详细信息 */
		public function getPetRankInfo(petId:int):RankDyVo
		{
			var ary:Array=_dict[RankSource.TITLE_POWER12];
			var pet:RankDyVo;
			for each(var vo:RankDyVo in ary)
			{
				if(vo.petId == petId)
				{
					pet=vo;
					break;
				}				
			}
			return pet;
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
		
		
		public static function get instance():RankDyManager
		{
			if(_instance == null)
				_instance=new RankDyManager();
			return _instance;
		}

	}
} 
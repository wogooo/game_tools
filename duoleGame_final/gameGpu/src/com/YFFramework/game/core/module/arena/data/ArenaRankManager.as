package com.YFFramework.game.core.module.arena.data
{
	import com.msg.pvp.PlayerInfo;
	
	import flash.utils.Dictionary;

	/** 管理存储竞技场里所有人排名分数的类
	 * 注意：只能进入一个竞技场，所以这里每次仅存储当前进入的信息，退出会把信息全部清除
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-22 下午2:35:57
	 */
	public class ArenaRankManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ArenaRankManager;
		
		/** 以名字做索引的存BraveRankVo */		
		private var _infoDict:Dictionary;
		/** 内容与_dict，但是用来排序 */		
		private var _players:Array;
		
		private var _curArenaId:int;
		private var _enter:Boolean=false;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ArenaRankManager()
		{
		}
		
		public static function get instance():ArenaRankManager
		{
			if(_instance == null) _instance=new ArenaRankManager();
			return _instance;
		}
		//======================================================================
		//        public function
		//======================================================================
		public function initAllPlayerInfo(players:Array):void
		{
			_infoDict=new Dictionary();//先把上次信息清除
			_players=[];
			
			var rankVo:ArenaDyVo;
			for each(var player:PlayerInfo in players)
			{
				rankVo=new ArenaDyVo();
				rankVo.name=player.playerName;
				rankVo.score=player.score;
				_infoDict[rankVo.name]=rankVo;
				_players.push(rankVo);
			}
			sortPlayers();
		}
		
		public function updatePlayer(player:PlayerInfo):void
		{
			var rankVo:ArenaDyVo;
			if(_infoDict[player.playerName])//如果这个数据已经存在，就替换分数后排序
			{
				rankVo=_infoDict[player.playerName];
				rankVo.score=player.score;
				sortPlayers();
			}
			else
			{
				rankVo=new ArenaDyVo();
				rankVo.name=player.playerName;
				rankVo.score=player.score;
				_infoDict[rankVo.name]=rankVo;
				_players.push(rankVo);
				sortPlayers();
				
				while(_players.length >100)
				{
					_players.pop();
				}
			}
		}
		
		/** 返回前十信息
		 * @return 如果返回的长度为0，说明所有人的分数为0
		 */		
		public function getTop10():Array
		{
			var ary:Array=[];
			for(var i:int=0;i<10;i++)
			{
				if(_players[i] && _players[i].score > 0)
					ary.push(_players[i]);
				else if(_players[i] == null)
					break;
			}
			return ary;
		}
		
		public function getPlayerScore(name:String):int
		{
			return _infoDict[name].score;
		}

		public function get curArenaId():int
		{
			return _curArenaId;
		}

		public function set curArenaId(value:int):void
		{
			_curArenaId = value;
		}

		public function get enter():Boolean
		{
			return _enter;
		}

		public function set enter(value:Boolean):void
		{
			_enter = value;
		}

		private function sortPlayers():void
		{
			_players.sortOn("score",Array.DESCENDING|Array.NUMERIC);
		}
		
	}
} 
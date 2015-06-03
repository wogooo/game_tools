package com.YFFramework.game.core.module.character.model
{
	import com.YFFramework.core.utils.HashMap;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 下午5:27:13
	 * 
	 */
	public class TitleDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:TitleDyManager;		
		private var _titleList:HashMap;		
		private var _curTitleId:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TitleDyManager()
		{
			_titleList=new HashMap();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		
		/**
		 * 初始化已获得称号列表 
		 * @param titles
		 * 
		 */		
		public function addTitleList(titles:Array):void
		{
			var vo:TitleBasicVo;
			for each(var id:int in titles)
			{
				vo=TitleBasicManager.Instance.getTitleBasicVo(id);
				_titleList.put(id,vo);
			}
			
		}
		
		/**
		 * 获得新的称号 
		 * @param value
		 * 
		 */		
		public function setNewTitleId(titleId:int):void
		{
			var vo:TitleBasicVo=TitleBasicManager.Instance.getTitleBasicVo(titleId);
			_titleList.put(titleId,vo);
		}
		
		/** 取得称号数据
		 * @param titleId
		 * @return 
		 */		
		public function getTitle(titleId:int):TitleBasicVo
		{
			return _titleList.get(titleId);
		}
		
		/**
		 * 全部称号数据 
		 * @return 
		 * 
		 */		
		public function getAllTitleData():Array
		{
			var titleData:Array=_titleList.values();	
			return titleData;
		}

		public function get curTitleId():int
		{
			return _curTitleId;
		}

		public function set curTitleId(value:int):void
		{
			_curTitleId = value;
		}

		public static function get instance():TitleDyManager
		{
			if(_instance == null) _instance=new TitleDyManager();
			return _instance;
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
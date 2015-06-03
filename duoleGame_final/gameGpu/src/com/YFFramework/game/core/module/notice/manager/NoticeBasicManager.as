package com.YFFramework.game.core.module.notice.manager
{
	import com.YFFramework.game.core.module.notice.model.NoticeBasicVo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-16 下午5:52:50
	 */
	public class NoticeBasicManager{
		
		private static var _instance:NoticeBasicManager;
		private var _noticeDict:Dictionary = new Dictionary();
		
		public function NoticeBasicManager(){
		}
		
		public static function get Instance():NoticeBasicManager{
			return _instance ||= new NoticeBasicManager();
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var vo:NoticeBasicVo = new NoticeBasicVo();
				vo.defaultColor = jsonData[id].default_color;
				vo.fontSize = jsonData[id].font_size;
				vo.noticeContent = jsonData[id].notice_content;
				vo.noticeId = jsonData[id].notice_id;
				vo.showArea = jsonData[id].show_area;
				vo.isPublic = jsonData[id].isPublic;
				
				_noticeDict[vo.noticeId] = vo;
			}
		}
		
		public function getNoticeBasicVo(noticeId:int):NoticeBasicVo{
			return _noticeDict[noticeId];
		}
		
	}
} 
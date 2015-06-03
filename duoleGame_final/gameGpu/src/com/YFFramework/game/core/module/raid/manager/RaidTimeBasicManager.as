package com.YFFramework.game.core.module.raid.manager
{
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.module.raid.model.RaidTimeBasicVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-3 下午2:44:42
	 */
	public class RaidTimeBasicManager{
		
		private static var instance:RaidTimeBasicManager;
		private var _arr:Array = new Array();
		private var _isFirstLine:Boolean=true;
		
		public function RaidTimeBasicManager(){
		}
		
		public function cacheData(jsonData:Object):void{
			var raidTimeVo:RaidTimeBasicVo;
			for (var id:String in jsonData){
				raidTimeVo=new RaidTimeBasicVo();
				raidTimeVo.beg_time=jsonData[id].beg_time;
				raidTimeVo.end_time=jsonData[id].end_time;
				raidTimeVo.time_id=jsonData[id].time_id;
				raidTimeVo.loop_type=jsonData[id].loop_type;
				_arr.push(raidTimeVo);
			}
		}
		
		public function checkValidTime(timeId:int):Boolean{
			var crtTime:Date = TimeManager.getDateByNum(TimeManager.getServerTime());
			var len:int = _arr.length;
			for(var i:int=0;i<_arr.length;i++){
				if(_arr[i].time_id==timeId){
					var begTime:Date = TimeManager.getDateByStr(_arr[i].beg_time);
					var endTime:Date = TimeManager.getDateByStr(_arr[i].end_time);
					switch(_arr[i].loop_type){
						case 1://每天
							if(crtTime.hours>begTime.hours || crtTime.hours<endTime.hours){
								return true;
							}
							else{
								if(crtTime.hours==begTime.hours || crtTime.hours==endTime.hours){
									if(crtTime.minutes>begTime.minutes || crtTime.minutes<endTime.minutes)	return true;
									else{
										if(crtTime.minutes==begTime.minutes || crtTime.minutes==endTime.minutes){
											if(crtTime.seconds>begTime.seconds || crtTime.seconds<endTime.seconds)	return true;
										}
									}
								}
							}
							break;
					}	
				}
			}
			return false;
		}
		
		public function getTimeString(timeId:int):String{
			var timeStr:String="";
			var loopType:int;
			var len:int = _arr.length;
			for(var i:int=0;i<len;i++){
				if(_arr[i].time_id==timeId){
					switch(_arr[i].loop_type){
						case 1://每天
							timeStr+="每天：\n";
							loopType = 1;
							break;
						case 2://每周
							timeStr+="每周：\n";
							loopType = 2;
							break;
						case 3://每月
							timeStr+="每月：\n";
							loopType = 3;
							break;
					}
					break;
				}
			}
			for(i=0;i<len;i++){
				if(_arr[i].time_id==timeId){
					timeStr += parseTime(_arr[i].beg_time,loopType) + "~" + parseTime(_arr[i].end_time,loopType) + "\n";
				}
			}
			return timeStr;
		}
		
		private function parseTime(time:String,loopType:int):String{
			var retStr:String="";
			if(loopType==1){
				retStr += time.substring(8,10) + ":" + time.substring(10,12);
			}else if(loopType==2){
				var date:Date = new Date(time.substring(0,4),time.substring(4,6),time.substring(6,8));
				switch(date.day){
					case 0:
						retStr += "周日";
						break;
					case 1:
						retStr += "周一";
						break;
					case 2:
						retStr += "周二";
						break;
					case 3:
						retStr += "周三";
						break;
					case 4:
						retStr += "周四";
						break;
					case 5:
						retStr += "周五";
						break;
					case 6:
						retStr += "周六";
						break;
				}
				retStr += time.substring(8,10) + ":" + time.substring(10,12);
			}else{
				retStr += time.substring(6,8) + "日" + time.substring(8,10) + ":" + time.substring(10,12);
			}
			return retStr;
		}
		
		public static function get Instance():RaidTimeBasicManager{
			return instance ||= new RaidTimeBasicManager();
		}
	}
} 
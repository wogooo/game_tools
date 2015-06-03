package com.YFFramework.game.core.global
{
	import flash.utils.getTimer;
	
	import org.osmf.events.TimeEvent;

	/**
	 * 时间格式装换
	 * @version 1.0.0
	 * creation time：2013-6-8 下午3:40:22
	 */
	public class TimeManager{
		
		
		/** 客户端被初始化后  开始的计时器
		 */		
		private static var _loginflashRunTime:Number;
		/**登录时刻的服务端的时间
		 */		
		private static var _loginServeTime:Number;
		/**登录时候的 客户端时间
		 */		
		private static var _loginClientTime:Number;
		public function TimeManager(){
		}
		
		/**初始化 服务端的登录时间 
		 * serveTime    服务端 发过来的登录时间    服务端发过来的时间为秒 客户端为 毫秒
		 */		
		public static function  initSeverLoginTime(serveTime:Number):void
		{
			_loginServeTime=serveTime;
			_loginClientTime=(new Date().time)/1000;
			_loginflashRunTime=getTimer();
		}
		/**获取服务端的时间   返回的是秒
		 */		
		public static function getServerTime():Number
		{
			var dif:Number=(getTimer()-_loginflashRunTime)/1000;  //单位为秒
			return dif+_loginServeTime;
		}
		/**获取客户端的时间   返回的是秒
		 */		
		public static function getClientTime():Number
		{
			var dif:Number=(getTimer()-_loginflashRunTime)/1000;  //单位为秒
			return dif+_loginClientTime;
		}
		
		/**获取客户端时间 返回的是  10:17:31    这样的格式
		 */		
		public static function getClientTimeStr():String
		{
			var date:Date=new Date();
			var hours:int=date.getHours();
			var minutes:int=date.getMinutes();
			var seconds:int=date.getSeconds();
			var minutesStr:String=get2LenStr(minutes);
			var secondsStr:String=get2LenStr(seconds);
			var time:String=hours+":"+minutesStr+":"+secondsStr;
			return time;
		}
		
		/**
		 *得到当前时间 
		 * @return 当前时间到今天凌晨00:00:00的秒数
		 * 
		 */		
		public static function getNowTime():int
		{
			var date:Date=new Date();
			var hours:int=date.getHours();
			var minutes:int=date.getMinutes();
			var seconds:int=date.getSeconds();
			return hours*3600+minutes*60+seconds;
		}
		
		/**
		 *取自定义时间格式中的时分秒部分并装换成到0点的秒数 
		 * @param time 策划表示的时间格式  YYMMDDHHMMSS
		 * @return 到今天0时的秒数
		 * 
		 */		
		public static function getTimeToZero(time:Number):int
		{
			var seconds:int=time%100;
			time=time/100;
			var minutes:int=time%100;
			time=time/100;
			var hours:int=time%100;
			return hours*3600+minutes*60+seconds;
		}
		
		/**
		 *将策划表格里的时间装换成 HH:MM:SS格式 
		 */		
		public static function FormatMStime(time:int):String
		{
			var s:int=time%100;
			time/=100;
			var m:int=time%100;
			time/=100;
			var h:int=time%100;
			return get2LenStr(h)+":"+get2LenStr(m)+":"+get2LenStr(s);
		}
		
		/**获取长度为2 的字符串
		 */		
		private static function get2LenStr(num:int):String
		{
			var myStr:String=num.toString();
			if(myStr.length==1)myStr="0"+myStr;
			return myStr;
		}
		
		/**获取自1970年1月1日到今天的秒数
		 * @param timeStr 策划配置表的时间格式：年月日时分秒
		 * @return Number
		 */		
		public static function getTimeMS(timeStr:String):Number{
			var year:int = int(timeStr.substr(0,4));
			var month:int = int(timeStr.substr(4,2));
			var day:int = int(timeStr.substr(6,2));
			var hour:int = int(timeStr.substr(8,2));
			var min:int = int(timeStr.substr(10,2));
			var sec:int = int(timeStr.substr(12,2));
			var date:Date = new Date(year,month,day,hour,min,sec);
			return date.time/1000;
		}
		
		/**自1970年1月1日到今天的秒数 转成 日期
		 * @param time	自1970年1月1日到今天的秒数
		 * @return Date
		 */		
		public static function getDateByNum(time:Number):Date{
			return new Date(time*1000);
		}
		
		/**把自定义的时间格式（年月日时分秒） 转成 日期
		 * @param time	自定义的时间格式（年月日时分秒）
		 * @return Date
		 */		
		public static function getDateByStr(time:String):Date{
			var year:int = int(time.substr(0,4));
			var month:int = int(time.substr(4,2));
			var day:int = int(time.substr(6,2));
			var hour:int = int(time.substr(8,2));
			var min:int = int(time.substr(10,2));
			var sec:int = int(time.substr(12,2));
			return new Date(year,month,day,hour,min,sec);
		}
		
		/**获取时间字符串，格式1 - 2013.05.06 12:20:25
		 * @param time 自1970年1月1日到今天的秒数
		 * @return 格式1 - 2013.05.06 12:20:25
		 */		
		public static function getTimeFormat1(time:Number):String{
			var date:Date = new Date(time*1000);
			var str:String=date.fullYearUTC+".";
			
			if(date.month < 9)	str += "0"+(date.month+1)+".";
			else	str += (date.month+1)+".";
			
			if(date.date < 10)	str += "0"+date.date+" ";
			else	str += date.date+" ";
			
			if(date.hours < 10)	str += "0"+date.hours+":";
			else	str += date.hours+":";
			
			if(date.minutes < 10)	str += "0"+date.minutes+":";
			else	str += date.minutes+":";
			
			if(date.seconds < 10)	str += "0"+date.seconds;
			else	str += date.seconds;
			
			return str;
		}
		
		/**获取时间格式，返回  “时：分：秒” 的格式(如：12:24:20)
		 * @param seconds	秒数
		 * @param showHours 是否显示小时（否时，返回的格式为“分:秒”）
		 * @return String	返回  “时：分：秒” 的格式
		 */		
		public static function getTimeStrFromSec(seconds:int,showHours:Boolean=true):String{
			var str:String="";
			var time:int;
			if(showHours)
			{
				time = Math.floor(seconds/60/60);
				if(time<10)	str+="0";
				str+=time+":";
			}
			time = Math.floor(seconds/60)%60;
			if(time<10)	str+="0";
			str+=time+":";
			time = seconds%60;
			if(time<10)	str+="0";
			str+=time;
			return str;
		}
		
		/**
		 *根据时间 得到对应的描述【“刚刚”，“最近一天”...】
		 * @param time:1970 年 1 月 1 日午夜（通用时间）以来的秒数
		 * @return 传入时间到此刻的描述<br>
		 * ps:ludingchang
		 */		
		public static function getTimeDes(time:Number):String
		{
			if(time==0)
				return "在线";
			var date:Date=new Date;
			var t:Number=date.time/1000;
			var delt:Number=t-time;
			if(delt<3600)
				return "刚刚";
			else if(delt<3600*24)
				return int(delt/3600)+"小时前";
			else if(delt<3600*24*30)
				return int(delt/3600/24)+"天前";
			else if(delt<3600*24*30*12)
				return int(delt/3600/24/30)+"月前";
			else 
				return int(delt/3600/24/30/12)+"年前";
		}
		
		/** 将毫秒数转变为X天X小时X分钟的字符串
		 * @param time 毫秒数
		 * @param closeTime 是否显示“即将到期”  true->显示
		 * @return 格式：X天X小时X分钟
		 */		
		public static function getTimeFormat2(time:Number,closeTime:Boolean=true):String
		{
			var str:String='';
			var day:int=time/1000/60/60/24;
			if(day >= 1)
				str += day + "天：";
			var hour:int=(time/1000/60/60)%24;
			if(hour >= 1)
				str += hour + "小时：";
			var minute:int=(time/1000/60)%60;
			if(minute >= 1)
				str += minute + "分钟：";
			else
			{
				var second:int=(time/1000)%60;
				if(closeTime)
				{					
					if(second > 1)
						str += "即将到期";
				}
				else
					str += second + '秒';
			}
			return str;
		}
		
		/**
		 *只返回XX时 或 xx分 或 xx秒 
		 * @param time 毫秒数
		 * @return 
		 */		
		public static function getTimeFormat4(time:Number):String
		{
			var t:int;
			if(time>=3600000)
			{
				t=time/3600000;
				return t+"时";
			}
			else if(time>=60000)
			{
				t=time/60000;
				return t+"分";
			}
			else
			{
				t=time/1000;
				return t+"秒";
			}
		}
		
		/**
		 *返回“x分y秒” 
		 * @param seconds 总秒数
		 * @return x分y秒（String）
		 * 
		 */		
		public static function getTimeFormat3(seconds:int):String
		{
			var str:String=((seconds/60)<<0).toString()+"分";
			str+=((seconds%60)+"秒");
			return str;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
} 
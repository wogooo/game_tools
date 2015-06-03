package com.YFFramework.game.core.module.guild.model
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;

	/***
	 *
	 *@author ludingchang 时间：2013-7-18 下午5:11:28
	 */
	public class GuildWarningWindowHtml
	{
		/**
		 *取开除时提示文本 
		 * @param name要开除的玩家名字
		 * @return html文本
		 * 
		 */		
		public static function getDischargHtml(name:String):String
		{
			return '<font>'+"确定将成员："+'</font>'+'<u><font>'+name+'</font></u>'+'<font>'+"开除出公会？"+'</font>';
		}
		/**
		 *取移交会长的提示文本 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getChangeMasterHtml(name:String):String
		{
			return '<font>'+"确定将会长职位移交给成员："+'</font>'+'<u><font>'+name+'</font></u>'+'<font>'+"？"+'</font>';
		}
		/**
		 *取退出公会时的提示 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getExitGuildHtml(name:String):String
		{
			return '<font>'+"确定退出公会：【"+name+"】？"+'</font>';
//			return "确定退出公会：【"+name+"】？";
		}
		/**
		 *弹劾投票提示文本 
		 * @param name弹劾者
		 * @param endTime截止时间
		 * @return 
		 * 
		 */		
		public static function getImpeachHtml(name:String,endTime:Number):String
		{
			return '<font>'+"是否支持"+'</font>'+'<u><font>'+name+'</font></u>'+'<font>'+"弹劾会长，并成为新会长？"+'</font>'
				+'<br>'+'<font color="#ff0000">投票截止至：'+TimeManager.getTimeFormat1(endTime)+'</font>';
		}
		/**
		 *有人邀请你入会时的提示语句 
		 * @param inviter邀请者
		 * @param guild邀请你加入的公会
		 * @return 
		 * 
		 */		
		public static function getInviteHtml(guild:String):String
		{
			return '<font color="#fff0b6">'+"邀请你加入公会：["+guild+"]，是否同意？"+'</font>';
		}
		
		/**
		 *得到弹劾警告提示语句 
		 * @param name 会长名字
		 * @param money 弹劾消耗的贡献
		 * @return 
		 * 
		 */		
		public static function getImpeachWarningHtml(name:String,money:int):String
		{
			var roleMoney:Number=GuildInfoManager.Instence.me.contribution;
			var color:uint=0x00ff00;
			if(roleMoney<money)
				color=0xff0000;
			return '<font>'+'弹劾：'+'</font>'+'<font>'+name+'</font>'+'<br>'+'<font>'+'消耗贡献：'+'</font>'
				+'<font color="#'+color.toString(16)+'">'+money+'</font>';
		}
		
		/**
		 *得到投票提示文字 
		 * @param name 发起弹劾的人的名字
		 * @param time 投票截止时间（自1970年1月1日起的秒数）
		 * @return 
		 * 
		 */		
		public static function getVoteHtml(name:String,time:Number):String
		{
			var timeStr:String=TimeManager.getTimeFormat1(time);
			return '<font>是否支持</font><u><font color="#00cc88">'+name+'</font></u><font>弹劾会长，并成为新会长？</font>' +
				'<br><font color="#cc2244">投票截止至'+timeStr+'</font>';
		}
	}
}
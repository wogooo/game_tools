package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/***
	 *投票结果窗口
	 *@author ludingchang 时间：2013-9-5 上午11:42:05
	 */
	public class GuildVoteResult extends PopMiniWindow
	{
		private static const UIName:String="Guild_vote_result";
		
		private static var _inst:GuildVoteResult;
		
		public static function get Instence():GuildVoteResult
		{
			return _inst||=new GuildVoteResult;
		}
		
		private var _ui:Sprite;
		/**此次票数*/
		private var _yes_txt:TextField;
		/**反对票数*/
		private var _no_txt:TextField;
		/**满足条件人数*/
		private var _vote_txt:TextField;
		/**所有参与人数*/
		private var _all_txt:TextField;
		public function GuildVoteResult()
		{
			super();
			_ui=initByArgument(350,180,UIName);
			_yes_txt=Xdis.getTextChild(_ui,"yes_txt");
			_no_txt=Xdis.getTextChild(_ui,"no_txt");
			_vote_txt=Xdis.getTextChild(_ui,"vote_txt");
			_all_txt=Xdis.getTextChild(_ui,"all_txt");
		}
		public function setData(yes:int,no:int,all:int):void
		{
			_yes_txt.text=yes.toString();
			_no_txt.text=no.toString();
			_vote_txt.text=all.toString();
			_all_txt.text=(yes+no).toString();
		}
		public override function dispose():void
		{
			_yes_txt=null;
			_no_txt=null;
			_vote_txt=null;
			_all_txt=null;
			_ui=null;
			super.dispose();
		}
	}
}
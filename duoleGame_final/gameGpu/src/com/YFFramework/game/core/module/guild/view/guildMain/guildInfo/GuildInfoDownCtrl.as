package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.RoleSelfVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.msg.enumdef.MoneyType;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/***
	 *公会信息下方控制类（贡献、银锭、银币）
	 *@author ludingchang 时间：2013-8-3 下午1:56:43
	 */
	public class GuildInfoDownCtrl
	{
		private var _view:Sprite;
		/**贡献*/
		private var _contribution:TextField;
		/**银锭*/
		private var _note:TextField;
		/**银币*/
		private var _diamond:TextField;
		public function GuildInfoDownCtrl(view:Sprite)
		{
			_view=view;
			_contribution=view.getChildByName("down_txt1") as TextField;
			_note=view.getChildByName("down_txt2") as TextField;
			_diamond=view.getChildByName("down_txt3") as TextField;
			_note.textColor=0xfcc51f;
			
			_contribution.filters=FilterConfig.text_filter;
			_diamond.filters=FilterConfig.text_filter;
			_note.filters=FilterConfig.text_filter;
		}
		public function update():void
		{
			var vo:GuildMemberVo=GuildInfoManager.Instence.me;
			_contribution.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_GUILD_CONTRIBUTION)+":"+vo.contribution;
			var roleSelfVo:RoleSelfVo=DataCenter.Instance.roleSelfVo;
			_diamond.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND)+":"+roleSelfVo.diamond;
			_note.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_NOTE)+":"+roleSelfVo.note;
		}
		public function dispose():void
		{
			_view=null;
			_contribution=null;
			_diamond=null;
			_note=null;
		}
	}
}
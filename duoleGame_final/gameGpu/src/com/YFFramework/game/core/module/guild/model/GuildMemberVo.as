package com.YFFramework.game.core.module.guild.model
{
	/***
	 *
	 *@author ludingchang 时间：2013-7-16 下午4:15:56
	 */
	public class GuildMemberVo
	{
		/**id*/
		public var id:int;
		/**名字*/
		public var name:String;
		/**职位*/
		public var position:int;
		/**职业*/
		public var career:int;
		/**性别*/
		public var sex:int;
		/**等级*/
		public var lv:int;
		/**贡献*/
		public var contribution:Number;
		/**贡献最大值**/
		public var max_contribution:Number;
		/**最后登录*/
		public var last_time:Number;
	}
}
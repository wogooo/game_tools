package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.game.core.module.notice.model.TypeChannels;

	/**
	 * 聊天系统的一些设定 
	 * @author flashk
	 * 
	 */
	public class ChatSetUtil{
		/**空格的标记 
		 */
		public static var space:String = "&931803631";		
		/**系统频道的图标识别标记 
		 */
		public static var system:String = "&931803632";		
		/**世界频道的图标识别标记 
		 */
		public static var world:String = "&931803633"		
		/**附近频道的图标识别标记 
		 */
		public static var nearBy:String = "&931803637";		
		/**私聊频道的图标识别标记 
		 */
		public static var privateChannel:String = "&931803634";		
		/** 队伍频道的图标识别标记 
		 */
		public static var team:String = "&931803636";
		/**工会频道的图标识别标记 
		 */
		public static var guild:String = "&931803635";
		/**VIP等级1的图标识别标记 
		 */
		public static var vipLevel1:String = "&931803640";
		/**VIP等级2的图标识别标记 
		 */
		public static var vipLevel2:String = "&931803641";
		/**VIP等级3的图标识别标记 
		 */
		public static var vipLevel3:String = "&931803642";
		/**VIP等级4的图标识别标记 
		 */
		public static var vipLevel4:String = "&931803643";
		/**VIP等级5的图标识别标记 
		 */
		public static var vipLevel5:String = "&931803644";
		/**VIP等级6的图标识别标记 
		 */
		public static var vipLevel6:String = "&931803645";
		/**VIP等级7的图标识别标记 
		 */
		public static var vipLevel7:String = "&931803646";
		/**VIP等级8的图标识别标记 
		 */
		public static var vipLevel8:String = "&931803647";
		

		/**转换频道到RichText需要的文本图标标记 
		 * @param channel 频道
		 * @return 
		 */
		public static function getTextByChannel(channel:int):String{
			switch(channel){
				case TypeChannels.CHAT_CHANNEL_SYSTEM:
					return system;
				case TypeChannels.CHAT_CHANNEL_NEARBY:
					return nearBy;
				case TypeChannels.CHAT_CHANNEL_WORLD:
					return world;
				case TypeChannels.CHAT_CHANNEL_TEAM:
					return team;
				case TypeChannels.CHAT_CHANNEL_GUILD:
					return guild;
			}
			return "";
		}
		
		/**转换VIP到RichText需要的文本图标标记 
		 * @param vipLevel VIP等级
		 * @return 
		 */
		public static function getVipText(vipLevel:int):String{
			var str:String;
			if(vipLevel == 0){
				return "";
			}
			switch(vipLevel)
			{
				case 1:
					str = vipLevel1;
					break;
				case 2:
					str = vipLevel2;
					break;
				case 3:
					str = vipLevel3;
					break;
				case 4:
					str = vipLevel4;
					break;
				case 5:
					str = vipLevel5;
					break;
				case 6:
					str = vipLevel6;
					break;
				case 7:
					str = vipLevel7;
					break;
				case 8:
					str = vipLevel8;
					break;
				default:
					str = "";
					break;
			}
			str = " "+ str //+ space;
			return str;
		}
		
		/**将UI上的频道选择索引转换成服务器对应的频道识别数字 
		 * @param channelIndex UI索引
		 * @return  服务器的频道识别数字 
		 */
		public static function getChannelType(channelIndex:int):int{
			switch(channelIndex){
				case 0:
					return TypeChannels.CHAT_CHANNEL_SPEAKER;
					break;
				case 1:
					return TypeChannels.CHAT_CHANNEL_WORLD;
					break;
				case 2:
					return TypeChannels.CHAT_CHANNEL_GUILD;
					break;
				case 3:
					return TypeChannels.CHAT_CHANNEL_TEAM;
					break;
				case 4:
					return TypeChannels.CHAT_CHANNEL_NEARBY;
					break;
			}
			return -1;
		}
		
	}
}
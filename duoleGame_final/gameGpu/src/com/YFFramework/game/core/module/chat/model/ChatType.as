package com.YFFramework.game.core.module.chat.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-7-2 上午9:39:56
	 */
	public class ChatType{
		
		public static const Chat_Type_Props:int=1;
		public static const Chat_Type_Equip:int=2;
		public static const Chat_Type_NPC:int=3;
		public static const Chat_Type_Person:int=4;
		public static const Chat_Type_Market_Sell:int=5;
		public static const Chat_Type_Market_Buy:int=6;
		public static const Chat_Type_Team:int=7;
		public static const Chat_Type_Basic_Props:int=8;
		public static const Chat_Type_Basic_Equip:int=9;
		public static const Chat_Type_Guild:int=10;
		public static const Chat_Type_Auto_Move:int=11;
		public static const Chat_Type_GuildInfo:int=12;
		
		public function ChatType(){
		}
		
		public static function getFakeId(type:int):String{
			return "{"+type+"}";
		}
	}
}
package com.YFFramework.game.core.module.chat.manager
{
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapWorldVo;
	import com.YFFramework.game.core.module.team.model.ReqDyVo;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-7-1 下午1:33:33
	 */
	public class ChatDataManager{
		
		private static var _chatDataArr:Array = new Array();
		public static var pwd:String="";
		
		public function ChatDataManager(){
		}
		
		public static function storeData(data:ChatData):void{
			if(_chatDataArr.length>50)	_chatDataArr.shift();
			_chatDataArr.push(data);
		}
		
		public static function getChatDataArr():Array{
			return _chatDataArr;
		}
		
		public static function castData(type:int,data:Object):*{
			if(data!=null){
				switch(type){
					case ChatType.Chat_Type_Props:
						var props:PropsDyVo = new PropsDyVo();
						props.obtain_time = data.obtain_time;
						props.propsId = data.propsId;
						props.quantity = data.quantity;
						props.templateId = data.templateId;
						return props;
					case ChatType.Chat_Type_Equip:
						var equip:EquipDyVo = new EquipDyVo();
						equip.binding_type = data.binding_attr;
						equip.cur_durability = data.cur_durability;
						equip.enhance_level = data.enhance_level;
						equip.equip_id = data.equip_id;
						equip.gem_1_id = data.gem_1_id;
						equip.gem_2_id = data.gem_2_id;
						equip.gem_3_id = data.gem_3_id;
						equip.gem_4_id = data.gem_4_id;
						equip.gem_5_id = data.gem_5_id;
						equip.gem_6_id = data.gem_6_id;
						equip.gem_7_id = data.gem_7_id;
						equip.gem_8_id = data.gem_8_id;
						equip.obtain_time = data.obtain_time;
						equip.position = data.position;
						equip.template_id = data.template_id;
						equip.type = data.type;
						return equip;
					case ChatType.Chat_Type_Market_Sell:
						var record:MarketRecord = new MarketRecord();
						record.recordId = data.recordId;
						record.equip = castData(ChatType.Chat_Type_Equip,data.equip);
						record.itemId = data.itemId;
						record.itemType = data.itemType;
						record.moneyType = data.moneyType;
						record.number = data.number;
						record.playerName = data.playerName;
						record.price = data.price;
						record.props = castData(ChatType.Chat_Type_Props,data.props);
						record.saleMoneyType = data.saleMoneyType;
						return record;
					case ChatType.Chat_Type_Market_Buy:
						var buyRecord:MarketRecord = new MarketRecord();
						buyRecord.recordId = data.recordId;
						buyRecord.itemId = data.itemId;
						buyRecord.itemType = data.itemType;
						buyRecord.moneyType = data.moneyType;
						buyRecord.number = data.number;
						buyRecord.playerName = data.playerName;
						buyRecord.price = data.price;
						buyRecord.saleMoneyType = data.saleMoneyType;
						return buyRecord;
					case ChatType.Chat_Type_Team:
						var reqDyVo:ReqDyVo = new ReqDyVo();
						reqDyVo.careerReq = data.careerReq;
						reqDyVo.leaderId = data.leaderId;
						reqDyVo.powerReq = data.powerReq;
						return reqDyVo;
					case ChatType.Chat_Type_Basic_Equip:
						return data.template_id;
					case ChatType.Chat_Type_Basic_Props:
						return data.template_id;
					case ChatType.Chat_Type_Guild:
					case ChatType.Chat_Type_GuildInfo:
						var guildItemVo:GuildItemVo=new GuildItemVo;
						guildItemVo.id=data.id;
						guildItemVo.name=data.name;
						guildItemVo.lv=data.lv;
						guildItemVo.master=data.master;
						guildItemVo.member=data.member;
						guildItemVo.total=data.total;
						return guildItemVo;
					case ChatType.Chat_Type_Auto_Move:
						var smallWorldVo:SmallMapWorldVo = new SmallMapWorldVo();
						// 转换 为 像素 坐标 
						var mapPt:Point=RectMapUtil.getFlashCenterPosition(data.pos_x,data.pos_y);
						smallWorldVo.pos_x =mapPt.x;// data.pos_x;
						smallWorldVo.pos_y =mapPt.y;// data.pos_y;
						smallWorldVo.sceneId = data.sceneId;
						return smallWorldVo;
				}
			}
			return null;
		}
	}
} 
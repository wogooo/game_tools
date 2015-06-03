package com.YFFramework.game.core.module.wing.model
{
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-9-22 下午2:51:33
	 */
	public class WingEnhanceManager{
		
		/**翅膀今天已经强化的次数*/
		public var enhanced_count:int;
		/**翅膀用钱强化的次数*/
		public var money_use_count:int;
		
		/**额外可以强化的总次数*/
		public var add_count:int;
		/**普通用户一天最大次数*/
		public static const NormalMaxCount:int=10;
		/**下一阶翅膀的信息*/
		public var next_wingBasicVo:EquipBasicVo;
		
		
		private static var _instance:WingEnhanceManager;
		private var _dict:Dictionary=new Dictionary();
		
		public function WingEnhanceManager(){
		}
		
		public static function get Instance():WingEnhanceManager{
			return _instance ||= new WingEnhanceManager();
		}
		
		public function cacheData(jsonData:Object):void{
			var bvo:WingEnhanceVo;
			for (var id:String in jsonData){
				bvo=new WingEnhanceVo();
				bvo.ingredient=jsonData[id].ingredient;
				bvo.ingredientNum=jsonData[id].ingredient_num;
				bvo.money=jsonData[id].money;
				bvo.nextId=jsonData[id].next_id;
				bvo.star_num=jsonData[id].star_num;
				bvo.success_rate=jsonData[id].success_rate;
				bvo.templateId=jsonData[id].template_id;
				bvo.att = jsonData[id].att;
				bvo.count = jsonData[id].count;
				bvo.look_id = jsonData[id].look_id;
				
				_dict[bvo.templateId]=bvo;
			}
		}
		/**获取WingEnhanceVo
		 * @param id
		 * @return 
		 */		
		public function getWingEnhanceVo(id:int):WingEnhanceVo{
			return _dict[id];
		}
		
		/**是否有升级次数*/
		public function hasCount():Boolean
		{
//			return true;//test
			return NormalMaxCount+add_count-enhanced_count>0;
		}
		/**升级次数减一*/
		public function delOneCount():void
		{//等于强化次数加一
			enhanced_count++;
		}

		/**今日普通剩余次数*/
		public function get count():int
		{
			var c:int=NormalMaxCount-enhanced_count;
			if(c<0)
				return 0;
			else
				return c;
		}

		/**今日额外剩余次数*/
		public function get count_other():int
		{
			if(NormalMaxCount-enhanced_count<0)
				return add_count+NormalMaxCount-enhanced_count;
			else
				return add_count;
		}


	}
} 
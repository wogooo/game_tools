package com.YFFramework.core.world.model.type
{
	/**装备小类
	 *  大类在GoodsUtil里面
	 * 2012-7-3
	 *	@author yefeng
	 */
	public class EquipCategory
	{
		
		/** 头盔
		 */
		public static const Helmet:int=0;
		/**  武器部位
		 */
		public static const Weapon:int=1;
		/** 衣服部位
		 */
		public static const Cloth:int=2;
		/** 项链 
		 */
		public static const necklace:int=3;
		
		/**鞋子部位
		 */
		public static const shoes:int=4;
		/**腰带
		 */		
		public static const Belt:int=5;
		/**裤子
		 */
		public static const Trousers :int=6;
		/**护腕
		 */
		public static const Cuff :int=7;
		/**手套
		 */		
		public static const Glove :int=8;
		/**戒子
		 */
		public static const Ring :int=9;
		
		/**翅膀
		 */		
		public static const Wing:int=10;
		
		/**部位长度
		 */
//		public static const ModelLen:int=10;
		
		public function EquipCategory()
		{
		}
		/**根据部位拿对应的中文名称
		 */		
		public static function getModelName(modelId:int):String
		{
			switch(modelId)
			{
				/** 头盔
				 */
				case Helmet :
					return "头盔";
					break;
				/**  武器部位
				 */
				case Weapon :
				return "武器";
					break;
				/** 衣服部位
				 */
				case Cloth :
					return "上衣";
					break;
				/** 项链 
				 */
		 		case necklace  :
					return "项链";
					break;
				/**鞋子部位
				 */
				case shoes  :
					return "鞋子";
					break;
				/**腰带
				 */		
				case Belt  :
					return "腰带";
					break;
				/**裤子
				 */
				case Trousers  :
					return "裤子";
					break;
				/**护腕
				 */
				case Cuff  :
					return "护腕";
					break;
				/**手套
				 */		
				case Glove  :
					return "手套";
					break;
				/**戒子
				 */
				case Ring  :
					return "戒子";
					break;
			}
			return null;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
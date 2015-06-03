package com.YFFramework.game.core.module.DivinePulses.model
{
	/***
	 *
	 *@author ludingchang 时间：2013-11-13 下午4:10:05
	 */
	public class TypePulse
	{
		/**金*/
		public static const TYPE_ELEMENT_METAL:int=1;
		/**木*/
		public static const TYPE_ELEMENT_WOOD:int=2;
		/**水*/
		public static const TYPE_ELEMENT_WATER:int=3;
		/**火*/
		public static const TYPE_ELEMENT_FIRE:int=4;
		/**土*/
		public static const TYPE_ELEMENT_EARTH:int=5;
		/**光*/
		public static const TYPE_ELEMENT_LIGHT:int=6;
		/**暗*/
		public static const TYPE_ELEMENT_DARK:int=7;
		
		
		
		
		/**总共有7种元素*/
		public static const NUMBER_ELEMENT:int=7;
		/**每种元素下的神脉数量*/
		public static const NUMBER_SUB_PULSES:int=10;
		/**每个脉的等级数*/
		public static const LV_PULSES:int=10;
		
		
		/**根据元素得到主脉的图标ID*/
		public static function getIconIdByElement(element:int):int
		{//这里的ID是我自己暂时定义的，策划如果要改，直接修改return的值就可以了
			switch(element)
			{
				case TYPE_ELEMENT_METAL: return 1;//金元素大图标的ID，下面的同理
				case TYPE_ELEMENT_WOOD: return 2;
				case TYPE_ELEMENT_WATER: return 3;
				case TYPE_ELEMENT_FIRE: return 4;
				case TYPE_ELEMENT_EARTH: return 5;
				case TYPE_ELEMENT_LIGHT: return 6;
				case TYPE_ELEMENT_DARK: return 7;
			}
			return -1;
		}
		public function TypePulse()
		{
		}
	}
}
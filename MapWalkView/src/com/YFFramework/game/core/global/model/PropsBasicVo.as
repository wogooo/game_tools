package com.YFFramework.game.core.global.model
{
	import flash.utils.getTimer;

	public class PropsBasicVo
	{

		/**
		 * 道具模板ID
		 */		
		public var template_id:int;
		
		/**
		 * 道具名称
		 */		
		public var name:String;
		
		/**
		 * 道具类型
		 */		
		public var type:int;
		
		/**
		 * 显示类型 
		 */		
		public var show_type:String;
		
		/**
		 * 关联绑定不绑定道具 
		 */		
		public var ass_id:int;
		/**
		 * 品质
		 */		
		public var quality:int;
		
		/**
		 * 使用等级
		 */	
		public var level:int;
		
		/**
		 * 道具图标
		 */		
		public var icon_id:int;
		
		/**
		 * 冷却类型
		 */		
		public var cd_type:int;
		
		/**
		 * 冷却时间
		 */		
		public var cd_time:int;
		
		/**
		 * 使用技能ID: 净化、加血、加蓝、附加BUFF等
		 */		
		public var use_skill_id:int;
		
		/**
		 * 附加属性类型
		 */		
		public var attr_type:int;
		
		/**
		 * 附加属性数值
		 */		
		public var attr_value:int;
		
		/**
		 * 宠物ID: 宠物蛋
		 */		
		public var pet_id:int;
		
		/**
		 * 宠物技能ID
		 */		
		public var skill_id:int;
		
		/**
		 * 宠物技能等级
		 */		
		public var skill_level:int;
		
		/**
		 * 面板ID: 双击打开的面板
		 */		
		public var dialog_id:int;
		
		/**
		 * 使用条件脚本: 一些特殊的道具使用条件，调用程序写好的方法
		 */		
		public var use_condition:int;
		
		/**
		 * 使用效果脚本: 一些特殊的道具使用效果，调用程序写好的方法
		 */		
		public var use_effect:int;
		
		/**
		 * 绑定类型:不绑定、绑定
		 */		
		public var binding_type:int;
		
		/**
		 * 合成ID: 合成的产品ID
		 */		
		public var composite_id:int;
		
		/**
		 * 出售价格: 出售给NPC的价格，-1是不能出售
		 */		
		public var sell_price:int;
		
		/**
		 * 堆叠上限 
		 */		
		public var stack_limit:int;
		/**
		 * 截止时间: 固定时间（填0表示无截至时间）
		 */		
		public var deadline:int;
		
		/**
		 * 剩余时间: 剩余时间倒计时（此类道具不叠加）（填0表示无剩余时间）
		 */		
		public var remain_time:int;
		
		/**
		 * 道具描述 
		 */		
		public var describe:String;
		
		/**
		 * 效果说明
		 */		
		public var effect_desc:String;
		
		/**
		 * 使用说明
		 */		
		public var use_desc:String;

		
		private var _lastTime:Number=0;
		public function PropsBasicVo()
		{
		}
		
		public function canFire():Boolean
		{
			if(getTimer()-_lastTime>=cd_time)
			{
				_lastTime=getTimer();
				return true;
			}
			return false;
		}
		
		
	}
}
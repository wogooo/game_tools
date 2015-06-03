package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.dolo.lang.LangBasic;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-24 下午4:42:05
	 */
	public class AutoHealTip extends Sprite{
		
		public static const TypeHP:int=0;
		public static const TypeMP:int=1;
		public static const TypePet:int=2;
		
		private var _sp:Sprite;
		private var _text:TextField;
		private var _text2:TextField;
		
		public function AutoHealTip(){
			_sp = TipUtil.tipBackgrounPool.getObject();
			addChild(_sp);
			
			_text = new TextField();
			_text.x=10;
			_text.y = 5;
			_text.width=500;
			_text.textColor=TypeProps.COLOR_WHITE;
			this.addChild(_text);
			
			_text2 = new TextField();
			_text2.x=10;
			_text2.y=35;
			_text2.width=500;
			_text2.textColor=TypeProps.COLOR_WHITE;
			this.addChild(_text2);
		}
		
		/**血蓝滚动条tip
		 * @param percent
		 * @param name
		 * @param drug
		 */		
		public function setTip(percent:int,name:String,drug:String):void{
			_text.text = "您当前的设置为：\n"+name+"低于"+percent+"%时自动使用"+drug;
			_text.width=_text.textWidth+30;
			
			_text2.text = "可以拖动滑块改变自动恢复设置";
			_text2.width = _text2.textWidth+30;
			
			_sp.width = _text2.width+40;
			_sp.height = 60;
		}
		
		/**血池蓝池tip 
		 * @param remainHpPool
		 * @param text
		 */		
		public function setPoolTip(type:int):void{
			var remainHpPool:int,text:String;
			if(type==TypeHP)
			{
				remainHpPool=DataCenter.Instance.roleSelfVo.hpPool;
				text=LangBasic.Pool_HP;
			}
			else if(type==TypeMP)
			{
				remainHpPool=DataCenter.Instance.roleSelfVo.mpPool;
				text=LangBasic.Pool_MP;
			}
			else if(type==TypePet)
			{
				remainHpPool=DataCenter.Instance.roleSelfVo.petHpPool;
				text=LangBasic.Pool_Pet;
			}
			
			_text.text = text+"源泉：\n描述："+text+"值低于70%时，自动恢复20%点"+text+"\n当前存储：剩余"+text+remainHpPool+"\n冷却时间：15秒";
			_text.width=_text.textWidth+30;
			
			_sp.width = _text.width+10;
			_sp.height = 80;
		}
	}
} 
package com.YFFramework.game.core.module.gameView.view
{
	/**人物图像下面显示   buff图标
	 * @author yefeng
	 * 2013 2013-3-28 下午5:31:29 
	 */
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.view.tips.BuffTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.mapScence.manager.HeroBuffDyManager;
	import com.YFFramework.game.core.module.mapScence.manager.PetBuffDyManager;
	import com.YFFramework.game.core.module.mapScence.model.BuffDyVo;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class BuffIconView extends HContainer{
		
		private var _dict:Dictionary;
		private var _timer:Timer;
		
		public function BuffIconView(){
			super(5,false);
		}
		
		override protected function initUI():void{
			super.initUI();
			_dict=new Dictionary();
			_timer=new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			var t:Number=getTimer();
			for each(var icon:BuffIcon in _dict)
			{
				icon.updateTime(t);
			}
		}
		
		public function removeAllBuffIcon():void
		{
			this.removeChildren();
			_dict=new Dictionary;
			_timer.stop();
		}
		
		public static const TypeHero:int=0;
		public static const TypePet:int=1;
		
		/**添加buff图标*/
		public function addBuffIcon(buffId:int,type:int):void{
			var vo:BuffBasicVo=BuffBasicManager.Instance.getBuffBasicVo(buffId);
			var buff_icon:BuffIcon;
			var buffDyVo:BuffDyVo;
			if(type==TypeHero)
				buffDyVo=HeroBuffDyManager.Instance.getBuffDyVo(buffId);
			else if(type==TypePet)
				buffDyVo=PetBuffDyManager.Instance.getBuffDyVo(buffId);
			if(vo.client_show==TypeSkill.BuffShow_yes)
			{
				if(_dict[buffId]==null){//之前没有此buff,直接加
					buff_icon=new BuffIcon(buffId,vo,buffDyVo);
					_dict[buffId]=buff_icon;
					addChild(buff_icon);
					updateView();
					if(!_timer.running)
						_timer.start();
				}
				else//身上已经中了此buff,直接修改buff时间，不需再加
				{
					buff_icon=_dict[buffId];
					buff_icon.resetTime(buffDyVo);
				}
			}
		}

		/**删除buff图标*/
		public function deleteBuffIcon(buffId:int):void{
			var sp:BuffIcon=_dict[buffId] as BuffIcon;
			if(sp){
				if(contains(sp))
					removeChild(sp);
				sp.dispose();
			}
			_dict[buffId]=null;
			delete _dict[buffId];
			if(this.numChildren==0)
				_timer.stop();
			updateView();
		}
		
	}
}
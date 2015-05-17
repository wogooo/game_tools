package com.YFFramework.game.core.module.backpack.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.game.core.global.manager.GoodsBasicManager;
	import com.YFFramework.game.core.module.backpack.events.BackpackEvent;
	import com.YFFramework.game.core.module.backpack.model.MedicineBasicVo;
	import com.YFFramework.game.core.module.backpack.model.UseGoodsVo;
	
	import flash.events.Event;

	/** CD时  所有同种类型的物品 统一进行CD
	 *   具备CD播放功能功能
	 * 2012-8-21 上午10:23:59
	 *@author yefeng
	 */
	public class BackpackGoodsIconCDView extends BackpackGoodsIconView
	{
		
		
		protected var _cdView:YFCD;
		
//		protected var _maskShape:Shape;
		
		/**服务端返回 同意使用
		 */
		public static var _requestServe:Boolean;
		
		public function BackpackGoodsIconCDView()
		{
			super();
		}
		override protected function initUI():void
		{
			super.initUI();
			_cdView=new YFCD(Width,Height);
			addChild(_cdView);
//			initMask();
		}
//		protected function initMask():void
//		{
//			_maskShape=new Shape();
//			_maskShape.y=1;
//			_maskShape.x=1;
//			Draw.DrawRect(_maskShape.graphics,Width,Height,0xFF0000);
//			addChild(_maskShape)
//			this.mask=_maskShape;
//		}
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(BackpackEvent.PlayCD,onPlayerCD);
		}
		
		override protected function removeEvents():void
		{
			// TODO Auto Generated method stub
			super.removeEvents();
			removeEventListener(BackpackEvent.PlayCD,onPlayerCD);

		}
		
		/**双击事件  使用物品  隐藏 menuListView
		 */		
		override protected function dbClickFunc():void
		{
			BackpackMenuListView.Instance.hide();
			dispatchEvent(new ParamEvent(BackpackEvent.PlayCD,_goodsDyVo));
		}

		/**播放cd  请求  使用物品
		 */		
		protected function onPlayerCD(e:ParamEvent):void
		{
			/// 当没有请求服务端时 请求服务端
			if(!_requestServe)
			{
				_requestServe=true
				var useGoodsVo:UseGoodsVo=new UseGoodsVo();
				useGoodsVo.dyId=_goodsDyVo.dyId;
				YFEventCenter.Instance.dispatchEventWith(BackpackEvent.C_UseGoods,useGoodsVo);
			}
			else 
			{
				print(this,"CD冷却后再使用!");
			}
		}
		/** 播放CD
		 */		
		public function playCD():void
		{
			///播放CD 
			var goodsbasicVo:MedicineBasicVo=GoodsBasicManager.Instance.getGoodsBasicVo(_goodsDyVo.basicId) as MedicineBasicVo;
			_cdView.play(goodsbasicVo.coolTime,false,complete);
		}
		
		private function complete(obj:Object):void
		{
		//	if(_cdView)	_cdView.gotoAndStop(0);
			_requestServe=false;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_cdView=null;
		}
		
		
	}
}
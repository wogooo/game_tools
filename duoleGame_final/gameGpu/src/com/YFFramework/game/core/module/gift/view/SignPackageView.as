package com.YFFramework.game.core.module.gift.view
{
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.gift.model.SignPackageVo;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/***
	 *签到礼包页
	 *@author ludingchang 时间：2013-7-31 下午3:58:47
	 */
	public class SignPackageView
	{
		/**新手礼包数量*/
		private static const  packageNum:int=7;

		private var page:Package;
		private var selectedDay:int=1;//当前选中哪一天
		private var days:Array;

		private var progress:MovieClip;
		public function SignPackageView(view:Sprite)
		{
			var i:int,len:int=packageNum;
			days=new Array;
			for(i=1;i<=len;i++)
			{
				var day_btn:ToggleButton=Xdis.getChild(view,"day"+i+"_toggleButton");
				days.push(day_btn);
				day_btn.addMouseClickEventListener(onChange);
			}
			page=new Package;
			page.init(view);
			progress=Xdis.getMovieClipChild(view,"progress");
			progress.gotoAndStop(1);
		}
		
		protected function onChange(event:Event):void
		{
			for(var i:int=0;i<packageNum;i++)
			{
				var dy:ToggleButton=days[i];
				if(event.currentTarget==dy)
				{
					selectedDay=i+1;
					break;
				}
			}
			update();
		}
		public function update():void
		{
			var datas:Vector.<SignPackageVo>=GiftManager.Instence.newPlayerGift;
			page.setContent(datas[selectedDay-1]);
			progress.gotoAndStop(GiftManager.Instence.canGetDay);
			var i:int;
			for(i=1;i<=packageNum;i++)
			{
				(days[i-1] as ToggleButton).selected=(i==selectedDay)
			}
		}
		public function dispose():void
		{
			page.dispose();
			page=null;
		}
		
		public function onOpen():void
		{
			selectedDay=GiftManager.Instence.findSelectedDay();
			if(selectedDay>GiftManager.MAX_GIFT_DAY)//当注册天数已经大于签到的最大天数时
				selectedDay=GiftManager.MAX_GIFT_DAY;
		}
		
		public function doMoveEff():void
		{
			page.doMoveEff();
		}
	}
}
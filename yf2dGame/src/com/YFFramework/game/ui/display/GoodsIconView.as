package com.YFFramework.game.ui.display
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.GoodsBasicManager;
	import com.YFFramework.game.core.global.manager.GoodsDyManager;
	import com.YFFramework.game.core.global.model.GoodsBasicVo;
	import com.YFFramework.game.core.global.model.GoodsDyVo;
	import com.YFFramework.game.core.global.model.SkinVo;
	
	import flash.events.Event;
	
	/**游戏中图标基类
	 * 2012-8-17 上午11:45:34
	 *@author yefeng
	 */
	public class GoodsIconView extends AbsUIView
	{
		protected var _goodsDyVo:GoodsDyVo;
		protected static const Width:int=32;
		protected static const Height:int=32;
		protected var _iconContainer:AbsView;
		protected var _label:YFLabel;
		public function GoodsIconView()
		{
			super(false);
			mouseChildren=false;
		}
		override protected function initUI():void
		{
			super.initUI();
			_iconContainer=new AbsView(false);
			addChild(_iconContainer);
			initLabel();
			drawBg();
		}
		/**初始化标签
		 */ 
		protected function initLabel():void
		{
			_label=new YFLabel("1");
			_label.exactWidth();
			_label.y=Height-_label.textHeight;
			addChild(_label);
		}
		/**使标签数字居右
		 */		
		protected function rightLabel():void
		{
			_label.exactWidth();
			_label.x=Width-_label.textWidth-4;
		}
		/**更新物品个数视图
		 */		
		public function updateGoodsNumView(num:int):void
		{
			_label.text=num.toString();
			if(num>1)
			{
				if(!contains(_label)) 	addChildAt(_label,1);
				rightLabel();
			}
			else
			{
				if(contains(_label)) 	removeChild(_label);
			}
		}
		/**用来 固定视图宽高    大小为32*32
		 */	
		protected function drawBg():void
		{
			Draw.DrawRect(graphics,Width,Height,0xFF0000,0);
		}
		
		/**填入静态变量
		 */		
		public function initGoodsBasicVo(basicId:int):void
		{
			var skinVo:SkinVo=GoodsBasicManager.Instance.getSkinVo(basicId);
			var url:String=URLTool.getGoodsIcon(skinVo.iconId);
			loadIcon(url);
			if(contains(_label)) removeChild(_label);				
		}
		/**填入动态变量
		 */		
		public function initGoodsDyVo(dyId:String):void
		{
			_goodsDyVo=GoodsDyManager.Instance.getGoodsDyVo(dyId);
			var basicVo:GoodsBasicVo=GoodsBasicManager.Instance.getGoodsBasicVo(_goodsDyVo.basicId);
			initGoodsBasicVo(basicVo.basicId);
			updateGoodsNumView(_goodsDyVo.num);
		}	
		protected function loadIcon(url:String):void
		{
			var loader:UILoader=new UILoader();
			loader.initData(url,_iconContainer);
		}
		
		/**
		 * 该物品的动态vo
		 */		
		public function get goodsDyVo():GoodsDyVo
		{
			return _goodsDyVo;
		}
		/**释放内存
		 */		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_goodsDyVo=null;
			_label=null;
		}
		
		override public function get visualHeight():Number
		{
			return Width;
		}
		
		override public function get visualWidth():Number
		{
			// TODO Auto Generated method stub
			return Height;
		}
		
		
		
		
	}
}
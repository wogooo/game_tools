package com.notebook.ui.layer
{
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.display.DisplayObjectContainer;

	/**@author yefeng
	 *2012-4-20下午9:48:19
	 */
	public class LayerManager
	{
		/**根容器 包含所有的容器
		 */
		public static var RootView:DisplayObjectContainer;
	//	public static var GameSceneLayer:AbsView;

		/**包含所有的ui  所有 的ui的层的根容器  用于检测该层是否透明 来判断人物是否可走 
		 */
		public static var UIViewRoot:AbsView;
		
		/**  界面UI层  比如  任务  任务小图像 等等 之类的层  左下角聊天窗口的层
		 */ 
		public static var UILayer:AbsView;
		/** 弹出面板层   人物装备层 等等  
		 */
		public static var WindowLayer:WindowsLayer;

		/**  tips层
		 */
		public static var TipsLayer:AbsView;
		/**  menuList层
		 */		
		public static var MenuListLayer:AbsView;
		
		/**
		 *不具有交互性的一层     物品拖动 也是在该层拖动
		 */
		public static var DisableLayer:AbsView;
		
		/**  游戏广播 消息层
		 */
		public static var NoticeLayer:AbsView;
		
		/** 模态 等类似的Alert窗口弹出层
		 */
		public static var PopLayer:AbsView;
		
		
			
		public function LayerManager()
		{
		}
		public static function initLayer(rootView:DisplayObjectContainer):void
		{
			RootView=rootView;
			UIViewRoot=new AbsView(false); 
			UILayer=new AbsView(false);
			WindowLayer=new WindowsLayer();
			TipsLayer=new AbsView(false);
			MenuListLayer=new AbsView(false);
			DisableLayer=new AbsView(false);
			NoticeLayer=new AbsView(false);
			PopLayer=new AbsView(false);
			
				
			rootView.addChild(UIViewRoot);
			UIViewRoot.addChild(UILayer);
			UIViewRoot.addChild(WindowLayer);
			UIViewRoot.addChild(TipsLayer);
			UIViewRoot.addChild(MenuListLayer);
			UIViewRoot.addChild(DisableLayer);
			UIViewRoot.addChild(NoticeLayer);
			UIViewRoot.addChild(PopLayer);
			
			TipsLayer.mouseChildren=TipsLayer.mouseEnabled=false;
			DisableLayer.mouseChildren=DisableLayer.mouseEnabled=false;
	
		}
		
	}
}
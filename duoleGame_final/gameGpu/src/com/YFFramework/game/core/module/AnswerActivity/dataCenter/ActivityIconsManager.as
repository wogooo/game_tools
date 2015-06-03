package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-10 上午9:26:50
	 */
	public class ActivityIconsManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const ICON_WIDTH:int=60;
		
		private static var _instance:ActivityIconsManager;
		private var _iconsHolder:Sprite;
		/** 图标类型和ActivityIcon建立关系 */		
		private var _dict:Dictionary;
		/** 存储图标类型的显示的序列，在舞台上从右到左为0到N */		
		private var _iconsOrder:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ActivityIconsManager()
		{
			
		}
		
		public function init():void
		{
			//显示图标，打开入口
			YFEventCenter.Instance.addEventListener(GlobalEvent.showActivityIcon,startActivity);
			//活动结束，关闭入口
			YFEventCenter.Instance.addEventListener(GlobalEvent.CloseActivity,closeActivity);
			//参加活动，取消特效
//			YFEventCenter.Instance.addEventListener(GlobalEvent.JoinedActivity,joinedActivity);
			//进入特殊地图，隐藏所有入口
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterActivity,enterActivity);
			//退出特殊地图，显示所有入口
			YFEventCenter.Instance.addEventListener(GlobalEvent.QuitActivity,quitActivity);
			
			_dict=new Dictionary();
			_iconsHolder=new VContainer();
			_iconsOrder=[];
			LayerManager.UILayer.addChild(_iconsHolder);
			ResizeManager.Instance.regFunc(resize);
			resize();
		}
		
		private function  resize():void
		{
			_iconsHolder.y = 100;
			_iconsHolder.x = StageProxy.Instance.stage.stageWidth-240;//目前的图标暂定长宽60
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function startActivity(e:YFEvent):void
		{
			var obj:Object=e.param as Object;
			var sp:ActivityIcon=new ActivityIcon();
			var url:String=URLTool.getActivityIcon(obj.activityType);
			
			var loader:UILoader=new UILoader();
			loader.initData(url,sp.icon,{type:obj.activityType,holder:sp});
			loader.loadCompleteCallback=loaderComplete;
			sp.activityType=obj.activityType;
			if(_dict[obj.activityType] == null)
			{
				_dict[obj.activityType]=sp;
				_iconsOrder.push(obj.activityType);
			}	
		}
		
		private function loaderComplete(content:DisplayObject,obj:Object):void
		{
			var index:int;
			var sp:ActivityIcon=obj.holder;
			//现在_iconsOrder里找这个图标在数组的第几个
			var len:int=_iconsOrder.length;
			for(var i:int=0;i<len;i++)
			{
				if(_iconsOrder[i] == sp.activityType)
				{
					index=i;
					break;
				}
			}
			if(index == 0)
			{
				sp.x=-ICON_WIDTH;
				_iconsHolder.addChild(sp);
			}
			else
			{
				sp.x=-(index+1)*(ICON_WIDTH+3);
				_iconsHolder.addChild(sp);
			}
		}
		
		private function closeActivity(e:YFEvent):void
		{
			var activityType:int=e.param as int;
			var sp:ActivityIcon=_dict[activityType];
			if(sp && _iconsHolder.contains(sp))
			{
				_iconsHolder.removeChild(sp);
				sp.dispose();
				sp=null;
				
				_dict[activityType]=null;
				delete _dict[activityType];
				
				//再把_iconsOrder为空的删掉
				var len:int=_iconsOrder.length;
				for(var i:int=0;i<len;i++)
				{
					if(_iconsOrder[i] == activityType)
					{
						_iconsOrder.splice(i,1);
						break;
					}
				}
				
				//还要把图标全部右移
				var type:int;
				len=_iconsOrder.length;
				for(i = 0;i<len;i++)
				{
					type=_iconsOrder[i];
					sp=_dict[type];
					if(i == 0)
						sp.x=-(i+1)*ICON_WIDTH;
					else
						sp.x=-(i+1)*(ICON_WIDTH+3);
					_iconsHolder.addChild(sp);
				}
			}
			
		}
		
		/**
		 * 取消图标特效
		 */		
//		private function joinedActivity(e:YFEvent):void
//		{
//			var activityType:int=e.param as int;
//			var icon:ActivityIcon=_dict[activityType];
//			icon.closeIconEffect();
//		}
		
		private function enterActivity(e:YFEvent):void
		{
			_iconsHolder.visible=false;
		}
		
		private function quitActivity(e:YFEvent):void
		{
			_iconsHolder.visible=true;
		}
		//======================================================================
		//        getter&setter
		//======================================================================		
		public static function get instance():ActivityIconsManager
		{
			if(_instance ==null) _instance=new ActivityIconsManager();
			return _instance;
		}

	}
} 
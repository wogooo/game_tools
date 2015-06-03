package  
{           
	import app.AllInit;
	import app.ControlInit;
	import app.GameSocketConnection;
	import app.JsonLibLoader;
	import app.MainInit;
	import app.PoolFactory;
	import app.XX2dAllLoad;
	
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.image_swf.SWFSLoader;
	import com.YFFramework.core.net.loader.res.ResFileLoader;
	import com.YFFramework.game.core.module.loginNew.controller.ModulenewLgoin;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.YFFramework.game.ui.res.CommonFla;
	
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(width="1000",height="600",frameRate="60",backgroundColor="#000000")]
	public class GameGpu4 extends Sprite 
	{
		/**swf 资源列表
		 */
		private var _swfArr:Vector.<Object>;
		
		/** 策划数据表文件
		 */
		private var _fileArr:Vector.<Object>;
		private var mainInit:MainInit;
		
		/**所有资源加载完成后的回调 
		 */		 
		public var allResLodedCallback:Function;
		
		/**xx2d文件加载完成
		 */
		private var _xx2dFilesComplete:Boolean=false;
		
		/**数值表文件加载完成
		 */
		private var _jsonLibComplete:Boolean=false;
		public function GameGpu4()
		{ 
			initMenu();
		}
		private function initMenu():void
		{
			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("杭州多乐网络科技",true,false);
			menu.customItems.push(item);
			item = new ContextMenuItem("勇者之光",true,false);
			menu.customItems.push(item);
			menu.hideBuiltInItems();
			this.contextMenu=menu;
		}

		public function yf2dInit():void
		{
			var allInit:AllInit=new AllInit();
		}
              
		public function init():void
		{
			var moduleNewLogin:ModulenewLgoin=new ModulenewLgoin();
			var gameSocket:GameSocketConnection=new GameSocketConnection();
			gameSocket.initGameStart();
		}
		
		/**加载.res文件
		 */		
		private function loadResFile(progressFunc:Function):void
		{
			var resFileLoader:ResFileLoader=new ResFileLoader();
			resFileLoader.loadCompleteCallBack=resLoadComplete;
			resFileLoader.progressCallBack=progressFunc
			resFileLoader.load(ConfigManager.Instance.getResURL(),{func:progressFunc,tips:"res资源文件"});
		}
		
		private function resLoadComplete(resData:Object,data:Object):void
		{
			CommonFla.initRes(resData);
			var controlInit:ControlInit=new ControlInit();
			var progressFunc:Function=data.func;
			loadFileRes(progressFunc);  
		}
		private function controlSkinProgress(e:ProgressEvent,data:Object):void
		{
			var tips:String=data.toString();
			var percent:Number=e.bytesLoaded*100/e.bytesTotal; 
			print(this,tips+":"+percent+"%");
		}
		/** 加载游戏中常用的数值表
		 */		 
		private function loadFileRes(progressCall:Function=null):void
		{	
			var loader:JsonLibLoader=new JsonLibLoader(progressCall);
			loader.allResLodedCallback=jsonLibComplete;//allResLodedCallback;
			loader.load(ConfigManager.Instance.getJsonLibURL());
			
			//加载xx2d文件
			var xx2dAllLoader:XX2dAllLoad=new XX2dAllLoad();
			xx2dAllLoader.completeFunc=completeXX2d;
			xx2dAllLoader.loadAll();
		}  
		private function completeXX2d():void
		{
			_xx2dFilesComplete=true;
			doMain();
		}
		private function jsonLibComplete():void
		{
			_jsonLibComplete=true;
			doMain();
		}
		private function doMain():void
		{
			if(_jsonLibComplete&&_xx2dFilesComplete)	
			{
				allResLodedCallback();
			}
		}
		/**  文本加载 
		 */		
		private function filesProgress(e:ProgressEvent,currentIndex:Number):void
		{
			var percent:Number=Number(e.bytesLoaded*100/e.bytesTotal);
			print(this,"正在加载"+_fileArr[currentIndex].tips,"百分比:"+percent+"%");
		}
		/** 加载游戏UI
		 */		
		public function loadUIRes(swfsProgress:Function=null):void
		{
			_swfArr=ConfigManager.Instance.getUIList();
			var loader:SWFSLoader=new SWFSLoader();
			loader.loadCompleteCallBack=completeUILoad;
			loader.progressCallBack=swfsProgress;
			loader.load(_swfArr,swfsProgress);
			PoolFactory.initBlinkPool();
			PoolFactory.initMovie();
		}  
		
		private function uiProgress(e:ProgressEvent,currentIndex:Number):void
		{
			var percent:Number=Number(e.bytesLoaded*100/e.bytesTotal);
			print(this,"正在加载"+_swfArr[currentIndex].tips,"百分比:"+percent+"%");
		}
		private function completeUILoad(data:Object=null):void
		{
			loadResFile(data as Function);
			PoolFactory.initTile();
		}
		
	}
}
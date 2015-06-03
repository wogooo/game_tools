package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideUtil;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClip;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.TypeTask;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.MovieClipTabs;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**任务小面板 
	 * @author flashk
	 */
	public class TaskMiniPanel extends Panel{
		
		private static var _ins:TaskMiniPanel;
		
		private var _ui:Sprite;
		//private var _tabs:MovieClipTabs;
		private var _tabs:TabsManager;
		private var _sp1:Sprite;
		private var _sp2:Sprite;
		private var _sp3:Sprite;
		private var _txtNow:RichTextSprite;
		private var _txtAble:RichTextSprite;
		private var _dragBtn:SimpleButton;
		private var _miniBtn:SimpleButton;
		public var _isMiniNow:Boolean = false;
		private var _openBtnSprite:Sprite;
		private var _scrollBar1:VScrollBar;
		private var _scrollBar2:VScrollBar;
		private var _clickCount:int = 0;
		private var _doTime:int = 0;
		private var _isReutrn:Boolean = false;
		
		/**新手引导 红色 黄色相互切换的动画 矩形 movie
		 */
		private var _newGudieMovie:NewGuideMovieClip;
		
		public function TaskMiniPanel(){
			_ins =this;
			_isResizeResetXY = false;
			_closeButton.visible = false;
			_ui = ClassInstance.getInstance("TaskMiniPanelUI");
			AutoBuild.replaceAll(_ui);
			content = _ui;
//			_tabs = new MovieClipTabs();
			_tabs = new TabsManager();
			_tabs.isRemoveChild = false;
			
			
			_scrollBar1 = Xdis.getChild(_ui,"tabView1","list_vScrollBar");
			_scrollBar2 = Xdis.getChild(_ui,"tabView2","list_vScrollBar");
			_sp1 = Xdis.getChild(_ui,"tabView1");
			_sp2 = Xdis.getChild(_ui,"tabView2");
			_sp3 = new Sprite();
			_sp3.name = "tabView3";
			_ui.addChild(_sp3);
			
			_tabs.initTabs(_ui,"tabs_mc",3,"tabView");
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onIndexChange);
//			_tabs.initTabs(_ui,"tabs_mc",3);
//			_tabs.addEventListener(MovieClipTabs.INDEX_CHANGE,onIndexChange);
			_txtNow = new RichTextSprite();
			//_txtNow.y=15;
			_txtAble = new RichTextSprite();
			//_txtAble.y=15;
			_sp1.addChild(_txtNow);
			_sp2.addChild(_txtAble);
			_dragBtn = Xdis.getChild(_ui,"drag_btn");
			setDragTarget(_dragBtn);
			_miniBtn = Xdis.getChild(_ui,"mini_btn");
			_miniBtn.addEventListener(MouseEvent.CLICK,onMiniBtnClick);
			Xtip.registerTip(_miniBtn,"最小化");
			Xtip.registerTip(_dragBtn,"拖动面板");
			_openBtnSprite = ClassInstance.getInstance("ui.TaskMiniOpen");
			_openBtnSprite.visible = false;
			_openBtnSprite.addEventListener(MouseEvent.CLICK,onMiniBtnClick);
			_scrollBar1.setTarget(_txtNow,false,235,180);
			_scrollBar2.setTarget(_txtAble,false,235,180);
			
			_newGudieMovie=new NewGuideMovieClip();
			_newGudieMovie.start();
		}
		
		public function get tabs():TabsManager{
			return _tabs;
		}
		/**优化  新手引导的   触发   是否在 等待  触发   ,延迟 触发   因为 triggerFirst的触发涉及到A星寻路 这个函数的触发是比较消耗时间的
		 */		
		private var _hasWaitForTrigger:Boolean=false;//是否在 等待  触发 
		/**自动触发 富文本 开始寻路
		 */		
		public  function autoTrigger():Boolean
		{
		//如果 有两个 主线 也就是 请问完成但是没有返回的时候 这个时候不触发新手引导
			var arr:Vector.<TaskDyVo>=TaskDyManager.getInstance().getMainTrunkVoArr();  //有时候是 主线任务  更新了可接列表 但是可完成列表还没有刷新的情况下
			var len:int=arr.length;
//			var isInAbleList:Boolean;
			for(var i:int=0;i!=len;++i)
			{
				var taskDyVo:TaskDyVo=arr[i];
				if(!taskDyVo.isSubmit) //当任务不处于提交状态 
				{
					if(taskDyVo.taskListType==TaskDyVo.CurrentList)	
					{
						if(_txtNow.richTextNum>0) //当前任务列表
						{
						//	_txtNow.triggerFirst();
							if(!_hasWaitForTrigger)
							{
								handleGuide(); 
								var timeOut:TimeOut=new TimeOut(300,handletrigger,_txtNow);
								timeOut.start();
								_hasWaitForTrigger=true;
								
							}
							return true ;
						}
					}
					if(taskDyVo.taskListType==TaskDyVo.AbleList)	
					{
						if(_txtAble.richTextNum>0) //可接任务列表
						{
							handleGuide();
							_txtAble.triggerFirst();
							return true ;
						}
					}
					
				}
			}
			return false;
		}
		
		/**引导
		 */		
		private function handleGuide():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
			{
				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
				NewGuideMovieClipWidthArrow.Instance.initGuideRight(0,0);
			}
			else 
			{
				NewGuideMovieClipWidthArrow.Instance.removeParent(this);
			}
				
			
		}
		
		private function handletrigger(_txtNow:RichTextSprite):void
		{
			_txtNow.triggerFirst();
			_hasWaitForTrigger=false;
		}
		
		/**触发 小飞鞋
		 */
		public  function flyBootTrigger():Boolean
		{
			//如果 有两个 主线 也就是 请问完成但是没有返回的时候 这个时候不触发新手引导	
			var arr:Vector.<TaskDyVo>=TaskDyManager.getInstance().getMainTrunkVoArr();  //有时候是 主线任务  更新了可接列表 但是可完成列表还没有刷新的情况下
			var len:int=arr.length;
			//			var isInAbleList:Boolean;
			for(var i:int=0;i!=len;++i)
			{
				var taskDyVo:TaskDyVo=arr[i];
				if(taskDyVo.taskListType==TaskDyVo.CurrentList)	
				{
					if(_txtNow.richTextNum>0) //当前任务列表
					{
						_txtNow.triggerFirstFlyBoot();
						return true ;
					}
				}
				if(taskDyVo.taskListType==TaskDyVo.AbleList)	
				{
					if(_txtAble.richTextNum>0) //可接任务列表
					{
						_txtAble.triggerFirstFlyBoot();
						return true ;
					}
				}
			}
			return false;
		}

		private function exeFunc(obj:Object):void{	
		}
		
		private function flyExeFunc(obj:Object):void{
		}
		
		private function exeFuncAble(obj:Object):void{
			TaskViewAndOperate.getInstance().ableTextUserClick(obj);
		}
		
		private function flyExeFuncAble(obj:Object):void{
			TaskViewAndOperate.getInstance().flyExeFunc(obj);
		}
		/**更新可接任务列表
		 * triggeTask 是否进行新手引导自动寻路
		 */		
		public function updateAbleTask(vos:Vector.<TaskDyVo>,triggeTask:Boolean=true):void{
			_txtAble.clear();
			var len:int = vos.length;
			var taskBasicVo:TaskBasicVo;
//			var guideTxt:String=null;// 要引导的文字  
//			var richText:RichText;
//			var temTxt:String;
//			var obj:Object;//新手 引导
			for(var i:int=0;i<len;i++){
				taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(vos[i].taskID);
				addText(_txtAble,TaskUtil.getTypeString(taskBasicVo.task_type)+taskBasicVo.name+"{#F9F8AE|[可接]}",vos[i].taskID);
				addTextAble(_txtAble,taskBasicVo.accept_desc,vos[i].taskID,true);
//				temTxt=obj.guideTxt;
//				if(guideTxt==null)
//				{
//					guideTxt=temTxt;
//					richText=obj.richText;
//				}
			}
			_scrollBar2.updateSize(_txtAble.viewHeight);
//			if(richText)initNewGuide(richText,guideTxt);
		//	trace("able task time:"+(getTimer()-t));
//			autoTrigger();
			if(triggeTask)
			{
				NewGuideManager.DoGuide();
			}
		}
		/**创建新手引导
		 */		
		private function initNewGuide(richText:RichText,guideTxt:String):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
			{
				var holder:Sprite=richText.parent as Sprite;
				var rect:Rectangle=NewGuideUtil.getGuideTextRect(richText.getTextField(),guideTxt);
				_newGudieMovie.initRect(richText.x+rect.x,richText.y+rect.y,rect.width,rect.height,null);
				_newGudieMovie.setTips(guideTxt,this);
				holder.addChild(_newGudieMovie);
			}
		}
		
		private function addTextAble(target:RichTextSprite,textStr:String,data:Object,isSpace:Boolean=false):Object
		{
			if(isSpace == true){
//				textStr = " "+textStr;
			}
			return target.addNewLine(textStr,exeFuncAble,flyExeFuncAble,data,isSpace); 
		}

		/**初始化
		 */		
		public function init():void{
			open();
			LayerManager.UILayer.addChild(this);
			Align.toRight(this,true,-230,230);
			LayerManager.UILayer.addChild(_openBtnSprite);
			Align.toRight(_openBtnSprite,true,0,230);
		}
		
		/**更新当前任务列表
		 * triggeTask 是否进行新手引导自动寻路
		 */		
		public function updateCurrentTask(triggeTask:Boolean=true):void{
			var newGuideObj:Object;//新手 引导数据
			_txtNow.clear();
			var vo:TaskDyVo;
			var bvo:TaskBasicVo;
			var nowTaskList:Vector.<TaskDyVo>=TaskDyManager.getInstance().nowTaskList;
			var len:int=nowTaskList.length;
			var taskBasicVo:TaskBasicVo;
			for(var i:int=0;i<len;i++){
				vo=nowTaskList[i];
				bvo=TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);
				var stateStr:String = "进行中";
				var color:String = "#F9F8AE";
				var nameF:String ="";
				var nameE:String = "";
				if(vo.isFinish == true){
					stateStr = "可提交";
					color = "#55FC68";
					nameF =  "{#55FC68|";
					nameE = "}";
				}
				addText(_txtNow,TaskUtil.getTypeString(bvo.task_type)+nameF+bvo.name+nameE+"{"+color+"|["+stateStr+"]}",bvo.task_id);
				newGuideObj=TaskViewAndOperate.getInstance().viewOneNowTask(_txtNow,vo);
				if(newGuideObj)
				{
					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);
					if(taskBasicVo.task_type!=TypeTask.TASK_TYPE_TRUNK) newGuideObj=null;
				}
			}
			_scrollBar1.updateSize(_txtNow.viewHeight);
			
			if(newGuideObj)// {guideTxt:guideTxt,richText:rt};
			{
				if(newGuideObj.guideTxt)initNewGuide(newGuideObj.richText,newGuideObj.guideTxt); 
			}
//			autoTrigger();
			if(triggeTask)	NewGuideManager.DoGuide();
		}
		
		private function addText(target:RichTextSprite,textStr:String,data:Object,isSpace:Boolean=false):void{
			if(isSpace)	textStr = " "+textStr;
			target.addNewLine(textStr,exeFunc,flyExeFunc,data); 
		}
		
		public static function getInstance():TaskMiniPanel{
			return _ins;
		}
		
		/**切换Tab
		 * @param event
		 */		
		protected function onIndexChange(event:Event):void{
			if(_tabs.nowIndex == 3){
				//_tabs.backToLastTab();
				_tabs.switchToTab(1);
				TaskWindow.getInstance().switchOpenClose();
			}
		}
		
		/**最少化面板
		 * @param event
		 */		
		public function onMiniBtnClick(event:MouseEvent=null):void{
			_isMiniNow = !_isMiniNow;
			if(_isMiniNow == true){
				TweenLite.to(this,0.36,{onComplete:onMinied,ease:Cubic.easeOut,x:UI.stage.stageWidth+20,y:230});
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}else{
				this.visible = true;
				this.x = UI.stage.stageWidth+100;
				_openBtnSprite.visible = false;
				this.mouseChildren = false;
				this.mouseEnabled = false;
				setTimeout(setMeClickAble,500);
				TweenLite.to(this,0.4,{ease:Cubic.easeOut,x:UI.stage.stageWidth-230,y:230});
			}
		}
		/**重置
		 */		
		private function setMeClickAble():void{
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		/**最小化
		 */		
		private function onMinied():void{
			this.visible = false;
			_openBtnSprite.visible = true;
			_openBtnSprite.alpha = 0;
			TweenLite.to(_openBtnSprite,0.8,{ease:Cubic.easeOut,alpha:1});
		}
		
	}
}
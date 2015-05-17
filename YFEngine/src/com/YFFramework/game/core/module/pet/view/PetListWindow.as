package com.YFFramework.game.core.module.pet.view
{
	/**宠物列表面板   依据  PetDyManager 数据来创建UI
	 * @author yefeng
	 *2012-9-25下午9:27:27
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFScroller;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class PetListWindow extends GameWindow
	{
		private var _vContainer:VContainer;
		private var _scroller:YFScroller;
		/**保存 petListCellView对象 用于该对象的ui更新
		 */		
		private var _uiDict:Dictionary;
		
		/**详细按钮
		 */		
		internal var xiangXiBtn:YFButton;
		/**丢弃按钮
		 */		
		internal var diuQiBtn:YFButton;
		private var _selectPetListView:PetListCellView;
		public function PetListWindow()
		{
			super(270,380);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_vContainer=new VContainer(10);
			_scroller=new YFScroller(_vContainer,270);
			addChild(_scroller);
			_scroller.y=_bgBody.y+7;
			_vContainer.x=10;
			///详细按钮
			xiangXiBtn=new YFButton(Lang.XiangXi);
			addChild(xiangXiBtn);
			xiangXiBtn.x=15;
			xiangXiBtn.y=340;
			///丢弃按钮
			diuQiBtn=new YFButton(Lang.Diu_Qi);
			addChild(diuQiBtn);
			diuQiBtn.x=85;
			diuQiBtn.y=340;

		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_vContainer.addEventListener(MouseEvent.MOUSE_DOWN,onMyEvent);
		}
		
		private function onMyEvent(e:MouseEvent):void
		{ 
			print(this,"petListView::",e.target,e.target.parent);	
			var petView:PetListCellView=e.target as PetListCellView;
			if(petView==null) petView=e.target.parent as PetListCellView;
			if(petView)
			{
				setSelect(petView);
			}
			
		}
		
		private function setSelect(petListCellView:PetListCellView ):void
		{
			var len:int=_vContainer.numChildren;
			var cell:PetListCellView;
			for (var i:int=0;i!=len;++i)
			{
				cell=_vContainer.getChildAt(i) as PetListCellView;
				if(cell!=petListCellView) cell.select=false;
				else cell.select=true;
			}
			_selectPetListView=petListCellView;
			dispatchEvent(new ParamEvent(PetEvent.PetListCellViewSelect));  ///发送被选中的事件
		}
		/**得到当前选中的宠物UI
		 */		
		internal function getSelect():PetListCellView
		{
			return _selectPetListView;
		}
		
		/**更新 宠物面板列表   根据 PetDyManager  的数据创建Ui
		 */ 
		public function updatePetListView():void
		{
			///移除先前的对象
			_vContainer.removeAllContent(true);
			_selectPetListView=null;
			_uiDict=new Dictionary();
			var arr:Array=PetDyManager.Instance.getPetList();
			//创建  ui 
			var len:int=arr.length;
			if(len>0)
			{
				var petDyVo:PetDyVo;
				var petListCellView:PetListCellView;
				for(var i:int=0;i!=len;++i)
				{
					petDyVo=arr[i];
					petListCellView=new PetListCellView(petDyVo);
					_vContainer.addChild(petListCellView);
					_uiDict[petDyVo.dyId]=petListCellView;
				}
				_vContainer.updateView();
				_scroller.updateView();
				setSelect(_vContainer.getChildAt(0) as PetListCellView);  ///选中第一个
			}
			else setSelect(null);
		}
		
		/**更新品质
		 */		
		public function updateQuality(dyId:String,quality:int):void
		{
			var petListCellView:PetListCellView=_uiDict[dyId];
			petListCellView.updateQuality(quality);
		}
		/**更新等级
		 */		
		public function updateLevel(dyId:String,level:int):void
		{
			var petListCellView:PetListCellView=_uiDict[dyId];
			petListCellView.updateLevel(level);
		}
		/**更新宠物名称
		 */		
		public function updateName(dyId:String,name:String):void
		{
			var petListCellView:PetListCellView=_uiDict[dyId];
			petListCellView.updateName(name);
		}

		/**更新宠物出战状态
		 */		
		public function updatePetPlay(dyId:String,petPlay:Boolean):void
		{
			var petListCellView:PetListCellView=_uiDict[dyId];
			petListCellView.updatePetPlay(petPlay);
		}
		
		
		
		
	}
}
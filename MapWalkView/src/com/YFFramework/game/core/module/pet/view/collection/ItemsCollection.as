package com.YFFramework.game.core.module.pet.view.collection
{
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.pet.view.grid.Item;
	
	import flash.display.Sprite;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-18 下午7:08:13
	 * 
	 */
	public class ItemsCollection extends Sprite{
		
		private var _items:Vector.<Item>;
		
		public function ItemsCollection(posX:int,posY:int){
			this.x = posX;
			this.y = posY;
			_items=new Vector.<Item>();
		}

		/**把道具全部加载到容器里面
		 * selectable:可以加滤镜；mustload:无论是否有道具都加载（可以快速购买）;boundable：道具能否绑定
		 * 需要改动，等道具表配好后要把boundable去掉
		 **/
		public function loadContent(startId:int,endId:int,selectable:Boolean,mustLoad:Boolean=true):void{
			var index:int=0;
			for(var i:int=startId;i<=endId;i++){
				var quantity:int= PropsDyManager.instance.getPropsQuantity(i);
				var iconURL:String = PropsBasicManager.Instance.getURL(i);
				var name:String = PropsBasicManager.Instance.getPropsBasicVo(i).name;
				if(mustLoad==true || (mustLoad==false && quantity>0)){
					var item:Item = new Item(index,selectable);
					item.updateItem(i,iconURL,name,quantity);
					_items.push(item);
					addChild(item);
					index++;
				}
			}
		}
		
		/**把道具全部加载到容器里面 
		 * @param objArr	要加载道具的PropsBasicVo Array
		 * @param selectable	Boolean值，true:道具可以选中；false：道具不能选中
		 */		
		public function loadDyContent(objArr:Array,selectable:Boolean):void{
			var index:int=0;
			for(var i:int=0;i<objArr.length;i++){
				var quantity:int= PropsDyManager.instance.getPropsQuantity(objArr[i].template_id);
				var iconURL:String = PropsBasicManager.Instance.getURL(objArr[i].template_id);
				var name:String = PropsBasicManager.Instance.getPropsBasicVo(objArr[i].template_id).name;
				if(quantity>0){
					var item:Item = new Item(index,selectable);
					item.updateItem(objArr[i].template_id,iconURL,name,quantity);
					_items.push(item);
					addChild(item);
					index++;
				}
			}
		}
		
		public function getIconURL(index:int):String{
			return _items[index].getIconURL();
		}
		
		/**
		 * 指定对象进行filter.如果index=-1,清空全部filter
		 **/
		public function setFilter(index:int):void{
			for(var i:int=0;i<_items.length;i++){
				_items[i].filters=null;
			}
			if(index!=-1)
				_items[index].filters = FilterConfig.white_glow_filter;
		}
		
		/**
		 * 把全部内容清除
		 **/
		public function clearItem():void{
			for(var i:int=0;i<_items.length;i++){
				removeChildAt(0);
			}
			_items = new Vector.<Item>();
		}
	}
} 